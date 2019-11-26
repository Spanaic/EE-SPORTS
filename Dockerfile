FROM ruby:2.5.5
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    node.js
RUN mkdir /myapi

ENV HOME /myapi
WORKDIR $HOME

COPY ./Gemfile $HOME/
COPY ./Gemfile.lock $HOME/

ENV Bundler version 2.0.2
RUN gem install bundler && bundle
ADD . $HOME
