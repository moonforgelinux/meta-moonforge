*** Settings ***
Documentation     Checks of the WebKit remote inspector over its HTTP server.
...
...               Starts the launcher with WEBKIT_INSPECTOR_HTTP_SERVER and
...               reads the inspector pages from the test runner, so it needs
...               INSPECTOR_PORT of the device reachable from there.
Resource          common.resource
Suite Setup       Start The Launcher With The Inspector
Suite Teardown    Restore The Launcher Service

*** Variables ***
${INSPECTOR_PORT}    22322
${PAGE_TITLE}        Inspected Page

*** Test Cases ***
The inspector lists the page
    [Documentation]    Verify the target list names the page and links to its
    ...                inspector socket.
    ${body}=    Get Inspector Page    /
    Should Contain    ${body}    ${PAGE_TITLE}
    Should Contain    ${body}    /socket/1/1/WebPage

The inspector serves its user interface
    [Documentation]    Verify the inspector frontend is served from the
    ...                inspector resources of the device.
    ${body}=    Get Inspector Page    /Main.html
    Should Contain    ${body}    <div id="main">
    Should Contain    ${body}    <script src="Main.js"></script>
    Get Inspector Page    /Main.js

*** Keywords ***
Start The Launcher With The Inspector
    Stop The Launcher
    Execute Command
    ...    WEBKIT_INSPECTOR_HTTP_SERVER=0.0.0.0:${INSPECTOR_PORT} nohup /usr/bin/wpe-exported-wayland 'data:text/html,<title>${PAGE_TITLE}</title>' --fullscreen > /tmp/wpe-inspector.log 2>&1 &
    Wait Until Keyword Succeeds    30s    2s    The Inspector Lists The Page

The Inspector Lists The Page
    ${body}=    Get Inspector Page    /
    Should Contain    ${body}    ${PAGE_TITLE}

Get Inspector Page
    [Documentation]    Read a page of the inspector HTTP server from the runner.
    [Arguments]    ${path}
    ${body}=    Evaluate
    ...    urllib.request.urlopen('http://%{DUT_IP}:${INSPECTOR_PORT}${path}', timeout=10).read().decode()
    ...    modules=urllib.request
    RETURN    ${body}
