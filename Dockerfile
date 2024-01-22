FROM ruby:3.2.2-alpine

ARG RAILS_ENV
ENV RAILS_ENV=development

RUN apk update && apk add --no-cache build-base \
                                     mysql-dev \
                                     ruby-dev \
                                     libc-dev \
                                     linux-headers
RUN apk update && apk add curl && apk add bash

# Install Node 16.x
RUN curl -sL https://deb.nodesource.com/setup_16.x
RUN apk add --update nodejs npm

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg
RUN apk update && apk fetch gnupg && apk add gnupg && gpg --list-keys
RUN apk update && apk add yarn
RUN apk add libpq-dev

# Install ImageMagick and libvips:
RUN apk update && apk add --no-cache imagemagick
RUN apk update && apk add --upgrade vips-dev
RUN apk add --no-cache libc6-compat gcompat

RUN mkdir /rails-app
WORKDIR /rails-app

RUN gem install bundler -v 2.4.17
RUN gem install rails -v 6.1.7.4

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

COPY . .

# # RUN rm -rf storage/* nod_modules config/application.yml tmp/cache log/*

# COPY ./entrypoints/docker-entrypoint.sh /usr/bin/

# RUN chmod +x /usr/bin/docker-entrypoint.sh

# ENTRYPOINT ["docker-entrypoint.sh"]