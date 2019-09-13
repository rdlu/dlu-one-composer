#! /usr/bin/fish
set PROJECT $argv[1]
sudo systemctl start docker
docker-compose -f $PROJECT.docker-compose.yml -p $PROJECT up -d 