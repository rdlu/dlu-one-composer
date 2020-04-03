# DluOne Data Composer for Data Engineering and Data Science

This is a repo with scripts for Data Science and Engineering quick start with docker

I'm using personally for my daily work and side projects

## Conventions for files, commands and services

 - Using Fish Shell Scripts instead Bash
 - Multiple compose files in compose directory with format `PROJECT.docker-compose.yml`
 - Scripts to run these `PROJECT`s
 - Any external mounted directories will be mounted on `~/DataComposer/SERVICE`
 - Try to not repeat service names
 - Never expose unnecesary ports (this is why I use Traefik Proxy here)

## Generating passwords for BasicAuth

`htpasswd -nbB myusername MY_PASSWORD`