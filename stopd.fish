#! /usr/bin/fish
set -q argv[1]; or set argv[1] traefik
set PROJECT $argv[1]
set -x UID (id -u (whoami))
set -x GID (id -g (whoami))
sudo systemctl start docker
docker-compose -f compose/$PROJECT.docker-compose.yml -p $PROJECT down