FROM python:3.12-bookworm

RUN apt-get update && apt-get install -y curl git gh && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh |  bash
RUN . $HOME/.nvm/nvm.sh && nvm install 20 && nvm use 20 && npm install -g yarn && yarn --version && yarn global add npm@10.6.0 && npm --version \
    && npm cache clean --force && yarn cache clean --force && rm -rf /tmp/* /var/tmp/* /root/.npm /root/.node-gyp /root/.cache /root/.config /root/.yarn /root/.config /root/.local /root/.nvm /root/.npmrc /root/.yarnrc /root/.pnp /root/.pnp.js /root/.yarn-integrity

RUN python3 -m venv venv && . venv/bin/activate && pip install --upgrade pip
