#! /usr/bin/fish

set -q argv[1]; or set argv[1] traefik
set PROJECT $argv[1]
set -x UID (id -u (whoami))
set -x GID (id -g (whoami))

sudo systemctl start docker
set_color cyan; echo "Making sure traefik is running..."
set_color grey; docker-compose -f compose/traefik.docker-compose.yml -p traefik pull
if test $PROJECT != 'traefik'
    set_color yellow; echo "Trying to run your project compose..."
    set_color reset; docker-compose -f compose/$PROJECT.docker-compose.yml -p $PROJECT pull
end
docker image prune -f