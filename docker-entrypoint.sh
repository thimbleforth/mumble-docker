#!/bin/sh
set -e

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Initialize configuration if it doesn't exist
if [ ! -f /etc/murmur/murmur.ini ]; then
    log "No configuration found, using example configuration..."
    if [ -f /etc/murmur/murmur.ini.example ]; then
        cp /etc/murmur/murmur.ini.example /etc/murmur/murmur.ini
        log "Created /etc/murmur/murmur.ini from example"
    else
        log "WARNING: No example configuration found!"
    fi
fi

# Ensure proper permissions (in case volumes are mounted)
if [ -w /var/lib/murmur ]; then
    log "Data directory is writable"
else
    log "WARNING: Data directory is not writable!"
fi

log "Starting Mumble server (murmurd)..."

# Execute the CMD passed to the container
exec "$@"
