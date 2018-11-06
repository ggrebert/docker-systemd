#!/bin/sh

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ansible@server sudo systemctl status
exit $?
