# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains configuration for GitHub Actions Runner Controller (ARC) to deploy self-hosted GitHub Actions runners on Kubernetes. It includes a custom Docker image that extends the official GitHub Actions runner with additional tools and dependencies specific to the Sendapp project.

## Architecture

The project consists of:
- **Dockerfile**: Builds a custom runner image based on `ghcr.io/actions/actions-runner:latest` with Sendapp-specific dependencies including Node.js, Docker Compose, Homebrew, and various development tools
- **Helm values configuration**: Defines the runner scale set configuration with custom dind (Docker-in-Docker) setup
- **Makefile**: Provides commands for building, pushing, and deploying the runner image

The runners are deployed as Kubernetes pods with:
- A main runner container running the custom image
- A dind sidecar container for Docker operations
- Shared volumes between containers for Docker socket and work directories

## Common Commands

### Build and Push Docker Image
```bash
make build              # Build the Docker image locally
make push               # Push to Docker Hub (default: 0xbigboss/actions-runner-sendapp)
make test               # Test the image interactively
```

### Deploy to Kubernetes
```bash
# Install/upgrade the runner scale set
make deploy

# Or manually:
helm upgrade --install arc-runner-set \
    --namespace arc-runners \
    --values ./runner-scale-set-values.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```

### Controller Installation
```bash
# Install the ARC controller (one-time setup)
helm install arc \
    --namespace arc-systems \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
```

## Configuration Details

- **Target Repository**: https://github.com/0xsend/sendapp
- **Max Runners**: 10
- **Min Runners**: 0
- **Container Mode**: Custom dind setup
- **Resources**: 4 CPU cores, 12-16GB memory per runner
- **Authentication**: Uses pre-defined Kubernetes secret with GitHub App credentials

## Key Files

- `runner-scale-set-values.yaml`: Helm values for runner configuration
- `Makefile`: Build and deployment automation
- `Dockerfile`: Custom runner image definition