FROM ruby:2.7.2-alpine

ENV RAILS_ENV=development
ENV BUNDLER_VERSION=2.3.14

RUN apk update && apk upgrade && \
    apk add --no-cache \
    build-base \
    linux-headers \
    nodejs \
    yarn \
    tzdata \
    bash \
    mysql-dev \
    libxml2-dev \
    libxslt-dev \
    readline-dev \
    file \
    git \
    imagemagick \
    shared-mime-info \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    libc6-compat

RUN gem install bundler -v $BUNDLER_VERSION

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config set force_ruby_platform true

RUN bundle install

COPY . .

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]


CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]