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