#!/bin/bash
echo $0: creating public and private key files

keyfile="id_heroku"

# Create the .ssh directory
mkdir -p ${HOME}/.ssh
chmod 0700 ${HOME}/.ssh

# Create the public and private key files from the environment variables.
echo "${HEROKU_PRIVATE_KEY}" > ${HOME}/.ssh/${keyfile}
chmod 0600 ${HOME}/.ssh/${keyfile}

# Preload the known_hosts file
ssh-keyscan -H -p ${SSH_TUNNEL_PORT:-22} ${SSH_TUNNEL_SERVER} >> ${HOME}/.ssh/known_hosts

# Start the SSH tunnel if not already running
AUTOSSH_OPTIONS="-f -M 0 -f -o ServerAliveInterval=10 -o ServerAliveCountMax=3"
SSH_OPTIONS="-i ${HOME}/.ssh/${keyfile} -N -L ${LOCAL_TUNNEL_PORT}:${REMOTE_TUNNEL_SERVER:-localhost}:${REMOTE_TUNNEL_PORT} -p ${SSH_TUNNEL_PORT:-22} ${SSH_TUNNEL_USER}@${SSH_TUNNEL_SERVER}"

echo $0: launching tunnel
autossh ${AUTOSSH_OPTIONS} ${SSH_OPTIONS} 
