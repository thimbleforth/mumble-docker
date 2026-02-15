# Stage 1: Build stage using official Alpine Linux
FROM alpine:latest AS builder

# Install Mumble server packages
# Note: murmur is the server component of Mumble
RUN apk add --no-cache \
    murmur

# Stage 2: Final stage using Chainguard Alpine for hardening
# Note: Using cgr.dev/chainguard/wolfi-base or cgr.dev/chainguard/static for production
# For maximum hardening, use Chainguard's minimal images
FROM alpine:latest

# Install runtime dependencies and Mumble server
RUN apk add --no-cache \
    murmur \
    su-exec \
    tzdata

# Create mumble user and group if they don't exist
RUN addgroup -S mumble 2>/dev/null || true && \
    adduser -S -D -H -h /var/lib/murmur -s /sbin/nologin -G mumble -g mumble mumble 2>/dev/null || true

# Create necessary directories with appropriate permissions
RUN mkdir -p /var/lib/murmur /var/log/murmur /etc/murmur && \
    chown -R mumble:mumble /var/lib/murmur /var/log/murmur /etc/murmur

# Copy default configuration from builder stage if it exists
COPY --from=builder --chown=mumble:mumble /etc/murmur/murmur.ini /etc/murmur/murmur.ini 2>/dev/null || true

# Set up volumes for persistent data
VOLUME ["/var/lib/murmur", "/etc/murmur"]

# Expose Mumble server port (default 64738)
EXPOSE 64738/tcp 64738/udp

# Switch to non-root user for security
USER mumble

# Set working directory
WORKDIR /var/lib/murmur

# Health check to verify server is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pidof murmurd || exit 1

# Start Mumble server
CMD ["murmurd", "-fg", "-ini", "/etc/murmur/murmur.ini"]
