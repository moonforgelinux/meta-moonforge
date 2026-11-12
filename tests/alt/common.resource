*** Settings ***
Documentation     Keywords shared by the alt image suites.
Library           OperatingSystem
Library           SSHLibrary

*** Variables ***
# Matches the launcher itself, not the su or shell that started it.
${LAUNCHER}       ^/usr/bin/wpe-simple-launcher

*** Keywords ***
Stop The Launcher
    [Documentation]    Stopping the service is not enough: su moves the
    ...                launcher to a session of its own, out of the service.
    ...                The image has pgrep but no pkill.
    Execute Command    systemctl stop wpe-simple-launcher
    Execute Command    kill $(pgrep -f '${LAUNCHER}')
    Wait Until Keyword Succeeds    10s    1s    Run On Device    ! pgrep -f '${LAUNCHER}'

Restore The Launcher Service
    Stop The Launcher
    Run On Device    systemctl start wpe-simple-launcher

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
