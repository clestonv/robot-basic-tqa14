*** Settings ***
Documentation    Configuração inicais do projeto

## Importando as Bibliotecas
Library    RequestsLibrary
Library    ../resources/libs/get_fake_person.py

*** Variables ***
${baseUrl}    https://develop.qacoders-academy.com.br/api/

*** Test Cases ***
# REQUEST POST
CT01 - Realizar login com sucesso
    ${resposta}    Realizar Login    email=sysadmin@qacoders.com    password=1234@Test
    Status Should Be    200    ${resposta}
    
CT02 - Realizar login com senha Inválida
    ${resposta}    Realizar Login    email=sysadmin@qacoders.com    password=1234@Test
    Status Should Be    400    ${resposta}
    Should Be Equal    E-mail ou senha informados são inválidos.    ${resposta.json()["alert"]}

CT03 - Realizar login com email Inválida
    ${resposta}    Realizar Login    email=sysadmin@qacoders.com.br    password=1234@Testi

    

*** Keywords ***
Criar Sessao
    [Documentation]    Criando sessão inicial para usar nas proximas requests
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json    
    Create Session    alias=develop    url=${baseUrl}    headers=${headers}    verify=True

Pegar Token    
    [Documentation]    Request usada para pegar o token do admin
    ${body}    Create Dictionary    
    ...    mail=sysadmin@qacoders.com    
    ...    password=1234@Test
    Criar Sessao
    ${response}    POST On Session    alias=develop    url=/login    json=${body}
    RETURN    ${response.json()["token"]}

Realizar Login
    [Documentation]    Realizando Login
    [Arguments]    ${email}    ${password}
    ${body}    Create Dictionary    
    ...    mail=${email}    
    ...    password=${password}
    Criar Sessao
    ${response}    POST On Session    alias=develop    expected_status=any    	url=/login    json=${body}
    RETURN    ${response} 


Create User
    ${person}    Get Fake Person
    ${token}    Pegar Token
    ${body}    Create Dictionary
    ...    fullName=${person}[name]    
    ...    mail=${person}[email]
    ...    password=1234@Test
    ...    accessProfile=ADMIN
    ...    cpf=${person}[cpf]
    ...    confirmPassword=1234@Test
    ${resposta}    POST On Session    
    ...    alias=develop    
    ...    url=/user/?token=${token}    
    ...    json=${body}
    Status Should Be    201    ${resposta}
    RETURN    ${resposta.json()["user"]["_id"]}

Cadastro Sucesso
    ${user_ID}    Create User
    Get User    ${user_ID}
    Delete User    id_user=${user_ID}

Get User    
    [Arguments]    ${id_user}
    ${token}    Pegar Token
    ${resposta}    GET On Session    alias=develop    url=/user/${id_user}?token=${token}
    RETURN    ${resposta}
    
Delete User
    [Arguments]    ${id_user}
    ${token}    Pegar Token
    ${resposta}    DELETE On Session    alias=develop    url=/user/${id_user}?token=${token}
    RETURN    ${resposta}
    
Put Status
    [Arguments]    ${id_user}    ${status}
    ${token}    Pegar Token
    ${body}    Create Dictionary    status=${status}
    ${resposta}    PUT On Session    alias=develop    url=/user/status/${id_user}?token=${token}    json=${body}
    RETURN                     ${resposta.json()}