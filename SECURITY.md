# Security Hardening

This document describes the security measures implemented in this Mumble Docker container.

## Container Security Measures

### 1. Base Image Selection

**Standard Dockerfile:**
- Uses official Alpine Linux as the base image
- Multi-stage build to minimize final image size
- Regularly updated Alpine packages

**Chainguard Dockerfile:**
- Uses Chainguard Wolfi-base for maximum security
- Minimal attack surface with stripped-down OS
- Designed specifically for container security
- Regular security patches and updates

### 2. Non-Root User

- Container runs as non-root `mumble` user (not root)
- User created with minimal privileges:
  - No home directory
  - No login shell (`/sbin/nologin`)
  - Minimal group membership

### 3. Filesystem Security

- **Read-only root filesystem**: Enabled in docker-compose.yml
- **Specific write permissions**: Only on necessary directories:
  - `/var/lib/mumble-server`: Database and certificates
  - `/etc/mumble-server`: Configuration files
  - `/var/log/mumble-server`: Log files
  - `/tmp` and `/run`: Temporary files (tmpfs)

### 4. Capability Restrictions

- **No new privileges**: `security_opt: no-new-privileges:true`
- Prevents privilege escalation attacks
- Container cannot gain additional privileges

### 5. Resource Limits

Resource limits are enforced to prevent DoS attacks:
- **CPU limit**: 2 cores maximum
- **Memory limit**: 512MB maximum
- **CPU reservation**: 0.5 cores minimum
- **Memory reservation**: 128MB minimum

### 6. Network Security

- **Minimal exposed ports**: Only 64738/tcp and 64738/udp
- **No unnecessary services**: Only Mumble server runs in container

### 7. Health Checks

- Regular health checks ensure server availability
- Automatic restart on failure (when configured)
- Monitoring via `pidof` instead of network-based checks

### 8. SSL/TLS

- Mumble server supports SSL/TLS encryption
- Auto-generates certificates on first run
- Certificates stored in persistent volume

### 9. Configuration Security

- Example configuration provided with secure defaults
- No default server password (must be explicitly set)
- Configuration file permissions restricted to mumble user

### 10. Build Security

- Multi-stage build separates build and runtime environments
- Minimal runtime dependencies
- No build tools in final image
- CA certificates included for secure communications

## Best Practices for Deployment

### 1. Use Secrets for Sensitive Data

Never hardcode passwords in configuration files. Use Docker secrets:

```bash
echo "your-secure-password" | docker secret create mumble_password -
```

### 2. Regular Updates

Keep the container updated:

```bash
docker-compose pull
docker-compose up -d
```

### 3. Monitor Logs

Regularly review logs for suspicious activity:

```bash
docker-compose logs -f
```

### 4. Backup Configuration and Data

Regularly backup the volumes:

```bash
docker run --rm \
  -v mumble-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/mumble-data-$(date +%Y%m%d).tar.gz /data
```

### 5. Network Isolation

Use Docker networks to isolate the container:

```yaml
networks:
  mumble-net:
    driver: bridge
    internal: false
```

### 6. Firewall Rules

Configure host firewall to restrict access:
- Allow only port 64738/tcp and 64738/udp
- Restrict source IP addresses if possible

### 7. Use the Chainguard Image for Production

For production deployments requiring maximum security:
- Use `Dockerfile.chainguard` instead of standard `Dockerfile`
- Regularly scan images for vulnerabilities
- Subscribe to security updates from Chainguard

## Vulnerability Scanning

Scan the image regularly:

```bash
# Using Docker Scout
docker scout cves mumble-server

# Using Trivy
trivy image mumble-server

# Using Grype
grype mumble-server
```

## Security Audit Checklist

- [ ] Container runs as non-root user
- [ ] Read-only root filesystem enabled
- [ ] No new privileges flag set
- [ ] Resource limits configured
- [ ] Health checks enabled
- [ ] Volumes properly configured for persistence
- [ ] Logs monitored regularly
- [ ] Regular backups performed
- [ ] Image scanned for vulnerabilities
- [ ] SSL/TLS certificates valid
- [ ] Server password set (not default/empty)
- [ ] Firewall rules configured
- [ ] Latest image version deployed

## Reporting Security Issues

If you discover a security vulnerability, please report it responsibly:
1. Do not open a public issue
2. Email the maintainers directly
3. Provide detailed information about the vulnerability
4. Allow time for a fix before public disclosure

## Security Resources

- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [Mumble Security](https://www.mumble.info/documentation/user/security/)
- [Chainguard Images](https://www.chainguard.dev/chainguard-images)
