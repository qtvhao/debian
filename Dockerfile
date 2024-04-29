FROM python:3.12-bookworm

RUN which curl || apt-get update && apt-get install -y gh curl git && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN nvm install 20 && nvm use 20 && npm install -g yarn && yarn --version

RUN python3 -m venv venv && . venv/bin/activate && pip install --upgrade pip
