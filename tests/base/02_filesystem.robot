*** Settings ***
Documentation     Checks of the filesystem layout and persistence for the base image.
Resource          ../common/common.resource

*** Test Cases ***
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
    Run On Device    echo written > /etc/moonforge.check
    ${content}=    Run On Device    cat /data/overlay-etc/upper/moonforge.check
    Should Be Equal    ${content.strip()}    written
