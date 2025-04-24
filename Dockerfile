FROM ruby:3.2.2

# Install dependencies
RUN apt-get update && apt-get install -y \
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
    libjpeg62-turbo

# Download and install wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb
RUN dpkg -i wkhtmltox_0.12.6.1-3.bookworm_amd64.deb || true
RUN apt-get install -f -y

# Clean up
RUN rm wkhtmltox_0.12.6.1-3.bookworm_amd64.deb
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
COPY . .

RUN rake assets:precompile

# Expose the port
EXPOSE 3000

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]