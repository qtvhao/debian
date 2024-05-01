FROM scratch as base
# Squash the image to reduce the size
COPY --from=python:3.12-bookworm / /
# Set the working directory for the container
WORKDIR /app/

# set -xe is used to exit immediately if a command exits with a non-zero status, and print the command to stderr.
# -u is used to force the stdout and stderr streams to be unbuffered.
ENV DEBIAN_FRONTEND noninteractive
ENV DL_GOOGLE_CHROME_VERSION="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
RUN python3 -m venv venv

ENV NVM_DIR="/root/.nvm"
ENV NODE_VERSION="20.12.2"
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$NVM_DIR/v$NODE_VERSION/bin:/root/.nvm/versions/node/v$NODE_VERSION/bin/:$PATH

RUN set -xe; \
    . venv/bin/activate; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        gnome-screenshot \
        curl \
        git \
        gh \
        samba-client \
        cifs-utils \
        wget \
        imagemagick \
        ffmpeg \
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
        ca-certificates \
        fonts-liberation \
        fonts-dejavu \
        fonts-freefont-ttf \
        fonts-ipafont-gothic \
        fonts-ipafont-mincho \
        fonts-wqy-zenhei \
        fonts-wqy-microhei \
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
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh |  bash; \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc; \
    . $HOME/.nvm/nvm.sh; \
    nvm install 20; \
    nvm use 20; \
    npm install -g yarn; \
    yarn --version; \
    npm --version; \
    npm cache clean --force; \
    yarn cache clean --force; \
    apt-get purge -y --auto-remove chromium; \
    apt-get autoremove -y; \
    apt-get autoclean -y; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*; \
    rm -rf /tmp/* /var/tmp/*; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*;
RUN which yarn
RUN . venv/bin/activate && wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x wait-for-it.sh
RUN mkdir -p /var/run/dbus;

RUN echo "" > "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_user_watches=95956992" >> "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_user_instances=32768" >> "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_queued_events=4194304" >> "/etc/sysctl.d/local.conf";

FROM base as requirements
COPY requirements.txt /app/
RUN python3 -m venv venv
RUN . venv/bin/activate && pip install --no-cache-dir -r requirements.txt

FROM base as yarn
COPY package.json yarn.lock /app/
RUN . venv/bin/activate && . $HOME/.nvm/nvm.sh && yarn install --no-cache

FROM base
COPY requirements.txt /app/
COPY --from=requirements /app/venv /app/venv
# RUN . venv/bin/activate && . $HOME/.nvm/nvm.sh && pip install --no-cache-dir -r requirements.txt
COPY package.json yarn.lock /app/
COPY --from=yarn /app/node_modules /app/node_modules
