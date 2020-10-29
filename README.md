# Xorro-Q in Docker

## Description

This project is for Ubuntu users who wants to setup the development environment using docker.

## 1. Install Docker / Docker Compose

* https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce
* https://docs.docker.com/compose/install/

## 2. Extra setup for Docker
* Add the current user to docker group to run docker/docker-compose without sudo

    ```
    sudo usermod -aG docker $USER
    ```

* Add USER_ID and GROUP_ID to .env

    ```
    printf "USER_ID=1000\nGROUP_ID=1000\n" >> .env
    ```

    USER_ID and GROUP_ID is used in docker-compose.yml to run containers as the host user
    to avoid volumed project folders edited as root.

* Modify hosts file

    ```
    127.0.0.1 api.xorroq
    127.0.0.1 facilitator.xorroq
    127.0.0.1 participant.xorroq
    127.0.0.1 website.xorroq
    127.0.0.1 account.xorroq
    ```

    Add lines above to support domains used in docker also works outside

* Copy ssh file (id_rsa) which has the access to Xorro-Q repositories
    ```
    cp ~/.ssh/id_rsa id_rsa
    ```
    This is to clone Xorro-Q repositories within Docker.

## 3. Setup

Run the install script below which does:
* Clone projects (website, account, api, participant, and facilitator)
* Build docker images and the database volume
* Setup xorro and xorroq databases and load fixtures

```
./install.sh
```

## 4. Run

```
docker-compose up
```

## Usage

* QF Login

    ```
    Master:  master/password
    Manager: manager/password
    Free:    free_facilitator/password
    ```

* DB Login

    ```
    Root user: root/devRoot
    App user:  devUser/devAdmin
    ```

* Urls

    ```
    Api:         api.xorroq:4000
    Facilitator: facilitator.xorroq:4100
    Participant: participant.xorroq:4200
    Website:     website.xorroq:3100
    Account:     account.xorroq:3300
    Database:    localhost:3400
    PhpMyAdmin:  localhost:3500
    Redis:       localhost:3600
    ```

## Extra

* Reset everything

    Run a reset script below will:
    * Delete tmp folders and uploaded files from each projects
    * Delete the database volume - All data will be lost

    ```
    ./reset.sh
    ```

* Run rake task or console

    * Run migration

        ```
        docker-compose run --rm api.xorroq bin/rake db:migrate
        ```

    * Run console

        ```
        docker-compose run --rm api.xorroq bin/rails console
        ```

* Run containers as background job

    ```
    docker-compose up -d
    ```

* Show logs

    * Docker logs for a single container

        ```
        docker-compose logs -f db
        ```

    * Rails logs
        ```
        tail -f api/log/development.log
        ```

* Install New Gems

    * Edit Dockeflile
    * Update Gemfile.lock

        ```
        docker-compose run --rm api.xorroq bundle install
        ```
