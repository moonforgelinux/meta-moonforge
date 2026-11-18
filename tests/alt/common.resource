*** Settings ***
Documentation     Keywords shared by the alt image suites.
Library           OperatingSystem
Library           SSHLibrary
Resource          ../common/common.resource

*** Variables ***
# Matches the launcher itself, not the su or shell that started it.
${LAUNCHER}       ^/usr/bin/wpe-simple-launcher
# Dropbear is built with PAM on the alt image and does not answer auth_none.
# Pass allow_agent to bypass SSHLibrary's auth_none call with empty passwords.
${ALLOW_AGENT}    ${True}

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
