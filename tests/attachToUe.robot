*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    http://localhost:8000

*** Test Cases ***
Attach UE Successfully
    Create Session    api    ${BASE_URL}
    ${response}=    POST On Session    api    /ues    data={"ue_id": 1}
    Should Be Equal As Integers    ${response.status_code}    200

Attach UE Out Of Range
    Create Session    api    ${BASE_URL}
    ${response}=    POST On Session    api    /ues    data={"ue_id": 101}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    422

Attach UE Already Connected
    Create Session    api    ${BASE_URL}
    POST On Session    api    /ues    data={"ue_id": 2}
    ${response}=    POST On Session    api    /ues    data={"ue_id": 2}    expected_status=any
    Should Not Be Equal As Integers    ${response.status_code}    200

Attach UE Creates Default Bearer
    Create Session    api    ${BASE_URL}
    POST On Session    api    /ues    data={"ue_id": 3}
    ${response}=    GET On Session    api    /ues/3
    Should Be Equal As Integers    ${response.status_code}    200