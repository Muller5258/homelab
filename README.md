# Homelab

Self-hosted Linux server running Dockerized services, built to learn Docker and server operations hands-on.

## Stack
- Caddy - reverse proxy
- Uptime Kuma - uptime monitoring
- Portainer - Docker management UI
- Nextcloud + PostgreSQL - private file cloud

## Highlights
- All services defined in one Docker Compose file
- Only Caddy exposes a port; everything else is internal
- Database isolated on a separate backend network
- Secrets kept in .env, never committed
- SSH key-only access, UFW firewall

## Setup
cp .env.example .env   # fill in values
docker compose up -d
