FROM ruby:3.2.2

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    yarn \
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
    # Removed duplicate libjpeg62-turbo \
    && rm -rf /var/lib/apt/lists/* # Clean up in the same layer

# Download and install wkhtmltopdf
# Combine wkhtmltopdf steps and clean up
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && dpkg -i wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && apt-get install -f -y --no-install-recommends \
    && rm wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

# Install Bundler
RUN gem install bundler

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs $(nproc) --retry 3

# Copy the rest of the application code
COPY . .

# === Potential Fixes ===
# 1. Ensure Yarn packages are installed
RUN yarn install

# 2. Set environment variables necessary for asset precompilation
ENV RAILS_ENV=production
# ENV SECRET_KEY_BASE=dummy_secret_key_for_build # Uncomment if needed, check detailed logs first

# 3. Precompile assets
# Add --trace for more verbose output during debugging if needed
RUN rake assets:precompile # Check the detailed build log output for errors here!
# === End Potential Fixes ===

# Revert RAILS_ENV if needed for development-like commands later, or set it in CMD/ENTRYPOINT
# ENV RAILS_ENV=development

# Expose the port
EXPOSE 3000

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]