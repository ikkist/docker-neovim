#!/bin/sh
USER_ID=${USER_ID:-0}
GROUP_ID=${GROUP_ID:-0}
USER=nvim

if [ x"${USER_ID}" != x"0" ] ; then 
    echo "no root user ${USER_ID}"
    usermod -u ${USER_ID} ${USER}
    groupmod  -g ${GROUP_ID}  ${USER}
    su-exec ${USER} "$@"
else
    echo "root user"
    exec "$@"
fi

