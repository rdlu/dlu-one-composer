#! /usr/bin/fish
set PROJECT $argv[1]
sudo systemctl start docker
docker-compose -f compose/traefik.docker-compose.yml -p traefik up -d 
docker-compose -f compose/$PROJECT.docker-compose.yml -p $PROJECT up -d 