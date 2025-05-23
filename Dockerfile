# Dockerfile
FROM ruby:3.4.4

# Build args
ARG RAILS_VERSION=latest

# Install Node.js 18 and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# System dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  postgresql-client \
  git \
  curl

# Install Rails
RUN if [ "$RAILS_VERSION" = "latest" ]; then \
      gem install rails; \
    else \
      gem install rails -v "$RAILS_VERSION"; \
    fi

WORKDIR /app

CMD [ "irb" ]
