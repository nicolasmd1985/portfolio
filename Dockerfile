FROM ruby:3.2.2

# Install dependencies (Node includes npm, remove yarn from apt)
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# <<< Install Yarn using NPM >>>
RUN npm install -g yarn
# Optional: check the version installed
RUN yarn --version

# Download and install wkhtmltopdf
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

# <<< Add debug step to list files >>>
RUN echo "--- Contents of /app ---" && ls -la && echo "------------------------"

# === Fixes Area ===
# 1. Ensure Yarn packages are installed (use --frozen-lockfile for consistency)
RUN yarn install --frozen-lockfile
# === End Fixes Area ===

# 2. Set environment variables necessary for asset precompilation
ENV RAILS_ENV=production
# ENV SECRET_KEY_BASE=dummy_secret_key_for_build # Keep commented unless proven necessary by logs

# 3. Precompile assets
RUN rake assets:precompile # Check build logs if this fails again

# Expose the port
EXPOSE 3000

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]