*** Settings ***
Documentation     Basic checks of the WPE stack and the kernel of the alt image.
Resource          common.resource

*** Test Cases ***
WPE WebKit is installed
    [Documentation]    Verify the WPE WebKit library and WebDriver are installed.
    Run On Device    test -e /usr/lib/libWPEWebKit-2.0.so.1
    Run On Device    test -x /usr/bin/WPEWebDriver

The remote inspector resources are installed
    [Documentation]    Verify the web inspector plugin is installed.
    Run On Device    test -e /usr/share/wpe-webkit-2.0/inspector.gresource

The launcher service runs
    [Documentation]    Verify wpe-simple-launcher.service is active after boot.
    ${state}=    Execute Command    systemctl is-active wpe-simple-launcher
    Should Be Equal    ${state.strip()}    active

The kernel enables multitouch HID
    [Documentation]    Verify CONFIG_HID_MULTITOUCH is enabled, read from
    ...                /proc/config.gz.
    Kernel Option Should Be Enabled    CONFIG_HID_MULTITOUCH

The uinput device is available
    [Documentation]    Verify /dev/uinput exists once the uinput module is
    ...                loaded.
    Run On Device    modprobe uinput
    Run On Device    test -c /dev/uinput

The CPU has an L2 cache
    [Documentation]    Verify the kernel reports a second level cache for
    ...                the first CPU.
    Run On Device    test -d /sys/devices/system/cpu/cpu0/cache/index2

The clock is synchronized
    [Documentation]    Verify systemd-timesyncd sets the clock within 2 minutes.
    Wait Until Keyword Succeeds    2 minutes    5s    Run On Device
    ...    journalctl -b -u systemd-timesyncd | grep -q 'Initial clock synchronization'

*** Keywords ***
Kernel Option Should Be Enabled
    [Documentation]    /proc/config.gz needs the configs module.
    [Arguments]    ${option}
    Run On Device    modprobe configs
    Run On Device    zcat /proc/config.gz | grep -E '^${option}=(y|m)$'
