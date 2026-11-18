*** Settings ***
Documentation     Checks of Podman container engine for the alt image.
Resource          common.resource

*** Test Cases ***
Podman storage is backed by data
    [Documentation]    Verify Podman stores its graph root under /data/containers/storage.
    ${root_dir}=    Run On Device    podman info --format '{{.Store.GraphRoot}}'
    Should Be Equal    ${root_dir.strip()}    /data/containers/storage
    Run On Device    test -d /data/containers/storage

Podman can pull and run hello-world
    [Documentation]    Verify Podman can pull and run the hello-world container image.
    ${output}=    Run On Device    podman run --rm hello-world
    Should Contain    ${output}    Hello from Docker!
