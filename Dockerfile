# Use Ruby 3.2.2 as the base image
FROM ruby:3.2.2 AS builder

# Install essential build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    pkg-config \
    nodejs \
    yarn \
    postgresql-client \
    && apt-get clean

# Set the working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock for caching
COPY Gemfile Gemfile.lock ./

# Configure bundler for deployment
RUN bundle config set --local deployment 'true' \
    && bundle config set --local without 'development test' \
    && bundle install

# Copy the rest of the application code
COPY . .

# Install JavaScript dependencies and precompile assets
RUN yarn install \
    && RAILS_ENV=production bundle exec rake assets:precompile \
    && apt-get clean

# Final stage
FROM ruby:3.2.2

# Install only essential runtime dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && apt-get clean

# Create a non-root user
RUN useradd -m appuser
USER appuser

# Set the working directory
WORKDIR /app

# Copy necessary artifacts from the builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

# Set production environment variables
ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    PORT=3000 \
    LANG=C.UTF-8 \
    MALLOC_ARENA_MAX=2

# Expose port 3000
EXPOSE 3000

# Command to run the application
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]