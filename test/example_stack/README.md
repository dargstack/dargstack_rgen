# example_stack


The Docker stack configuration for [example.de](https://example.de/).

This project is deployed in accordance to the [DargStack template](https://github.com/dargstack/dargstack_template/) to make deployment a breeze. It is closely related to [example's source code](https://github.com/dargmuesli/example/).

## Table of Contents


 1. [configs](#configs)
    
 2. [secrets](#secrets)
    
 3. [services](#services)
    
 4. [volumes](#volumes)
    

## configs


 - ### `another_rc`
    
    Another's configuration file.
    
 - ### `some_rc`
    
    Some's configuration file.
    

## secrets


 - ### `postgres_password`
    
    The database default user's password.
    
 - ### `postgres_user`
    
    The database default user's name.
    
 - ### `traefik_cf-dns-api-token` ![production](https://img.shields.io/badge/-production-informational.svg?style=flat-square)
    
    The DNS provider's DNS API token.
    
 - ### `traefik_cf-zone-api-token` ![production](https://img.shields.io/badge/-production-informational.svg?style=flat-square)
    
    The DNS provider's zone API token.
    

## services


 - ### `adminer`
    
    You can access the database's frontend at [adminer.example.test](https://adminer.example.test/).
    This information is required for login:
    
    |          |                     |
    | -------- | ------------------- |
    | System   | PostgreSQL          |
    | Server   | postgres            |
    | Username | [postgres_user]     |
    | Password | [postgres_password] |
    | Database | [postgres_db]       |
    
    Values in square brackets are [Docker secrets](https://docs.docker.com/engine/swarm/secrets/).
    
 - ### `postgres`
    
    You can access the database via `adminer`.
    
 - ### `postgres_backup` ![production](https://img.shields.io/badge/-production-informational.svg?style=flat-square)
    
    Backup service for `postgres`.
    
 - ### `traefik_certs-dumper` ![production](https://img.shields.io/badge/-production-informational.svg?style=flat-square)
    
    See [DargStack template: certificates](https://github.com/dargmuesli/dargstack_template/#certificates).
    

## volumes


 - ### `acme_data` ![production](https://img.shields.io/badge/-production-informational.svg?style=flat-square)
    
    The reverse proxy's certificate data.
    
 - ### `portainer_data` ![development](https://img.shields.io/badge/-development-informational.svg?style=flat-square)
    
    The container manager's data.
    
 - ### `postgres_data`
    
    The database's data.
    

