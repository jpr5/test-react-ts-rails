# Stage 1: Build React application
FROM node:18-alpine AS frontend-builder
WORKDIR /app/frontend
COPY fullstack-app-frontend/package.json fullstack-app-frontend/yarn.lock ./
RUN yarn install --frozen-lockfile
COPY fullstack-app-frontend/ ./
RUN yarn build

# Stage 2: Build Rails application
FROM ruby:3.2.2-alpine AS backend-builder
WORKDIR /app/backend
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    git

COPY fullstack-app/Gemfile fullstack-app/Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3
COPY fullstack-app/ ./
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Stage 3: Production image
FROM ruby:3.2.2-alpine
WORKDIR /app

# Install production dependencies
RUN apk add --no-cache \
    postgresql-client \
    nginx \
    tzdata \
    gcompat \
    build-base \
    postgresql-dev \
    && mkdir -p /run/nginx

# Copy built React app
COPY --from=frontend-builder /app/frontend/dist /usr/share/nginx/html

# Copy Rails app
COPY --from=backend-builder /app/backend /app
COPY --from=backend-builder /usr/local/bundle/ /usr/local/bundle/

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Script to start both Nginx and Rails
RUN echo "#!/bin/sh" > /start.sh \
    && echo "nginx" >> /start.sh \
    && echo "rails server -b 0.0.0.0 -e production" >> /start.sh \
    && chmod +x /start.sh

# Set production environment
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Expose port 80
EXPOSE 80

# Start Nginx and Rails
CMD ["/start.sh"]
