# Hardened Mumble VOIP Server Dockerfile
# Uses official Alpine Linux as base image with security hardening

FROM alpine:latest

# Add metadata labels
LABEL maintainer="mumble-docker" \
      description="Hardened Mumble VOIP Server container" \
      version="1.0"

# Install runtime dependencies and Mumble server
RUN apk add --no-cache \
    mumble-server \
    mumble-server-openrc \
    tmux \
    su-exec \
    tzdata \
    ca-certificates

# Create mumble user and group if they don't exist
RUN addgroup -S mumble 2>/dev/null || true && \
    adduser -S -D -H -h /var/lib/mumble-server -s /sbin/nologin -G mumble -g mumble mumble 2>/dev/null || true

# Create necessary directories with appropriate permissions
RUN mkdir -p /var/lib/mumble-server /var/log/mumble-server /etc/mumble-server && \
    chown -R mumble:mumble /var/lib/mumble-server /var/log/mumble-server /etc/mumble-server && \
    chmod 755 /var/lib/mumble-server /var/log/mumble-server /etc/mumble-server

# Copy example configuration
COPY --chown=mumble:mumble mumble-server.ini.example /etc/mumble-server/mumble-server.ini.example

# Copy and set up entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set up volumes for persistent data
VOLUME ["/var/lib/mumble-server", "/etc/mumble-server"]

# Expose Mumble server port (default 64738)
EXPOSE 64738/tcp 64738/udp

# Switch to non-root user for security
USER mumble

# Set working directory
WORKDIR /var/lib/mumble-server

# Health check to verify server is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pidof mumble-server || exit 1

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Start Mumble server
CMD ["mumble-server", "-fg", "-ini", "/etc/mumble-server/mumble-server.ini"]
