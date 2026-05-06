# Keep in sync with Gemfile `ruby` directive
FROM ruby:3.4.9-slim

# For wkhtmltopdf .deb selection (Debian trixie has no wkhtmltopdf package)
ARG TARGETARCH

# App location
WORKDIR /app

# System dependencies:
# - build tools for native gems
# - postgresql client libs for pg gem
# - node/yarn for webpacker
# - imagemagick, pdftk for PDF/image features
# - wkhtmltopdf: official bookworm .deb (installs on trixie; supports amd64 + arm64)
# - libs for node-canvas
RUN apt-get update -qq && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
  build-essential \
  git \
  curl \
  wget \
  ca-certificates \
  libpq-dev \
  postgresql-client \
  imagemagick \
  pdftk-java \
  libcairo2-dev \
  libpango1.0-dev \
  libjpeg-dev \
  libgif-dev \
  librsvg2-dev \
  libxml2-dev \
  libxslt1-dev \
  libyaml-dev \
  && WKHTML_ARCH="$(if [ "$TARGETARCH" = "arm64" ]; then echo arm64; else echo amd64; fi)" \
  && wget -q -O /tmp/wkhtmltox.deb \
  "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_${WKHTML_ARCH}.deb" \
  && apt-get install -y --no-install-recommends /tmp/wkhtmltox.deb \
  && rm /tmp/wkhtmltox.deb \
  && rm -rf /var/lib/apt/lists/*

# Node 26 + yarn (see package.json engines)
RUN curl -fsSL https://deb.nodesource.com/setup_26.x | bash - \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends nodejs \
  && npm install -g yarn \
  && rm -rf /var/lib/apt/lists/*

# Ruby dependencies (BUNDLED WITH in Gemfile.lock)
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.3.19 && bundle install

# JS dependencies
COPY package.json yarn.lock* ./
RUN yarn install --frozen-lockfile || yarn install

# App source
COPY . .

# Ensure Rails can find wkhtmltopdf (initializer reads WKHTMLTOPDF_PATH)
ENV WKHTMLTOPDF_PATH=/usr/bin/wkhtmltopdf

EXPOSE 3000 3035

CMD ["bash", "-lc", "rm -f tmp/pids/server.pid && bundle exec rails db:prepare && bundle exec rails s -b 0.0.0.0 -p 3000"]
