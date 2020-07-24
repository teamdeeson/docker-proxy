# docker4drupal Traefik Proxy

## Purpose

Provides a Traefik proxy that is independent of docker4drupal. This allows a web developer to have several projects running at the same time.

## Installation

1. Clone this repository locally to your machine.
2. Navigate into the cloned respository and run `make start`
3. To stop run `make stop`
4. To see the Traefik logs run `make view-logs`

When Traefik is running you can access its dashboard at [https://monitor.localhost](https://monitor.localhost)

## Configuring your d4d project

### .env

Remove 

    COMPOSE_PROJECT_NAME

Add the following:

    PROJECT_NAME=mylovelproject
    PROJECT_BASE_URL=mylovelproject.localhost

Replace `mylovelproject` with your project

### docker-compose.yml
In the `docker-compose.yml` file you must add `container_name` parameters to each of you active services.
Use the pattern

    container_name: "${PROJECT_NAME}_mylovelyservice"

Replace `mylovelyservice` with the name of the service you are adding the parameter to.
So, the value of the `container_name` parameter of the `mariadb` service would be:

    container_name: "${PROJECT_NAME}_mariadb"

To each service add the following:

    networks:
      - proxy

Remove the `traefik.backend` labels from all services.
Remove or comment out the service definition for `traefik`.

Add the following to the bottom of the file:

    networks:
      proxy:
        external: true

Add the following parameter to the `php` service:

    D4D_HOSTNAME: ${PROJECT_BASE_URL}


### Drupal settings.php

Add the following mapping to the `$base_domains` array:

    getenv('D4D_HOSTNAME') => 'local'

### Drush sites.aliases.drushrc.php

Alter the `uri` key of the `docker` alias:

    'uri' => getenv('D4D_HOSTNAME')


