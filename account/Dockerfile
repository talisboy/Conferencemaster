FROM ruby:1.9

# Install packages
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /app
WORKDIR /app
RUN bundle install
