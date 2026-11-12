*** Settings ***
Documentation     WPE WebKit checks for a Moonforge alt image.
...
...               Connects over SSH using DUT_IP (and optional DUT_SSH_PORT)
...               with the empty root password enabled by kas/common/debug.yml.
Resource          common.resource
Suite Setup       Log In To The Device
Suite Teardown    Close All Connections
