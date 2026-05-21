FROM codercom/code-server:latest

USER root

RUN groupadd -g 1001 ubuntu \
    && useradd -u 1001 -g 1001 -m -s /bin/bash ubuntu \
    && apt-get update && apt-get install -y sudo \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/*


ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=22.21.1
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    dbus-x11 \
    ffmpeg \
    git \
    gnome-keyring \
    gh \
    jq \
    less \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libnss3 \
    libsecret-tools \
    locales \
    openssh-client \
    procps \
    python3 \
    ripgrep \
    unzip \
    vim \
    xz-utils \
    xvfb \
    zsh \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen \
  && arch="$(dpkg --print-architecture)" \
  && case "$arch" in \
      amd64) node_arch="x64" ;; \
      arm64) node_arch="arm64" ;; \
      *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac \
  && curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${node_arch}.tar.xz" \
    | tar -xJ --strip-components=1 -C /usr/local \
  && npm install -g @openai/codex corepack n playwright wrangler \
  && mkdir -p /usr/local/lib/antigravity \
  && curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /usr/local/lib/antigravity \
  && printf '%s\n' '#!/usr/bin/env bash' 'exec /usr/local/lib/antigravity/agy --dangerously-skip-permissions "$@"' > /usr/local/bin/agy \
  && chmod +x /usr/local/bin/agy \
  && agy --version \
  && mkdir -p /home/ubuntu/.gemini/antigravity-cli /home/ubuntu/.npm /home/ubuntu/.cache /home/ubuntu/.local/share/keyrings \
  && chmod 700 /home/ubuntu/.local/share/keyrings \
  && printf '%s\n' \
    '# Start a local keyring session for Antigravity auth persistence.' \
    'if [ -z "${XDG_RUNTIME_DIR:-}" ]; then' \
    '  export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"' \
    '  mkdir -p "$XDG_RUNTIME_DIR"' \
    '  chmod 700 "$XDG_RUNTIME_DIR"' \
    'fi' \
    'mkdir -p "$HOME/.local/share/keyrings"' \
    'chmod 700 "$HOME/.local/share/keyrings"' \
    'if command -v dbus-launch >/dev/null 2>&1 && [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then' \
    '  eval "$(dbus-launch --sh-syntax)"' \
    'fi' \
    'if command -v gnome-keyring-daemon >/dev/null 2>&1 && [ -z "${GNOME_KEYRING_CONTROL:-}" ]; then' \
    '  printf '\''\n'\'' | gnome-keyring-daemon --login >/dev/null 2>&1 || true' \
    '  eval "$(gnome-keyring-daemon --start --components=secrets)"' \
    'fi' \
    >> /home/ubuntu/.bashrc \
  && chown -R ubuntu:ubuntu /home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu/project

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TZ=Etc/UTC
ENV SHELL=/bin/bash
ENV EDITOR=vim
ENV VISUAL=vim
ENV PAGER=less
ENV TERM=xterm-256color
