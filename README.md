# MostlyMatter Docker Container

A minimal Docker container for running [MostlyMatter](https://packages.framasoft.org/projects/mostlymatter/), a fork of Mattermost.

## Quick Start

### Using Docker Compose (Recommended)

1. Clone this repository:
   ```bash
   git clone https://github.com/River-City-Rainbow-Foundation/mostlymatter-docker
   cd mostlymatter-docker
   ```

2. Start the containers:
   ```bash
   docker-compose up -d
   ```

3. Access MostlyMatter at: http://localhost:8065

### Using Docker Only

1. Build the container:
   ```bash
   docker build -t mostlymatter:latest .
   ```

2. Run the container:
   ```bash
   docker run -p 8065:8065 mostlymatter:latest
   ```

## Configuration

### Environment Variables

The container supports the following environment variables:

- `MM_SERVICESETTINGS_SITEURL`: The URL where MostlyMatter will be accessible
- `MM_SQLSETTINGS_DRIVERNAME`: Database driver (postgres or mysql)
- `MM_SQLSETTINGS_DATASOURCE`: Database connection string

### Volumes

The container uses the following volumes:

- `/mattermost/data`: Application data
- `/mattermost/logs`: Log files
- `/mattermost/config`: Configuration files
- `/mattermost/config/config.json`: Main configuration file

### Configuration File

A complete `config.json` file is provided with default settings. Key configuration points:

- **Database**: Configured for PostgreSQL (update `SqlSettings.DataSource` with your database connection string)
- **Site URL**: Set `ServiceSettings.SiteURL` to your domain
- **Email**: Email notifications are disabled by default
- **File Storage**: Uses local file system storage
- **Security**: Default security settings for development

To customize the configuration:
1. Edit the `config.json` file
2. Restart the container: `docker-compose restart mostlymatter`

## Docker Compose Setup

The provided `docker-compose.yml` includes:

- **mostlymatter**: The MostlyMatter application container
- **db**: PostgreSQL database container

### Default Database Configuration

- **Username**: mostlymatter
- **Password**: password
- **Database**: mattermost
- **Port**: 5432

## Building from Source

The Dockerfile uses a multi-stage build:

1. **Fetcher stage**: Downloads the MostlyMatter binary from Framasoft
2. **Runtime stage**: Creates a minimal container with the binary

### Build Arguments

- `MOSTLYMATTER_VERSION`: Version to download (default: v10.11.3)

Example:
```bash
docker build --build-arg MOSTLYMATTER_VERSION=v10.11.3 -t mostlymatter:latest .
```

## Security Notes

- The container runs as a non-root user (`mattermost`)
- Uses minimal dependencies (only ca-certificates and tzdata)
- Based on Debian bookworm-slim for security and size

## Troubleshooting

### Check Container Status
```bash
docker-compose ps
```

### View Logs
```bash
docker-compose logs mostlymatter
```

### Test Binary
```bash
docker run --rm mostlymatter:latest version
```

## License

This project is licensed under the same license as MostlyMatter.
