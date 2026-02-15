#!/bin/sh
set -e

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Initialize configuration if it doesn't exist
if [ ! -f /etc/mumble-server/mumble-server.ini ]; then
    log "No configuration found, using example configuration..."
    if [ -f /etc/mumble-server/mumble-server.ini.example ]; then
        cp /etc/mumble-server/mumble-server.ini.example /etc/mumble-server/mumble-server.ini
        log "Created /etc/mumble-server/mumble-server.ini from example"
    else
        log "WARNING: No example configuration found!"
    fi
fi

# Ensure proper permissions (in case volumes are mounted)
if [ -w /var/lib/mumble-server ]; then
    log "Data directory is writable"
else
    log "WARNING: Data directory is not writable!"
fi

log "Starting Mumble server (mumble-server)..."

# Execute the CMD passed to the container
exec "$@"
