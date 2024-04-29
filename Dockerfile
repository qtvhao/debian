FROM python:3.12-bookworm

RUN apt-get update && apt-get install -y curl git gh && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN python3 -m venv venv && . venv/bin/activate && pip install --upgrade pip
# 
RUN . venv/bin/activate && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh |  bash
RUN . venv/bin/activate && apt-get update && apt-get install -y samba-client cifs-utils
RUN . venv/bin/activate && . $HOME/.nvm/nvm.sh && nvm install 20 && nvm use 20 && npm install -g yarn && yarn --version && npm --version \
    && npm cache clean --force && yarn cache clean --force && rm -rf /tmp/* /var/tmp/* /root/.npm

RUN . venv/bin/activate && . $HOME/.nvm/nvm.sh && nvm use 20 &&  apt-get update && apt-get install -y wget && \
    apt-get install -y imagemagick && \
    wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x wait-for-it.sh && \
    apt-get install curl sudo -y && \
    apt-get install gnupg -y && \
    npm install -g --force yarn && \
    apt-get install lsb-release -y && \
    curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list && \
    sudo apt-get update && sudo apt-get install cloudflare-warp -y && \
    apt-get install redis-tools -y
