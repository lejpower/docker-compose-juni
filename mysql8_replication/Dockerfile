# Dockerfile
FROM ruby:3.1.6

# Install dependencies
RUN apt-get update && apt-get install -y default-mysql-client vim vi

# Set the working directory
WORKDIR /usr/src/app

# Install Bundler
RUN gem install bundler -v 2.5.18

# Copy the current directory to the container
COPY ./rails_related/Gemfile /usr/src/app/

# Run Bundler to install gems
RUN bundle install
