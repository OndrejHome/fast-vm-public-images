#!/bin/bash
sshpass -p$PASS ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $USER@$1 'uname -a'
