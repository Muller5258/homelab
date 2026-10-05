# Homelab

Self-hosted Linux server running Dockerized services, built to learn Docker, networking and server operations hands-on.

Runs on an old Dell laptop with Ubuntu Server 26.04 LTS.

## Services

| Service | Purpose |
| --- | --- |
| Caddy | Reverse proxy - the only container with an open port |
| Uptime Kuma | Uptime monitoring |
| Portainer | Docker management UI |
| Nextcloud + PostgreSQL | Private file cloud |
| visit-counter + PostgreSQL | My own app, deployed automatically from GitHub |

## Architecture

    Browser -> Caddy (port 80) -> services on "proxy" network
                                     |
                         databases on isolated backend networks

- Each service gets its own hostname via nip.io instead of a port number
- Databases sit on separate internal networks, unreachable from the proxy
- Each app has its own database, so one failure doesn't affect the other

## Security

- SSH key-only login, password authentication disabled
- UFW firewall
- Secrets in `.env`, never committed (see `.env.example`)
- App containers run as a non-root user

## CI/CD

The visit-counter app is built by GitHub Actions on every push and published to GHCR.
`deploy.sh` runs every 5 minutes via cron, pulls the new image and replaces the container only if it changed.

## Lessons learned

- **Empty config file:** Caddy kept restarting with an `EOF` error. A typo in the filename meant the real `Caddyfile` was empty.
- **Special characters in passwords:** A base64 password containing `/` broke the PostgreSQL connection URL. Switched to hex passwords for anything that goes inside a URL.
- **Portainer setup token:** Newer Portainer versions require a one-time token from the container logs before creating the admin user.
- **Config overrides:** Disabling SSH password login required editing a cloud-init file in `sshd_config.d/` that overrode the main config.

## Setup

    cp .env.example .env   # fill in values
    docker compose up -d
