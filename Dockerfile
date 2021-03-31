FROM python:3.9-slim

WORKDIR /app

COPY /app/requirements.txt /app/requirements.txt

RUN set -ex \
    && buildDeps=' \
        gcc \
        libbz2-dev \
        libc6-dev \
        libgdbm-dev \
        liblzma-dev \
        libncurses-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libpcre3-dev \
        make \
        tcl-dev \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
    ' \
    && deps=' \
        libexpat1 \
        vim \
        less \
        cron \
        curl \
        procps \
    ' \
    && apt-get update && apt-get install -y $buildDeps $deps --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove $buildDeps \
    && find /usr/local -depth \
    \( \
        \( -type d -a -name test -o -name tests \) \
        -o \
        \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    \) -exec rm -rf '{}' + \
    && pip install -r /app/requirements.txt \
    && rm -rf /root/.cache/pip/

EXPOSE 80