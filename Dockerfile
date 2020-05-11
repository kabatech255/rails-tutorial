FROM ruby:2.6.3-alpine3.10

RUN apk --update --no-cache add git \
  tzdata \
  libxml2-dev \
  curl-dev \
  make \
  gcc \
  libc-dev \
  g++ \
  mariadb-dev \
  linux-headers \
  nodejs

ENV APP_ROOT /var/www/myapp

WORKDIR $APP_ROOT

COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install && \
    apk update

COPY . $APP_ROOT
RUN rm -rf /usr/local/bundle/cache/* ${APP_ROOT}/vendor/bundle/cache/*