*** Settings ***
Documentation     Basic sanity checks for a Moonforge base image.
...
...               Connects over SSH using DUT_IP (and optional DUT_SSH_PORT)
...               with the empty root password enabled by kas/common/debug.yml.
Library           OperatingSystem
Library           SSHLibrary
Suite Setup       Log In To The Device
Suite Teardown    Close All Connections

*** Keywords ***
Log In To The Device
    ${ip}=    Get Environment Variable    DUT_IP    ${EMPTY}
    Skip If    $ip == ''    DUT_IP is not set
    ${port}=    Get Environment Variable    DUT_SSH_PORT    22
    Open Connection    ${ip}    port=${port}    timeout=60s
    Login    root    ${EMPTY}

*** Test Cases ***
The device runs Moonforge
    [Documentation]    Verify /etc/os-release identifies the Moonforge distro.
    ${id}    ${rc}=    Execute Command    . /etc/os-release && echo $ID
    ...    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    Should Be Equal    ${id.strip()}    moonforge

The root filesystem is read only
    [Documentation]    Verify the root filesystem is mounted read-only and
    ...                rejects writes.
    ${err}    ${rc}=    Execute Command    touch /moonforge.check
    ...    return_stdout=${False}    return_stderr=${True}    return_rc=${True}
    Should Not Be Equal As Integers    ${rc}    0
    Should Contain    ${err}    Read-only file system

Etc is a writable overlay backed by data
    [Documentation]    Verify writes to /etc succeed and are stored in the
    ...                overlay upper directory under /data.
    ${rc}=    Execute Command    echo written > /etc/moonforge.check
    ...    return_stdout=${False}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    ${content}    ${rc}=    Execute Command    cat /data/overlay-etc/upper/moonforge.check
    ...    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    Should Be Equal    ${content.strip()}    written
