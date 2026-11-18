*** Settings ***
Documentation     WPE WebKit checks for a Moonforge alt image.
...
...               Connects over SSH using DUT_IP (and optional DUT_SSH_PORT)
...               with the empty root password enabled by kas/common/debug.yml.
Resource          common.resource
Suite Setup       Run Keywords
...               Log In To The Device    AND
...               Wait Until Clock Is Synchronized
Suite Teardown    Run Keywords
...               Save The Journal    AND
...               Close All Connections
