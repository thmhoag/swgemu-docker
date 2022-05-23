# swgemu-docker
```
A Docker image and docker-compose file setup for running an SWGEmu dev environment in Docker.
```

## Overview
This repo contains a Dockerfile, docker-compose.yml, and other supporting files to run [SWGEmu](https://www.swgemu.com/) in a Docker container. It is loosely based off of the work on [ZonamaDev VM](https://github.com/Zonama/ZonamaDev).

The [Core3](https://github.com/swgemu/Core3) source is included as a submodule for convenience but this repo is mainly intended to be an example of how to build and deploy [Core3](https://github.com/swgemu/Core3) locally with MySQL alongside in order to facilicate both a lighter development environment than the [ZonamaDev VM](https://github.com/Zonama/ZonamaDev) as well as an eventual path to creating production images that could be used to host SWGEmu servers. 

### Features

* A Dockerfile to build an image that will run the SWGEmu Core3 server
* A docker-compose file for an easy start of the Core3 server and MySQL
* Pre-created admin account
* Additional items/professions enabled on the BlueFrog terminals for testing
* Graceful Shutdown

## Getting Started

### Prerequisites

* Install Docker (CE) and Docker Compose - https://docs.docker.com/v17.09/engine/installation/
* Game `tre` files from an SWGEmu install

### Adding `tre` Files

In order for the server to run successfully, the game `tre` files will need to be added to the `./tre` directory of this repository. This directory will be mounted as a volume inside the container at runtime to provide the files to the server.

A list of the required files can be found in the [./Core3/MMOCoreORB/bin/conf/config.lua](Core3/MMOCoreORB/bin/conf/config.lua) file.

> **NOTE**: These files are kept separate as they originate from the client. They should not be included in any images, published to any public Docker image repository, or pushed to any remote git repositories.

### Building the Image

The image can be built using `docker-compose` or manually using `Docker`.

> **NOTE**: Before building, ensure you have updated both submodules (Core3 and subsequently engine3). <br>
> ie. ```git submodule update --init --recursive```

docker-compose:
```$bash
$ docker-compose build
```

Manually using Docker:
```$bash
$ docker build . -t swgemu:dev
```

The image build will likely take 15-30 minutes depending on the specs of the machine doing the building.

### Starting the Server and Database

The docker-compose file can be used to run a fresh server out of the box:

```$bash
$ docker-compose up -d
```

On the first run, this will start a MySQL container and create the SWGEmu database from scratch using the [swgemu.sql](Core3/MMOCoreORB/sql/swgemu.sql) script to create the schema. Once the container is up and running it will automatically build the SWGEmu Docker image and start it with the appropriate parameters.

On start, the server will take some time to create the navmesh data required at runtime. This data is saved in the navemesh volume for future runs.

### Logging into the Server

Using the SWGEmu Launchpad, make sure that the server selected is `local` prior to launching the game. Whem prompted for credentials, use the following:

```
user: admin
pass: admin
```

This user account is setup by the [admin_account.sql](sql/02-admin_account.sql) and will have full admin privileges. Additional user accounts can be setup simply by logging in with a new user/pass combination. These accounts will not have full admin rights.


## Server Management

### Connecting to the MySQL Database

You can connect to the MySQL database using `localhost:3306` using any MySQL compatible tool. The root password can be found in the [docker-compose.yml](docker-compose.yml)

### In-game Commands

All admin commands will be available to the default admin/admin account. You can find a full list of SWGAdmin commands here: [CommandsV2](https://drive.google.com/file/d/0BwjBDOFpOsM5OEVuMDh1U3BDYnM/view)

