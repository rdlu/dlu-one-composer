#! /usr/bin/fish
set PROJECT $argv[1]
docker-compose -f compose/$PROJECT.docker-compose.yml -p $PROJECT logs -f