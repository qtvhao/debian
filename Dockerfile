FROM python:3.12-bookworm

# set -xe is used to exit immediately if a command exits with a non-zero status, and print the command to stderr.
# -u is used to force the stdout and stderr streams to be unbuffered.
ENV DEBIAN_FRONTEND noninteractive
ENV DL_GOOGLE_CHROME_VERSION="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
RUN python3 -m venv venv
RUN set -xe; \
    . venv/bin/activate; \
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
        ca-certificates \
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
    . $HOME/.nvm/nvm.sh; \
    nvm install 20; \
    nvm use 20; \
    npm install -g yarn; \
    yarn --version; \
    npm --version; \
    npm cache clean --force; \
    yarn cache clean --force; \
    apt-get autoremove -y; \
    apt-get autoclean -y; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*; \
    rm -rf /tmp/* /var/tmp/*; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*;
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x wait-for-it.sh &&
RUN mkdir -p /var/run/dbus;

RUN echo "" > "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_user_watches=95956992" >> "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_user_instances=32768" >> "/etc/sysctl.d/local.conf"; \
    echo "fs.inotify.max_queued_events=4194304" >> "/etc/sysctl.d/local.conf";

WORKDIR /app/
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY package.json yarn.lock /app/
RUN yarn install
