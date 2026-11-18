*** Settings ***
Documentation     Basic sanity checks for a Moonforge base image.
...
...               Connects over SSH using DUT_IP (and optional DUT_SSH_PORT)
...               with the empty root password enabled by kas/common/debug.yml.
Resource          ../common/common.resource
Suite Setup       Log In To The Device
Suite Teardown    Run Keywords
...               Save The Journal    AND
...               Close All Connections
