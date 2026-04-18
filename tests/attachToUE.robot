#Przygotowywal Maksymilian Stuglik i Kamil Gębala
*** Settings ***
Library   Collections
Library   String

*** Variables ***
${MIN_UE_ID}    0
${MAX_UE_ID}    100
${DEFAULT_BEARER}    9

*** Keywords ***

Setup Network State
    ${CONNECTED_UES}=    Create List
    Set Suite Variable    ${CONNECTED_UES}
    ${UE_BEARERS}=    Create Dictionary
    Set Suite Variable    ${UE_BEARERS}

Attach UE-${ue_id} to Network
 #   [Arguments]    ${ue_id}
    IF    ${ue_id} < ${MIN_UE_ID} or ${ue_id} > ${MAX_UE_ID}
        Fail    UE ID ${ue_id} jest spoza zakresu (0-100)
    END
    ${is_conn}=    Check if UE Connected    ${ue_id}
    IF    ${is_conn}
        Fail    UE ${ue_id} jest już podłączony do sieci
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
    [Arguments]    ${ue_id}    ${bearer_id}
    Set To Dictionary    ${UE_BEARERS}    ${ue_id}    ${bearer_id}

Verify UE Is Connected
    [Arguments]    ${ue_id}
    ${result}=    Check if UE Connected    ${ue_id}
    Should Be True    ${result}    UE ${ue_id} nie jest polaczony

Verify Default Bearer Assigned
    [Arguments]    ${ue_id}
    ${bearer}=    Get From Dictionary    ${UE_BEARERS}    ${ue_id}
    Should Be Equal As Numbers    ${bearer}    ${DEFAULT_BEARER}    Oczekiwano ID=${DEFAULT_BEARER}, otrzymano ${bearer}

*** Test Cases ***
#przygotował Wiktor Ząbek i Aleksander Dygoń

TC01 UE Poprawnie Dolacza Do Sieci
    [Documentation]    AC1: UE może zostać dołączony do sieci
    [Setup]    Setup Network State
    Attach UE-50 to Network
    Verify UE Is Connected    50

TC02 Podlaczony UE Otrzymuje Domyslny Bearer 9
    [Documentation]    AC5: Po attach UE automatycznie otrzymuje bearer ID=9
    [Setup]    Setup Network State
    Attach UE to Network    50
    Verify Default Bearer Assigned    50

TC03 UE O ID Minimalnym Dolacza
    [Documentation]    AC1: granica dolna zakresu UE ID = 0
    [Setup]    Setup Network State
    Attach UE to Network    0
    Verify UE Is Connected    0

TC04 UE O ID Maksymalnym Dolacza
    [Documentation]    AC1: granica gorna zakresu UE ID = 100
    [Setup]    Setup Network State
    Attach UE to Network    100
    Verify UE Is Connected    100

TC05 Attach Z ID Ponizej Zakresu
    [Documentation]    AC3: UE ID spoza zakresu (ujemny) -> błąd
    [Setup]    Setup Network State
    Run Keyword And Expect Error    UE ID -1 jest spoza zakresu*
    ...    Attach UE to Network    -1

TC06 Attach Z ID Powyzej Zakresu
    [Documentation]    AC3: UE ID spoza zakresu (>100) -> błąd
    [Setup]    Setup Network State
    Run Keyword And Expect Error    UE ID 101 jest spoza zakresu*
    ...    Attach UE to Network    101

TC07 Attach Bez Podania UE ID
    [Documentation]    AC2: procedura wymaga podania UE ID
    [Setup]    Setup Network State
    Run Keyword And Expect Error    *
    ...    Attach UE to Network    ${EMPTY}

TC08 Ponowny Attach Tego Samego UE
    [Documentation]    AC4: UE już podłączony -> błąd
    [Setup]    Setup Network State
    Attach UE to Network    50
    Run Keyword And Expect Error    UE 50 jest już podłączony*
    ...    Attach UE to Network    50
