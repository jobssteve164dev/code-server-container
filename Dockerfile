FROM codercom/code-server:latest

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=22.21.1
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    less \
    locales \
    procps \
    python3 \
    ripgrep \
    unzip \
    xz-utils \
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
  && npm install -g @google/gemini-cli \
  && mkdir -p /root/.gemini /root/.npm /root/.cache

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TZ=Etc/UTC
ENV SHELL=/bin/bash
ENV EDITOR=vim
ENV VISUAL=vim
ENV PAGER=less
ENV TERM=xterm-256color

