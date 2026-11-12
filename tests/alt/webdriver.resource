*** Settings ***
Documentation     Keywords to drive WPE on the device through WPEWebDriver.
...
...               Kept apart from common.resource: only the suites that need
...               WebDriver import SeleniumLibrary.
Library           SeleniumLibrary
Resource          common.resource

*** Variables ***
${WEBDRIVER_PORT}    8888

*** Keywords ***
Start The WebDriver Session
    [Documentation]    Run WPEWebDriver on the device and open a remote
    ...                session that starts the launcher through it.
    Stop The Launcher
    Execute Command
    ...    nohup WPEWebDriver --port=${WEBDRIVER_PORT} --host=all > /tmp/wpe-webdriver.log 2>&1 &
    Wait Until Keyword Succeeds    20s    1s
    ...    Run On Device    netstat -ltn | grep -q ':${WEBDRIVER_PORT} '
    ${options}=    Evaluate    selenium.webdriver.WPEWebKitOptions()    modules=selenium.webdriver
    ${options.binary_location}=    Set Variable    /usr/bin/wpe-exported-wayland
    Call Method    ${options}    add_argument    --automation
    Call Method    ${options}    set_capability    browserName    wpe-simple-launcher
    Create Webdriver    Remote    command_executor=http://%{DUT_IP}:${WEBDRIVER_PORT}
    ...    options=${options}

Stop The WebDriver Session
    Close All Browsers
    Execute Command    kill $(pgrep -f '^WPEWebDriver')
    Restore The Launcher Service

Go To Local Page
    [Documentation]    Open a page of html/ as a data: URL, so the device needs
    ...                neither a copy of it nor a web server.
    [Arguments]    ${name}
    ${html}=    OperatingSystem.Get File    ${CURDIR}/html/${name}
    ${url}=    Evaluate    'data:text/html;base64,' + base64.b64encode($html.encode()).decode()
    ...    modules=base64
    Go To    ${url}
