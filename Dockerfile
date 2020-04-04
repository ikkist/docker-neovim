FROM alpine:latest
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:ja" LC_ALL="en_US.UTF-8"

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    build-base \
    curl \
    gcc \
    git \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    musl-dev\
    neovim \
    nodejs \
    npm \
    python-dev \
    py-pip \
    python3-dev \
    py3-pip \
    ruby \
    ruby-dev \
    sudo su-exec shadow \
    && \
    rm -rf /var/cache/apk/*
    
RUN pip3 install --upgrade pip pynvim
RUN npm install -g neovim

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN groupadd -g 9000 nvim && useradd -d /home/nvim -m -s /bin/sh -u 9000 -g 9000 nvim

RUN chmod u+s /usr/sbin/usermod  &&\
    chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nvim"]
