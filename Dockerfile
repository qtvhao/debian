FROM python:3.12-bookworm

# set -xe is used to exit immediately if a command exits with a non-zero status, and print the command to stderr.
# -u is used to force the stdout and stderr streams to be unbuffered.
ENV DEBIAN_FRONTEND noninteractive
ENV DL_GOOGLE_CHROME_VERSION="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        gh \
        samba-client \
        cifs-utils \
        wget \
        imagemagick \
        sudo \
        gnupg \
        lsb-release \
        redis-tools \
        procps \
        dbus \
        upower \
        chromium \
        unzip \
        socat \
        locales \
        task-japanese \
    ; \
    curl -sSL -o google-chrome-stable_current_amd64.deb $DL_GOOGLE_CHROME_VERSION; \
    dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy --no-install-recommends install; \
    rm google-chrome-stable_current_amd64.deb; \
    which google-chrome-stable; \
    curl -sSL -o chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$(curl -sSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip; \
    unzip chromedriver_linux64.zip; \
    mv chromedriver /usr/local/bin/; \
    rm chromedriver_linux64.zip; \
    which chromedriver; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh |  bash; \
    . $HOME/.nvm/nvm.sh; \
    nvm install 20; \
    nvm use 20; \
    npm install -g yarn; \
    yarn --version; \
    npm --version; \
    npm cache clean --force; \
    yarn cache clean --force; \
    rm -rf /tmp/* /var/tmp/* /root/.npm; \
    apt-get autoremove -y; \
    apt-get autoclean -y; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN mkdir -p /var/run/dbus;

RUN echo "" > "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_user_watches=95956992" >> "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_user_instances=32768" >> "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_queued_events=4194304" >> "/etc/sysctl.d/local.conf";
# RUN apt-get update && apt-get install -y curl git gh && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# RUN python3 -m venv venv && . venv/bin/activate && pip install --upgrade pip
# # 
# RUN . venv/bin/activate && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh |  bash
# RUN . venv/bin/activate && apt-get update && apt-get install -y samba-client cifs-utils
# RUN . venv/bin/activate && . $HOME/.nvm/nvm.sh && nvm install 20 && nvm use 20 && npm install -g yarn && yarn --version && npm --version \
#     && npm cache clean --force && yarn cache clean --force && rm -rf /tmp/* /var/tmp/* /root/.npm

# RUN . venv/bin/activate && . $HOME/.nvm/nvm.sh && nvm use 20 &&  apt-get update && apt-get install -y wget && \
#     apt-get install -y imagemagick && \
#     wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
#     chmod +x wait-for-it.sh && \
#     apt-get install curl sudo -y && \
#     apt-get install gnupg -y && \
#     npm install -g --force yarn && \
#     apt-get install lsb-release -y && \
#     curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
#     echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list && \
#     sudo apt-get update && sudo apt-get install cloudflare-warp -y && \
#     apt-get install redis-tools -y
# FROM debian:stable-slim

# RUN apt-get update && apt-get install -y --no-install-recommends procps
# RUN echo "" > "/etc/sysctl.d/local.conf"
# RUN echo "fs.inotify.max_user_watches=95956992" >> "/etc/sysctl.d/local.conf"
# RUN echo "fs.inotify.max_user_instances=32768" >> "/etc/sysctl.d/local.conf"
# RUN echo "fs.inotify.max_queued_events=4194304" >> "/etc/sysctl.d/local.conf"

# RUN set -xe; \
#     apt-get update; \
#     which dbus-daemon || apt-get install -y --no-install-recommends dbus; \
#     which dbus-daemon; \
#     apt-get purge -y --auto-remove; \
#     rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /var/cache/debconf/*-old /var/cache/debconf/*-new /var/cache/debconf/*-dist
# RUN mkdir -p /var/run/dbus


# ENV DEBIAN_FRONTEND noninteractive
# ENV DL_GOOGLE_CHROME_VERSION="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# RUN set -xe; \
#         apt-get update && apt-get install -y --no-install-recommends curl ca-certificates upower chromium; \
#         curl -sSL -o google-chrome-stable_current_amd64.deb $DL_GOOGLE_CHROME_VERSION; \
#         dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy --no-install-recommends install; \
#         rm google-chrome-stable_current_amd64.deb; \
#         which google-chrome-stable; \
#         apt-get install -y --no-install-recommends unzip; \
#         curl -sSL -o chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$(curl -sSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip; \
#         apt-get install -y --no-install-recommends unzip; \
#         unzip chromedriver_linux64.zip; \
#         mv chromedriver /usr/local/bin/; \
#         rm chromedriver_linux64.zip; \
#         which chromedriver; \
#         apt-get purge -y unzip; \
#         apt-get autoremove -y; \
#         apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN which socat || apt-get update && apt-get install -y --no-install-recommends socat && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# RUN apt-get update && apt-get install -y samba-client cifs-utils

# # Locale settings (japanese)
# RUN apt update && apt-get install -y locales task-japanese \
#   && locale-gen vi_VN.UTF-8 \
#   && localedef -f UTF-8 -i vi_VN vi_VN
# ENV LANG vi_VN.UTF-8
# ENV LANGUAGE vi_VN:jp
# ENV LC_ALL vi_VN.UTF-8

# EXPOSE 80
# WORKDIR /root
# COPY ./loop-healthcheck .

# CMD ["./loop-healthcheck"]
