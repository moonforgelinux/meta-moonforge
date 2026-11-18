*** Settings ***
Documentation     Checks of RAUC update service for the full image.
Resource          ../common/common.resource

*** Variables ***
# Pre-built moonforge-bundle-base from kas/examples/moonforge-image-full-<machine>.yml
# with kas/common/debug.yml and IMAGE_ID=test and IMAGE_VERSION=999999999999999999
${RAUC_TEST_BUNDLE_URL}    https://builds.moonforgelinux.com/meta-moonforge/tests/%{DUT_POOL}.raucb

*** Test Cases ***
RAUC updates the system
    [Documentation]    Override rauc-update.service with the test bundle URL,
    ...                run the service until the device reboots, and verify
    ...                /etc/os-release reports IMAGE_ID=test after reboot.
    ${boot_id}=    Run On Device    cat /proc/sys/kernel/random/boot_id
    Run On Device
    ...    mkdir -p /etc/systemd/system/rauc-update.service.d && printf '[Service]\\nExecStart=\\nExecStart=/usr/bin/rauc-update -d -r ${RAUC_TEST_BUNDLE_URL}\\n' > /etc/systemd/system/rauc-update.service.d/override.conf
    Run On Device    systemctl daemon-reload
    Set Client Configuration    timeout=300s
    Run Keyword And Ignore Error    Execute Command    systemctl start --wait rauc-update.service
    Wait Until Keyword Succeeds    300s    10s    Reconnect To Rebooted Device    ${boot_id}
    ${image_id}=    Run On Device    . /etc/os-release && echo $IMAGE_ID
    Should Be Equal    ${image_id.strip()}    test

*** Keywords ***
Reconnect To Rebooted Device
    [Arguments]    ${previous_boot_id}
    Close All Connections
    Log In To The Device
    ${boot_id}=    Run On Device    cat /proc/sys/kernel/random/boot_id
    Should Not Be Equal    ${boot_id.strip()}    ${previous_boot_id.strip()}
