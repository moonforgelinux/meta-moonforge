*** Settings ***
Documentation     Keywords shared by the alt image suites.
Library           OperatingSystem
Library           SSHLibrary

*** Keywords ***
Log In To The Device
    ${ip}=    Get Environment Variable    DUT_IP    ${EMPTY}
    Skip If    $ip == ''    DUT_IP is not set
    ${port}=    Get Environment Variable    DUT_SSH_PORT    22
    Open Connection    ${ip}    port=${port}    timeout=60s
    # With allow_agent off and no password, SSHLibrary sends auth_none after
    # paramiko has already logged in, and dropbear never answers it.
    Login    root    ${EMPTY}    allow_agent=${True}

Run On Device
    [Documentation]    Run a command on the device, fail if it fails, and
    ...                return its output.
    [Arguments]    ${command}
    ${output}    ${rc}=    Execute Command    ${command}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0    '${command}' failed
    RETURN    ${output}
