*** Settings ***
Documentation    Principais Keyworkds Utilizadas no Projeto

*** Variables ***
${url_google}    https://www.google.com

*** Keywords ***
Imprimir Mensagem
    [Documentation]    Imprimi Olã Mundo
    Log To Console    message=Hello Mundo!!!

Imprimir Text
    Log To Console    message=Segunda-feira