## Multi stage build
## Install golang tool
FROM golang:1.14-stretch AS build-env
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go get golang.org/x/tools/gopls@latest
# ENV LEMONADE_REPO="github.com/pocke/lemonade"
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go get -u -ldflags="-w -s" ${LEMONADE_REPO}
# RUN GOOS=windows GOARCH=amd64 go get -u -ldflags="-H windowsgui -w -s" ${LEMONADE_REPO}

### Main
FROM alpine:latest
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:ja" LC_ALL="en_US.UTF-8" \
    DEFAULT_NVIM_GROUP_ID="20001" \
    DEFAULT_NVIM_GROUP_NAME="nvimgrp" \
    DEFAULT_NVIM_USER_ID="10001" \
    XDG_CONFIG_HOME="/etc/xdg/config" \
    XDG_CACHE_HOME="/etc/xdg/cache" \
    XDG_DATA_HOME="/etc/xdg/data"

## alpine3.11 doesn't support ripgrep(rg) command
## alpine edge supports ripgrep.
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk update && \
    apk upgrade && \
    apk --no-cache add  \
    git \
    libxml2-dev \
    libxslt-dev \
    musl-dev\
    neovim \
    neovim-doc\
    nodejs \
    python-dev \
    python3-dev \
    ruby \
    npm \
    su-exec shadow \
    fzf ripgrep bash xclip

COPY --chown=0:${DEFAULT_NVIM_GROUP_ID} config ${XDG_CONFIG_HOME}
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN apk --no-cache --virtual .only-build add \
    build-base \
    curl \
    gcc \
    linux-headers \
    py-pip \
    py3-pip \
    ruby-dev && \
    gem install neovim && \
    pip3 install --upgrade pip pynvim && \
    npm install -g neovim && \
    groupadd -g ${DEFAULT_NVIM_GROUP_ID} ${DEFAULT_NVIM_GROUP_NAME} && useradd -d /home/nvim -m -s /bin/bash -u ${DEFAULT_NVIM_USER_ID} nvim && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    mkdir -p ${XDG_DATA_HOME} ${XDG_CACHE_HOME} && \
## Install Language Server
    npm install -g --production dockerfile-language-server-nodejs \
    bash-language-server \
    vue-language-server && \
    nvim +UpdateRemotePlugins +qa  --headless && \
    nvim +'CocInstall -sync coc-go coc-sh coc-vetur coc-tsserver coc-json coc-prettier coc-eslint coc-tslint coc-docker' +qa --headless && \
    chmod g+wrx -R /etc/xdg && chown -R :${DEFAULT_NVIM_GROUP_NAME} /etc/xdg && \
    chmod g+wrx -R /etc/xdg && chown -R :${DEFAULT_NVIM_GROUP_NAME} /etc/xdg && find /etc/xdg -type d -name ".git" | xargs -i rm -r {} && apk del --purge .only-build

##COPY --from=build-env /go/bin/lemonade /usr/local/bin/
COPY --from=build-env /go/bin/golsp /usr/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nvim"]
