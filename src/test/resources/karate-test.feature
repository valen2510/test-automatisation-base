Feature: Test de Marvel API

  Background:
    * configure ssl = true

    @id:1 @ConsultaPersonajes @solicitudExitosa200
      Scenario: Consulta todos los personajes marvel responde 200
      Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
      When method get
      Then status 200
      And match response == '#[]'
      And response.length > 0
      And match response[0] contains { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: #[] }

    @id:2 @CreacionPersonaje @solicitudExitosa201
      Scenario: Crear un personajes marvel responde 201
        * def uuid = java.util.UUID.randomUUID() + ''
        * def newCharacter = read('classpath:../MarvelApi/MAcreacionPersonaje.json')
        * set newCharacter.name = newCharacter.name + '-' + uuid
        Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
        And request newCharacter
        When method post
        Then status 201
        * def data = { characterId: characterId }
        * karate.write(data, 'target/characterId.json')
        And match response contains { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: #[] }

    @id:3 @CreacionPersonajeDuplicado @solicitudFallida400
      Scenario: Crear un personajes marvel que ya existe responde 400
        * def newCharacter = read('classpath:../MarvelApi/MAcreacionPersonaje.json')
        Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
        And request newCharacter
        When method post
        Then status 400
        And response.error == 'Character name already exists'

      @id:4 @CreacionPersonajeIncompleto @solicitudFallida400
        Scenario: Crear un personajes marvel sin los campos requeridos responde 400
          * def newCharacter = read('classpath:../MarvelApi/MAcreacionPersonajeIncompleto.json')
          Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
          And request newCharacter
          When method post
          Then status 400
          And match response.name == 'Name is required'
          And match response.description == 'Description is required'
          And match response.powers == 'Powers are required'
          And match response.alterego == 'Alterego is required'

      @id:5 @ObtenerPersonajeID @solicitudExitosa200
        Scenario: Obtiene un personajes marvel por el ID responde 200
        * def result = call read('classpath:MAcreacionPersonaje.feature')
        * def characterId = result.characterId
          Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/' + characterId
          When method get
          Then status 200
          And print response

      @id:6 @ObtenerPersonajeIDNoExistente @solicitudFallida404
        Scenario: Obtiene un personajes marvel por el ID que no existe responde 404
          Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/999'
          When method get
          Then status 404
          And match response.error == 'Character not found'

      @id:7 @ActualizarPersonaje @solicitudExitosa200
        Scenario: Actualiza un personajes marvel responde 200
          * def result = call read('classpath:MAcreacionPersonaje.feature')
          * def characterId = result.characterId
          Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/' + characterId
          And request updateCharacter
          When method put
          Then status 200
          And print response

      @id:8 @ActualizarPersonajeNoExistente @solicitudFallida404
        Scenario: Actualiza un personajes marvel que no existe responde 404
          * def updateCharacter = read('classpath:../MarvelApi/MAactualizaPersonaje.json')
          Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/999'
          And request updateCharacter
          When method put
          Then status 404
          And match response.error == 'Character not found'

      @id:9 @EliminarPersonaje @solicitudExitosa200
        Scenario: Elimina un personajes marvel responde 200
        * def result = call read('classpath:MAcreacionPersonaje.feature')
        * def characterId = result.characterId
          Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/'  + characterId
          When method delete
          Then status 200
          And print response

      @id:10 @EliminarPersonajeNoExistente @solicitudFallida404
        Scenario: Elimina un personajes marvel que no existe responde 404
          Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/9999'
          When method delete
          Then status 404
          And match response.error == 'Character not found'



