#Przygotowywal Maksymilian Stuglik i Kamil Gębala
*** Settings ***
Library   Collections
Library   String
Library   requests

*** Variables ***
${MIN_UE_ID}    0
${MAX_UE_ID}    100
${DEFAULT_BEARER}    9

*** Keywords ***

Setup Network States
    ${CONNECTED_UES}=    Create List
    Set Suite Variable    ${CONNECTED_UES}
    ${UE_BEARERS}=    Create Dictionary
    Set Suite Variable    ${UE_BEARERS}

Attach UE to Network
    [Arguments]    ${ue_id}
    IF    ${ue_id} < ${MIN_UE_ID} or ${ue_id} > ${MAX_UE_ID}
        Fail    UE ID ${ue_id} jest poza zakresem (0-100)
    END
    ${is_conn}=    Check if UE Connected    ${ue_id}
    IF    ${is_conn}
        Fail    UE ${ue_id} jest juz podlaczony do sieci
    END
    Add UE to connected    ${ue_id}
    Assign Default Bearer    ${ue_id}    ${DEFAULT_BEARER}

Check if UE Connected
    [Arguments]    ${ue_id}
    ${result}=    Evaluate    int(${ue_id}) in [int(x) for x in $CONNECTED_UES]
    RETURN    ${result}

Add UE to connected
    [Arguments]    ${ue_id}
    Append To List    ${CONNECTED_UES}    ${ue_id}

Assign Default Bearer
    [Arguments]    ${ue_id}
    ${result} =    Check if UE Connected    ${ue_id}
    Should Be True    ${result}    UE ${ue_id} nie jest polaczony

Verify Default Bearer Assigned
    [Arguments]    ${ue_id}
    ${bearer}=    Get From Dictionary    ${UE_BEARERS}    ${ue_id}
    Should Be Equal As Numbers    ${bearer}    ${DEFAULT_BEARER}    Oczekiwano ID=${DEFAULT_BEARER}, otrzymano ${bearer}

*** Test Cases ***
