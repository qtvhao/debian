FROM debian:stable
# python:3.12-bookworm
# COPY --from=python:3.12-bookworm / /
# Set the working directory for the container
WORKDIR /app/

# set -xe is used to exit immediately if a command exits with a non-zero status, and print the command to stderr.
# -u is used to force the stdout and stderr streams to be unbuffered.
ENV DEBIAN_FRONTEND noninteractive
#ENV DL_GOOGLE_CHROME_VERSION="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
# RUN python3 -m venv venv

#ENV NVM_DIR="/root/.nvm"
#ENV NODE_VERSION="20.12.2"
# ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$NVM_DIR/v$NODE_VERSION/bin:/root/.nvm/versions/node/v$NODE_VERSION/bin/:$PATH

# Install the required packages

#RUN echo "" > "/etc/sysctl.d/local.conf"; \
#    echo "fs.inotify.max_user_watches=95956992" >> "/etc/sysctl.d/local.conf"; \
#    echo "fs.inotify.max_user_instances=32768" >> "/etc/sysctl.d/local.conf"; \
#    echo "fs.inotify.max_queued_events=4194304" >> "/etc/sysctl.d/local.conf";

#FROM base as requirements
#COPY requirements.txt /app/
#RUN python3 -m venv venv
#RUN . venv/bin/activate && pip install --no-cache-dir -r requirements.txt

#FROM base as yarn
#COPY package.json yarn.lock /app/
#RUN . venv/bin/activate && . $HOME/.nvm/nvm.sh && yarn install --no-cache

#FROM base
#COPY requirements.txt /app/
#COPY --from=requirements /app/venv /app/venv
# RUN . venv/bin/activate && . $HOME/.nvm/nvm.sh && pip install --no-cache-dir -r requirements.txt
#COPY package.json yarn.lock /app/
#COPY --from=yarn /app/node_modules /app/node_modules
