# Contributing to Mumble Docker

Thank you for your interest in contributing to this project! This document provides guidelines for contributing.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in the [Issues](https://github.com/thimbleforth/mumble-docker/issues) section
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (Docker version, OS, etc.)

### Contributing Code

1. **Fork the repository**
   ```bash
   git clone https://github.com/thimbleforth/mumble-docker.git
   cd mumble-docker
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Update documentation if needed
   - Add tests if applicable

4. **Test your changes**
   ```bash
   make build
   make up
   make test
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Brief description of changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Describe your changes

## Development Guidelines

### Docker Best Practices

- Keep images small and efficient
- Use multi-stage builds when appropriate
- Run containers as non-root users
- Implement proper health checks
- Document all environment variables

### Security

- Never commit secrets or credentials
- Follow the security guidelines in [SECURITY.md](SECURITY.md)
- Scan images for vulnerabilities before submitting PR
- Keep dependencies up to date

### Documentation

- Update README.md for user-facing changes
- Update SECURITY.md for security-related changes
- Add inline comments for complex logic
- Update the example configuration if needed

### Testing

Before submitting a PR, ensure:

- [ ] Docker image builds successfully
- [ ] Container starts without errors
- [ ] Health check passes
- [ ] Documentation is updated
- [ ] No security vulnerabilities introduced

### Code Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged

## Project Structure

```
mumble-docker/
├── Dockerfile                    # Standard Alpine-based Dockerfile
├── Dockerfile.chainguard         # Chainguard-based Dockerfile
├── docker-compose.yml            # Standard compose file
├── docker-compose.chainguard.yml # Chainguard compose file
├── docker-entrypoint.sh          # Container entrypoint script
├── murmur.ini.example            # Example configuration
├── .env.example                  # Environment variables example
├── Makefile                      # Build and management commands
├── README.md                     # User documentation
├── SECURITY.md                   # Security documentation
└── .github/
    └── workflows/
        └── docker-build.yml      # CI/CD workflow
```

## Testing Locally

### Build and Run

```bash
# Build the image
make build

# Start the server
make up

# Check logs
make logs

# Run security scan
make scan
```

### Manual Testing

1. Build the container
2. Start it with docker-compose
3. Verify it starts successfully
4. Check that volumes are properly mounted
5. Test health check functionality
6. Verify non-root user execution

## Release Process

Releases are handled by maintainers:

1. Update version numbers
2. Update CHANGELOG.md
3. Create a git tag
4. Build and push images
5. Create GitHub release

## Questions?

If you have questions about contributing, feel free to:
- Open an issue for discussion
- Contact the maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
