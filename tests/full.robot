*** Settings ***
Documentation     Sanity checks for a Moonforge full image.
...
...               Connects over SSH using DUT_IP (and optional DUT_SSH_PORT)
...               with the empty root password enabled by kas/common/debug.yml.
Library           OperatingSystem
Library           SSHLibrary
Suite Setup       Log In To The Device
Suite Teardown    Close All Connections

*** Variables ***
# Pre-built moonforge-bundle-base from kas/examples/moonforge-image-full-<machine>.yml
# with kas/common/debug.yml and IMAGE_ID=test and IMAGE_VERSION=999999999999999999
${RAUC_TEST_BUNDLE_URL}    https://builds.moonforgelinux.com/meta-moonforge/tests/%{DUT_POOL}.raucb

*** Keywords ***
Log In To The Device
    ${ip}=    Get Environment Variable    DUT_IP    ${EMPTY}
    Skip If    $ip == ''    DUT_IP is not set
    ${port}=    Get Environment Variable    DUT_SSH_PORT    22
    Open Connection    ${ip}    port=${port}    timeout=60s
    Login    root    ${EMPTY}

Reconnect To Rebooted Device
    [Arguments]    ${previous_boot_id}
    Close All Connections
    Log In To The Device
    ${boot_id}    ${rc}=    Execute Command    cat /proc/sys/kernel/random/boot_id
    ...    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    Should Not Be Equal    ${boot_id.strip()}    ${previous_boot_id.strip()}

*** Test Cases ***
Docker storage is backed by data
    [Documentation]    Verify Docker stores its data root under /data/containers/docker.
    ${root_dir}    ${rc}=    Execute Command    docker info --format '{{.DockerRootDir}}'
    ...    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    Should Be Equal    ${root_dir.strip()}    /data/containers/docker
    ${rc}=    Execute Command    test -d /data/containers/docker/image
    ...    return_stdout=${False}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0

Docker can pull and run hello-world
    [Documentation]    Verify Docker can pull and run the hello-world container image.
    ${output}    ${rc}=    Execute Command    docker run --rm hello-world
    ...    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    Should Contain    ${output}    Hello from Docker!

RAUC updates the system
    [Documentation]    Override rauc-update.service with the test bundle URL,
    ...                run the service until the device reboots, and verify
    ...                /etc/os-release reports IMAGE_ID=test after reboot.
    ${boot_id}    ${rc}=    Execute Command    cat /proc/sys/kernel/random/boot_id
    ...    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    ${rc}=    Execute Command
    ...    mkdir -p /etc/systemd/system/rauc-update.service.d && printf '[Service]\\nExecStart=\\nExecStart=/usr/bin/rauc-update -d -r ${RAUC_TEST_BUNDLE_URL}\\n' > /etc/systemd/system/rauc-update.service.d/override.conf
    ...    return_stdout=${False}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    ${rc}=    Execute Command    systemctl daemon-reload
    ...    return_stdout=${False}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    Set Client Configuration    timeout=300s
    Run Keyword And Ignore Error    Execute Command    systemctl start --wait rauc-update.service
    Wait Until Keyword Succeeds    300s    10s    Reconnect To Rebooted Device    ${boot_id}
    ${image_id}    ${rc}=    Execute Command    . /etc/os-release && echo $IMAGE_ID
    ...    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0
    Should Be Equal    ${image_id.strip()}    test
