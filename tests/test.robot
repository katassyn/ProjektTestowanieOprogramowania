*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    http://localhost:8000

*** Keywords ***
Create API Session
Create Session    api    ${BASE_URL}

*** Test Cases ***

