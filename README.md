# Mumble Docker

A hardened Docker container for the Mumble VOIP server using Alpine Linux and Chainguard Alpine base images.

## Features

- **Multi-stage build**: Uses official Alpine Linux for building and Chainguard Alpine for the final image
- **Hardened container**: Non-root user, read-only filesystem, no new privileges, resource limits
- **Persistent storage**: Volume mounts for configuration, data, and logs
- **Health checks**: Built-in health monitoring
- **Easy deployment**: Docker Compose configuration included

## Quick Start

### Using Docker Compose (Recommended)

1. Clone this repository:
```bash
git clone https://github.com/thimbleforth/mumble-docker.git
cd mumble-docker
```

2. Build and start the container:
```bash
docker-compose up -d
```

3. Check the logs:
```bash
docker-compose logs -f
```

4. Stop the server:
```bash
docker-compose down
```

### Using Docker CLI

1. Build the image:
```bash
docker build -t mumble-server .
```

2. Run the container:
```bash
docker run -d \
  --name mumble-server \
  -p 64738:64738/tcp \
  -p 64738:64738/udp \
  -v mumble-data:/var/lib/murmur \
  -v mumble-config:/etc/murmur \
  -v mumble-logs:/var/log/murmur \
  mumble-server
```

## Configuration

### Custom Configuration

1. Create a configuration file based on the example:
```bash
cp murmur.ini.example murmur.ini
```

2. Edit the configuration file to your preferences

3. Mount it to the container:
```bash
docker run -d \
  --name mumble-server \
  -p 64738:64738/tcp \
  -p 64738:64738/udp \
  -v $(pwd)/murmur.ini:/etc/murmur/murmur.ini \
  -v mumble-data:/var/lib/murmur \
  mumble-server
```

### Environment Variables

- `TZ`: Timezone (default: UTC)

## Volumes

The container uses three persistent volumes:

- `/var/lib/murmur`: Server database and SSL certificates
- `/etc/murmur`: Configuration files
- `/var/log/murmur`: Server logs

## Ports

- `64738/tcp`: Mumble server control port
- `64738/udp`: Mumble server audio port

## Security

This container implements several security best practices:

- **Non-root user**: Runs as the `mumble` user
- **Read-only filesystem**: Root filesystem is read-only except for mounted volumes
- **No new privileges**: Prevents privilege escalation
- **Resource limits**: CPU and memory limits defined
- **Minimal base image**: Uses Chainguard Alpine for reduced attack surface
- **Health checks**: Monitors server availability

## License

This project is open source. Please check the individual components for their respective licenses:
- Mumble: BSD-3-Clause
- Alpine Linux: Various open source licenses
- Chainguard Images: Apache 2.0

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
