# camunda-docker
Create a dockerised environment for Camunda running application and database in separate containers.

# Features
* Runs application and database in separate containers.
* Retains data if the containers are removed.
* Containers are connected without entering credential
* Use docker Vouume for data storing
* Use postgressql database and run as docker container


# Using Persistent Data
Using Docker volume, the databse container data is persisted on the host so if container is removed or re-created the data is not lost as It's outside the container. That can be extened to put the data on remote host, cloud provider and also can be encrypted

# Using Network
Application and databse containers communication is enabled using docker bridge network.This is secured way and only this camunda application can communicate to database container.


# Containers  [APP, DB]
```
CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS                                                                      NAMES
99d8b6f5b684   camunda/app              "/sbin/tini -- ./cam…"   11 seconds ago   Up 10 seconds   8000/tcp, 9404/tcp, 0.0.0.0:8081->8080/tcp, :::8081->8080/tcp              camunda
2456accafdb4   camunda/db               "docker-entrypoint.s…"   12 seconds ago   Up 11 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp                                  db
```


# Images [APP, DB]
```
REPOSITORY                     TAG       IMAGE ID       CREATED          SIZE
camunda/app                    latest    71b15e4b4be7   12 minutes ago   259MB
camunda/db                     latest    1f8fce7686db   12 minutes ago   315MB
```



# Database Container Running
```
PostgreSQL init process complete; ready for start up.

2021-07-14 12:08:46.970 UTC [1] LOG:  starting PostgreSQL 13.3 (Debian 13.3-1.pgdg100+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 8.3.0-6) 8.3.0, 64-bit
2021-07-14 12:08:46.970 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2021-07-14 12:08:46.970 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2021-07-14 12:08:46.971 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2021-07-14 12:08:46.974 UTC [75] LOG:  database system was shut down at 2021-07-14 12:08:46 UTC
2021-07-14 12:08:46.979 UTC [1] LOG:  database system is ready to accept connections
```

# Camunda Application Container Running
```
Configure database
wait-for-it.sh: waiting 30 seconds for db:5432
wait-for-it.sh: db:5432 is available after 1 seconds
...
14-Jul-2021 12:09:02.806 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service [Catalina]
14-Jul-2021 12:09:02.807 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet engine: [Apache Tomcat/9.0.43]
14-Jul-2021 12:09:02.939 INFO [main] org.apache.catalina.startup.HostConfig.deployDirectory Deploying web application directory [/camunda/webapps/ROOT]
14-Jul-2021 12:23:44.747 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.
14-Jul-2021 12:23:49.175 WARNING [main] org.apache.catalina.util.SessionIdGeneratorBase.createSecureRandom Creation of SecureRandom instance for session ID generation using [SHA1PRNG] took [105] milliseconds.
14-Jul-2021 12:23:59.714 INFO [main] org.apache.catalina.startup.HostConfig.deployDirectory Deployment of web application directory [/camunda/webapps/ROOT] has finished in [896,744] ms
14-Jul-2021 12:23:59.936 INFO [main] org.apache.catalina.startup.HostConfig.deployDirectory Deploying web application directory [/camunda/webapps/camunda]
```

# Build
```
docker build --target DB -t camunda/db \
--build-arg  DBUSER=$CAMUNDA_USER  \
--build-arg  DBPWD=$CAMUNDA_PASSWORD  \
--build-arg  DBNAME=$CAMUNDA_DB .
```

```
docker build --target APP -t camunda/app \
--build-arg  DBUSER=$CAMUNDA_USER  \
--build-arg DBPWD=$CAMUNDA_PASSWORD  \
--build-arg  DBNAME=$CAMUNDA_DB  . 
```

# Run
```
docker run --name db \
--net camunda-db-bridge \
-d -p 5432:5432 \
-v $CAMUNDA_DATA:/var/lib/postgresql/data \
camunda/db
```

```
docker run -d --name camunda \
--net camunda-db-bridge \
-p 8081:8080 \
camunda/app
```

# Build and Deploy Docker Container
We have created a `Dockerfile` and `build-deploy.sh` bash script for building and deploy  camunda as docker containers. And for `cleanup.sh` for enviroment cleanup.



# Code Review 
https://github.com/UKHomeOffice/cop-secrets

• How the project has been done
• The structure in place
• Any improvements that you would suggest? What would you prioritise or refactor?

## Code Review Comments:

The structue could be improves and  payhon code can be refactor using object oriented

It's seems not very good structured and payhon code can be refactor using object oriented,
It's `not readable`, and would be `difficult to maintain` and has `less comments` 

* some improvements:*

In `secret.py` This big function `processAWSSecret` could be refatored in specific functions
could be
* listAWSSecret
* updateAWSSecret
* removeAWSSecret

This class `repo_secrets.py` has only one function could be move into 'secrets.py'
listRepoSecret

methon name should be with `under_scores` instead of `camelCase` as python best practice

The python code can be refactor as `Object Oriented` aswell


