#!/bin/bash

# Add local user
# with the same owner as application mounted
USER_ID=$(stat -c %u "/var/www")
GROUP_ID=$(stat -c %g "/var/www")

echo "Starting with UID:GID $USER_ID:$GROUP_ID"

chown --recursive "$USER_ID":"$GROUP_ID" /var/www

