FROM python:3.10-alpine as base
RUN apk add build-base

FROM base
ARG SQLY=2021
ARG SQLV=3340100

RUN wget https://sqlite.org/${SQLY}/sqlite-autoconf-${SQLV}.tar.gz -O sqlite.tar.gz \
    && tar xvfz sqlite.tar.gz \
    && cd sqlite-autoconf-${SQLV} \
    && ./configure --prefix=/usr/local --build=aarch64-unknown-linux-gnu \
    && make \
    && make install \
    && cd .. \
    && rm -rf sqlite*

WORKDIR /app
COPY pyproject.toml readme.md /app/
RUN pip install -e .[dev]
COPY . /app

CMD sqlite3 --version; python -c "import sqlite3;print(sqlite3.sqlite_version)"; pytest tests/
