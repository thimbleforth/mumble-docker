#!/bin/sh
set -e

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Initialize configuration if it doesn't exist
CONFIG_DIR="/etc/mumble-server"
CONFIG_FILE="$CONFIG_DIR/mumble-server.ini"

if [ ! -f "$CONFIG_FILE" ]; then
    log "No configuration found at $CONFIG_FILE"
    
    # Check if the config directory is writable
    if [ ! -w "$CONFIG_DIR" ]; then
        log "ERROR: Configuration directory $CONFIG_DIR is not writable (read-only filesystem or insufficient permissions)."
        log "ERROR: Please provide $CONFIG_FILE via a writable volume or copy it to the image at build time."
        log "ERROR: You can mount a configuration file with: -v /path/to/mumble-server.ini:$CONFIG_FILE"
        exit 1
    fi
    
    log "Attempting to create configuration from example..."
    if [ -f "$CONFIG_DIR/mumble-server.ini.example" ]; then
        if cp "$CONFIG_DIR/mumble-server.ini.example" "$CONFIG_FILE"; then
            log "Created $CONFIG_FILE from example"
        else
            log "ERROR: Failed to copy example configuration to $CONFIG_FILE"
            log "ERROR: Please check permissions or provide configuration via volume mount"
            exit 1
        fi
    else
        log "ERROR: No example configuration found and no existing configuration present!"
        log "ERROR: Please create $CONFIG_FILE manually or mount a volume containing it"
        exit 1
    fi
fi

# Ensure proper permissions (in case volumes are mounted)
if [ -w /var/lib/mumble-server ]; then
    log "Data directory is writable"
else
    log "WARNING: Data directory is not writable!"
fi

# Decide whether to use tmux based on environment variable
# Set ENABLE_TMUX=1 (or "true") to run mumble-server inside a tmux session for console interaction.
# By default, tmux is disabled for better signal handling and simpler container operation.
if [ "${ENABLE_TMUX}" = "1" ] || [ "${ENABLE_TMUX}" = "true" ]; then
    log "ENABLE_TMUX is set, starting Mumble server with tmux session..."
    
    # Check if tmux is available
    if command -v tmux >/dev/null 2>&1; then
        # Start tmux session with the mumble server
        # Session name: mumble-server
        # Note: This allows console interaction but may affect signal handling
        exec tmux new-session -s mumble-server "$@"
    else
        log "WARNING: ENABLE_TMUX is set but tmux not found in container, starting without multiplexer"
        # Execute the CMD passed to the container
        exec "$@"
    fi
else
    log "Starting Mumble server without tmux (recommended for containers)..."
    # Execute the CMD passed to the container directly to ensure proper signal handling
    exec "$@"
fi
