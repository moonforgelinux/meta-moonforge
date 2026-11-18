*** Settings ***
Documentation     Checks of Docker container engine for the full image.
Resource          ../common/common.resource

*** Test Cases ***
Docker storage is backed by data
    [Documentation]    Verify Docker stores its data root under /data/containers/docker.
    ${root_dir}=    Run On Device    docker info --format '{{.DockerRootDir}}'
    Should Be Equal    ${root_dir.strip()}    /data/containers/docker
    Run On Device    test -d /data/containers/docker/image

Docker can pull and run hello-world
    [Documentation]    Verify Docker can pull and run the hello-world container image.
    ${output}=    Run On Device    docker run --rm hello-world
    Should Contain    ${output}    Hello from Docker!
