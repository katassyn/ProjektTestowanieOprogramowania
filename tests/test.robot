*** Settings ***
Library     RequestsLibrary

*** Variables ***
${BASE_URL}     http://localhost:8000

*** Test Cases ***
API Is Running
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /
    Should Be Equal As Integers    ${response.status_code}    200
