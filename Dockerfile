# Dockerfile for Rails 8 + Ruby 3.4.4 + full defaults
FROM ruby:3.4.4

# Build args
ARG RAILS_VERSION=latest

# Install Node.js 18 and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn@1.22.19

# System dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  postgresql-client \
  git \
  curl

# Install Bundler
ENV BUNDLER_VERSION=2.5.6
RUN gem install bundler:$BUNDLER_VERSION

# Install Rails
RUN if [ "$RAILS_VERSION" = "latest" ]; then \
      gem install rails; \
    else \
      gem install rails -v "$RAILS_VERSION"; \
    fi

# Set working directory
WORKDIR /app

# Expose default Rails port
EXPOSE 3000

# Default command
CMD ["irb"]
