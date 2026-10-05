#!/bin/bash
cd ~/homelab
docker compose pull visit-counter
docker compose up -d visit-counter
docker image prune -f
