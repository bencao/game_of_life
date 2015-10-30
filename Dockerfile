FROM debian:jessie

MAINTAINER ben@bencao.it

RUN apt-get update && \
    apt-get install -y curl wget locales git && \
    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get update && \
    apt-get install -y elixir nodejs && \
    apt-get clean


# setup utf-8 locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

WORKDIR /usr/src/app

EXPOSE 4000

ADD . /usr/src/app

RUN mix local.hex --force && mix local.rebar --force && mix deps.get

CMD mix phoenix.server
