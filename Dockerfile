FROM ruby:2.6.5-alpine3.11

ENV ROOT="/app"

RUN apk update \
    && apk upgrade  \
    && apk add --no-cache \
    gcc \
    g++ \
    libc-dev \
    libxml2-dev \
    linux-headers \
    make \
    nodejs \
    postgresql \
    postgresql-dev \
    tzdata \
    yarn \
    && yarn install \
    && apk add --virtual build-packs --no-cache \
    build-base \
    curl-dev

RUN mkdir ${ROOT}
WORKDIR ${ROOT}
COPY Gemfile ${ROOT}
COPY Gemfile.lock ${ROOT}

RUN bundle install
RUN apk del build-packs

COPY . ${ROOT}

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
