# Mumble Docker

A hardened Docker container for the Mumble VOIP server using Alpine Linux and Chainguard Wolfi base images.

## Features

- **Simplified build**: Uses official Alpine Linux or Chainguard Wolfi for the final image
- **Hardened container**: Non-root user, read-only filesystem, no new privileges, resource limits
- **Persistent storage**: Volume mounts for configuration, data, and logs
- **Health checks**: Built-in health monitoring
- **Easy deployment**: Docker Compose configuration included
- **Multiple Dockerfile options**: Standard Alpine or Chainguard for maximum security

## Dockerfile Options

This repository provides two Dockerfile options:

### Standard Dockerfile (Default)
- **File**: `Dockerfile`
- **Base Image**: Alpine Linux (official)
- **Best For**: General use, standard deployments
- **Build**: `docker build -t mumble-server .`

### Chainguard Dockerfile (Maximum Security)
- **File**: `Dockerfile.chainguard`
- **Base Image**: Chainguard Wolfi-base
- **Best For**: Production environments requiring maximum security and minimal attack surface
- **Build**: `docker build -f Dockerfile.chainguard -t mumble-server .`
- **Note**: Requires access to Chainguard registry at `cgr.dev`

## Quick Start

### Using Make (Recommended for Development)

If you have `make` installed, you can use the provided Makefile:

```bash
# Show all available commands
make help

# Build and start the server
make build
make up

# View logs
make logs

# Stop the server
make down

# Backup data
make backup
```

### Using Docker Compose

1. Clone this repository:
```bash
git clone https://github.com/thimbleforth/mumble-docker.git
cd mumble-docker
```

2. Build and start the container:
```bash
docker-compose up -d
```

   Or to use the Chainguard Dockerfile:
```bash
docker-compose -f docker-compose.chainguard.yml up -d
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
  -v mumble-data:/var/lib/mumble-server \
  -v mumble-config:/etc/mumble-server \
  -v mumble-logs:/var/log/mumble-server \
  mumble-server
```

## Configuration

### Custom Configuration

1. Create a configuration file based on the example:
```bash
cp mumble-server.ini.example mumble-server.ini
```

2. Edit the configuration file to your preferences

3. Mount it to the container:
```bash
docker run -d \
  --name mumble-server \
  -p 64738:64738/tcp \
  -p 64738:64738/udp \
  -v $(pwd)/mumble-server.ini:/etc/mumble-server/mumble-server.ini \
  -v mumble-data:/var/lib/mumble-server \
  mumble-server
```

### Environment Variables

- `TZ`: Timezone (default: UTC)
- `ENABLE_TMUX`: Enable tmux multiplexer for console interaction (default: disabled)
  - Set to `1` or `true` to run Mumble server inside a tmux session
  - Useful for console interaction with the running server
  - When enabled, attach to the session with: `docker exec -it mumble-server tmux attach -t mumble-server`
  - Note: Disabled by default for better signal handling and simpler container operation

## Volumes

The container uses three persistent volumes:

- `/var/lib/mumble-server`: Server database and SSL certificates
- `/etc/mumble-server`: Configuration files
- `/var/log/mumble-server`: Server logs

## Ports

- `64738/tcp`: Mumble server control port
- `64738/udp`: Mumble server audio port

## Security

This container implements several security best practices:

- **Non-root user**: Runs as the `mumble` user
- **Read-only filesystem**: Root filesystem is read-only except for mounted volumes
- **No new privileges**: Prevents privilege escalation
- **Resource limits**: CPU and memory limits defined
- **Minimal base image**: Uses Chainguard Wolfi for reduced attack surface
- **Health checks**: Monitors server availability

## License

This project is open source. Please check the individual components for their respective licenses:
- Mumble: BSD-3-Clause
- Alpine Linux: Various open source licenses
- Chainguard Images: Apache 2.0

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
