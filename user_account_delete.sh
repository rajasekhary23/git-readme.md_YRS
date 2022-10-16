#!/bin/bash
#set -x

if [[ $# -gt 0 ]]; then
    for user in $@; do
        userdel -r $user
    done
else
    echo "no username given, Please give usernames"
fi
