*** Settings ***
Documentation     Basic checks for the Moonforge base image.
Resource          ../common/common.resource

*** Test Cases ***
The device runs Moonforge
    [Documentation]    Verify /etc/os-release identifies the Moonforge distro.
    ${id}=    Run On Device    . /etc/os-release && echo $ID
    Should Be Equal    ${id.strip()}    moonforge
