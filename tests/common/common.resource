*** Settings ***
Documentation     Keywords shared across Moonforge test suites.
Library           OperatingSystem
Library           SSHLibrary

*** Variables ***
${ALLOW_AGENT}    ${False}

*** Keywords ***
Log In To The Device
    [Arguments]    ${allow_agent}=${ALLOW_AGENT}
    ${ip}=    Get Environment Variable    DUT_IP    ${EMPTY}
    Skip If    $ip == ''    DUT_IP is not set
    ${port}=    Get Environment Variable    DUT_SSH_PORT    22
    Open Connection    ${ip}    port=${port}    timeout=60s
    Login    root    ${EMPTY}    allow_agent=${allow_agent}

Run On Device
    [Documentation]    Run a command on the device, fail if it fails, and
    ...                return its output.
    [Arguments]    ${command}
    ${output}    ${rc}=    Execute Command    ${command}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0    '${command}' failed
    RETURN    ${output}

Wait Until Clock Is Synchronized
    [Documentation]    Wait up to 2 minutes for systemd-timesyncd to set the clock.
    Wait Until Keyword Succeeds    2 minutes    5s    Run On Device
    ...    journalctl -b -u systemd-timesyncd | grep -q 'Initial clock synchronization'
