*** Settings ***
Documentation     Runs the MotionMark benchmark and checks its score.
...
...               Needs internet access from the device to browserbench.org.
Resource          webdriver.resource
Suite Setup       Start The Benchmark Session
Suite Teardown    Stop The WebDriver Session
Test Timeout      15 minutes

*** Variables ***
${MOTIONMARK_URL}     https://browserbench.org/MotionMark1.2/
${RUN_BUTTON}         xpath=//*[@id="intro"]//button
${SCORE}              xpath=//section[@id="results"]//div[@class="score-container"]//div[@class="score"]
# motionmark-min-score of the meta-wpe-image expectations
${MIN_SCORE}          400

*** Test Cases ***
The MotionMark score is high enough
    [Documentation]    Run MotionMark 1.2 and check its global score.
    Go To    ${MOTIONMARK_URL}
    Wait Until Element Is Visible    ${RUN_BUTTON}    timeout=60s
    Click Element    ${RUN_BUTTON}
    Wait Until Element Is Visible    ${SCORE}    timeout=12 minutes
    Capture Page Screenshot    motionmark.png
    ${score}=    Get Text    ${SCORE}
    Log    MotionMark score: ${score}    console=${True}
    Should Be True    ${score} > ${MIN_SCORE}

*** Keywords ***
Start The Benchmark Session
    Stop The Launcher
    Wait Until Keyword Succeeds    3 minutes    10s    The Device Is Idle
    Start The WebDriver Session

The Device Is Idle
    [Documentation]    The 1-minute load average is below 1.
    ${load}=    Run On Device    cut -d ' ' -f 1 /proc/loadavg
    Should Be True    ${load} < 1
