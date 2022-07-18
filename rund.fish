#! /usr/bin/fish

set -q argv[1]; or set argv[1] traefik
set PROJECT $argv[1]
set -x UID (id -u (whoami))
set -x GID (id -g (whoami))
set -x PWD (pwd)

if test ! -e ./.passwd
    set_color yellow; echo "Creating a password file for authentication on some services..."
    set_color green; echo Setting password for (whoami):
    htpasswd -cB .passwd (whoami)
end

sudo systemctl start docker
set_color cyan; echo "Making sure traefik is running..."
set_color grey; docker compose -f compose/traefik.docker-compose.yml -p traefik --env-file ./.env up --remove-orphans -d
if test $PROJECT != 'traefik'
    set_color yellow; echo "Trying to run your project compose..."
    set_color reset; docker-compose -f compose/$PROJECT.docker-compose.yml -p $PROJECT --env-file ./.env up --remove-orphans -d
end
