# See https://github.com/actions/runner/blob/main/images/Dockerfile
FROM ghcr.io/actions/actions-runner:latest

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    procps \
    file \
    git \
    sudo \
    unzip \
    iputils-ping \
    libicu-dev \
    libssl-dev \
    libunwind-dev \
    netcat \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    corepack enable

# install docker-compose and docker compose plugin
ARG DOCKER_COMPOSE_VERSION=2.32.1

RUN export TARGETARCH="$(uname -m)" \
    && mkdir -p /usr/local/lib/docker/cli-plugins \
    && curl -fLo /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-${TARGETARCH}" \
    && curl -fLo /usr/local/lib/docker/cli-plugins/docker-compose "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-${TARGETARCH}" \
    && chmod +x /usr/local/bin/docker-compose \
    && chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

USER runner

# install homebrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install sendapp dependencies for faster startup
RUN /home/linuxbrew/.linuxbrew/bin/brew install \
    yj \
    tilt \
    caddy \
    nss \
    sqlfluff \
    postgresql \
    gnu-sed \
    direnv \
    temporal

ENV PATH="$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"
