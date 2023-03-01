[![CI](https://github.com/dargmuesli/dargstack_rgen/actions/workflows/ci.yml/badge.svg)](https://github.com/dargmuesli/dargstack_rgen/actions/workflows/ci.yml)

# DargStack RGen

[DargStack](https://github.com/dargmuesli/dargstack)'s README.md generator.

Run the script using `node ./src/generator.js` or [`dargstack rgen`](https://github.com/dargmuesli/dargstack).

## Help

```
Options:
  --version   Show version number                                      [boolean]
  --path, -p  Path to a DargStack stack project                         [string]
  --help, -h  Show help                                                [boolean]
```

## Example

YAML input:

```yaml
# example.com
# https://example.com/
# example
# https://github.com/example/example/
---
configs:
  service_config:
  # The service's config.
    file: ./path/to/con.fig
secrets:
  service_password:
  # The service's login password
    file: ./path/to/password.secret
services:
  adminer:
  # You can access the service's frontend at [service.example.test](https://service.example.test/).
  # This information is required for login:
  #
  # |          |                     |
  # | -------- | ------------------- |
  # | Username | service_user     |
  # | Password | [service_password] |
  #
  # Values in square brackets are [Docker secrets](https://docs.docker.com/engine/swarm/secrets/).
    configs:
    - source: service_config
      target: /src/app/config/con.fig
    image: service:1.2.3
    secrets:
    - service_password
    volumes:
    - service_data:/mnt/data/
version: "3.8"
volumes:
  service_data:
  # The service's data.
    {}
```

Markdown output:

```markdown
# example_stack


The Docker stack configuration for [example.com](https://example.com/).

This project is deployed in accordance to the [DargStack template](https://github.com/dargmuesli/dargstack_template/) to make deployment a breeze. It is closely related to [example's source code](https://github.com/example/example/).

## Table of Contents


 1. [configs](#configs)

 2. [secrets](#secrets)

 3. [services](#services)

 4. [volumes](#volumes)


## configs


 - ### `service_config`

    The service's config.


## secrets


 - ### `service_password`

    The service's login password


## services


 - ### `adminer`

    You can access the service's frontend at [service.example.test](https://service.example.test/).
    This information is required for login:

    |          |                     |
    | -------- | ------------------- |
    | Username | service_user     |
    | Password | [service_password] |

    Values in square brackets are [Docker secrets](https://docs.docker.com/engine/swarm/secrets/).


## volumes


 - ### `service_data`

    The service's data.



```

Markdown rendered:

> # example_stack
> The Docker stack configuration for [example.com](https://example.com/).
>
>This project is deployed in accordance to the [DargStack template](https://github.com/dargmuesli/dargstack_template/) to make deployment a breeze. It is closely related to [example's source code](https://github.com/example/example/).
>
>## Table of Contents
>
>
>1. [configs](#configs)
>
>2. [secrets](#secrets)
>
>3. [services](#services)
>
>4. [volumes](#volumes)
>
>
>## configs
>
>
>- ### `service_config`
>
>    The service's config.
>
>
>## secrets
>
>
>- ### `service_password`
>
>    The service's login password
>
>
>## services
>
>
>- ### `adminer`
>
>    You can access the service's frontend at [service.example.test]>(https://service.example.test/).
>    This information is required for login:
>
>    |          |                     |
>    | -------- | ------------------- |
>    | Username | service_user     |
>    | Password | [service_password] |
>
>    Values in square brackets are [Docker secrets](https://docs.docker.>com/engine/swarm/secrets/).
>
>
>## volumes
>
>
>- ### `service_data`
>
>    The service's data.
>
>
