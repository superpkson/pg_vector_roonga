FROM postgres:18

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    lsb-release \
    wget \
    make \
    build-essential \
    postgresql-server-dev-all \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    git clone --branch v0.8.5 https://github.com/pgvector/pgvector.git && \
    cd /tmp/pgvector && \
    make && \
    make install&& \
    rm -rf /tmp/pgvector

RUN wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb &&  \
    apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb &&  \
    apt update &&  \
    apt install -y -V postgresql-18-pgdg-pgroonga &&  \
    apt install -y -V groonga-tokenizer-mecab &&  \
    apt install -y -V groonga-plugin-language-model && \
    rm -rf /var/lib/apt/lists/* && \
    rm ./groonga-apt-source-latest-$(lsb_release -cs).deb

RUN apt-get remove -y \
    build-essential \
    git \
    postgresql-server-dev-18 \
    wget \
    lsb-release \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d && \
    echo "CREATE EXTENSION IF NOT EXISTS pgroonga;" >> /docker-entrypoint-initdb.d/01-init-extensions.sql && \
    echo "CREATE EXTENSION IF NOT EXISTS vector;" >> /docker-entrypoint-initdb.d/01-init-extensions.sql

USER postgres
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
