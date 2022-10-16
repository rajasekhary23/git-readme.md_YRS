#!/bin/bash
#set -x
# Create a users and assign random password.
# 1. Take username as arg.
# 2. Check if user already exists.
# 3. Create if user not exist.
# 4. Assign random password with nums, char, spec char India@1234.
# 5. Force user to change password.
# 6. sed -i "s/.*PasswordAuthentication no.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
# 7. sed -i '60i #Password Authentication Enabled By Sreeharsha' /tmp/sshd_config
# 8. Username must be alphabets only & lowercase only.
# 9. USERNAMES=$(cat /etc/passwd | cut -d ':' -f 1 | egrep '[0-9]' | tail -24)
# 10. for USER in $USERNAMES; do userdel -r $USER; done
# ------------------------------------------------------------
if [ $# -gt 0 ]; then

    for RAWUSER in $@; do
        if [[ $RAWUSER =~ ^[a-z0-9]+$ ]]; then
            #To convert any uppercase char to lower.
            #But now below line is useless as above we have given regex to acept only lowercase char
            USERNAMES=$(echo $RAWUSER | tr '[:upper:]' '[:lower:]')
            EXISTING_USERS=$(cat /etc/passwd | awk -F":" -v OFS=',' '{print $1}' | grep -i -w $USERNAMES)

            if [ "$USERNAMES" = "$EXISTING_USERS" ]; then
                echo "User $USERNAMES is already exists"
            else
                echo "Creating user $USERNAMES ..."
                $(useradd -m $USERNAMES --shell /bin/bash)
                SPCL_CHAR=$(echo '!@#$%^&*_-' | fold -1 | shuf | head -1)
                PASSWORD="India$SPCL_CHAR$RANDOM"
                echo $USERNAMES:$PASSWORD | chpasswd
                echo -e "UserName: $USERNAMES \n Password: $PASSWORD"
                passwd -e $USERNAMES
            fi
        else
            echo "Invalid username $RAWUSER. Username must be alphabets only & lowercase only"
        fi
    done

else
    echo "Invalid args, Please provide username"
fi
