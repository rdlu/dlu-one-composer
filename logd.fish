#! /usr/bin/fish
set -q argv[1]; or set argv[1] traefik
set PROJECT $argv[1]

docker-compose -f compose/$PROJECT.docker-compose.yml -p $PROJECT logs -f