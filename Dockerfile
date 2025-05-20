FROM ruby:3.2.2

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \ 
    nodejs \
    npm \
    postgresql-client \
    wget \
    fontconfig \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxrender1 \
    xfonts-75dpi \
    xfonts-base \
    && rm -rf /var/lib/apt/lists/*

# Install Yarn using NPM
RUN npm install -g yarn
RUN yarn --version

# Download and install wkhtmltopdf (ensure bookworm package is correct for base image)
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && dpkg -i wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && apt-get install -f -y --no-install-recommends \
    && rm wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Bundler
RUN gem install bundler --conservative

# Copy Gemfile and install gems first for layer caching
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs $(nproc) --retry 3

# Copy package.json and install yarn packages
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Set environment variables
ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV} \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

# Precompile assets with a temporary secret key base
RUN if [ "$RAILS_ENV" = "production" ]; then \
    SECRET_KEY_BASE=precompile_placeholder bundle exec rake assets:precompile; \
    fi

# Clean up unnecessary files
RUN rm -rf /app/tmp/* /app/log/* \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# Expose the port
EXPOSE 3000

# Start the server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]