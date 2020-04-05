#!/bin/sh
USER_ID=${USER_ID:-0}
GROUP_ID=${GROUP_ID:-0}
USER=nvim

if [ x"${USER_ID}" != x"0" ] ; then 
    usermod -u ${USER_ID} ${USER}
    #groupmod -g ${GROUP_ID} ${USER}
    gpasswd  -a ${USER} ${DEFAULT_NVIM_GROUP_NAME}
    su-exec ${USER} "$@"
else
    exec "$@"
fi

