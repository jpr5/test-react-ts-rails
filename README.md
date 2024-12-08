# Full Stack Application

A modern web application built with React (TypeScript) frontend and Ruby on Rails backend, containerized for easy deployment.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Generate a secret key for Rails:
```bash
SECRET_KEY_BASE=$(openssl rand -hex 64)
```

3. Start the application:
```bash
SECRET_KEY_BASE=$SECRET_KEY_BASE docker-compose up --build
```

The application will be available at:
- Frontend and API: http://localhost:3000

## Development Setup

While Docker Compose is the recommended way to run the application, you can also set up the development environment locally:

### Backend Setup:
```bash
cd fullstack-app
bundle install
bundle execrails db:create db:migrate
bundle exec rails server
```

### Frontend Setup:
```bash
cd ../fullstack-app-frontend
yarn install
yarn dev
```

## Docker Compose Commands

### Start the application:
```bash
SECRET_KEY_BASE=$SECRET_KEY_BASE docker-compose up --build
```

### Stop the application:
```bash
docker-compose down
```

### View logs:
```bash
docker-compose logs -f
```

### Run database migrations:
```bash
docker-compose exec web rails db:migrate
```

### Access database console:
```bash
docker-compose exec db psql -U postgres -d fullstack_app_production
```

### Rebuild containers:
```bash
docker-compose build
```

## Environment Variables

### Required:
- `SECRET_KEY_BASE`: Rails secret key for production (generated in quick start)

### Optional:
- `POSTGRES_USER`: Database username (default: postgres)
- `POSTGRES_PASSWORD`: Database password (default: postgres)
- `RAILS_ENV`: Rails environment (default: production)
- `RAILS_LOG_TO_STDOUT`: Enable logging to stdout (default: true)

## Data Persistence

PostgreSQL data is persisted in a Docker volume. To remove all data:
```bash
docker-compose down -v
```

## Testing

Run tests inside the containers:
```bash
# Backend tests
docker-compose exec web rails test

# Frontend tests
docker-compose exec web sh -c 'cd /app/frontend && yarn test'
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
