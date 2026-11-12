*** Settings ***
Documentation     Checks that text renders the same as in the baseline.
Library           DocTest.VisualTest
Resource          webdriver.resource
Suite Setup       Start The WebDriver Session
Suite Teardown    Stop The WebDriver Session

*** Test Cases ***
The glyphs render as in the baseline
    [Documentation]    Render text and numbers in regular, bold, italic and
    ...                heading styles and compare the page with the baseline.
    Go To Local Page    glyphs.html
    Wait Until Page Contains    Ready    timeout=10s
    ${screenshot}=    Capture Page Screenshot    glyphs.png
    Compare Images    ${CURDIR}/baselines/glyphs.png    ${screenshot}    threshold=0.001
