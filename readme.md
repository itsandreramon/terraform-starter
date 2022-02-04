[![Coverage](https://codecov.io/gh/itsandreramon/spring-starter-rds/branch/master/graph/badge.svg)](https://codecov.io/gh/itsandreramon/spring-starter)
[![Build](https://github.com/itsandreramon/spring-starter-rds/workflows/Build/badge.svg?branch=master)](https://github.com/itsandreramon/spring-starter/actions)

<img width="auto" height="100px" src="https://i.imgur.com/wGJQmTN.png">

# Stack

| What          | How                                                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------------------------------|
| Framework     | [Spring Boot 2](https://spring.io/)                                                                                        |
| GraphQL       | [Netflix DGS](https://github.com/Netflix/dgs-framework)                                                                    |
| Persistence   | [MySQL](https://www.mysql.com/)                                                                                        |
| Serialization | [kotlinx.serialization](https://github.com/Kotlin/kotlinx.serialization)                                                   |
| Testing       | [JUnit 5](https://github.com/junit-team/junit5) & [Testcontainers](https://github.com/testcontainers/testcontainers-java/) |

# Instructions

This project depends on a MySQL instance which should be run
using [Docker](https://www.docker.com/products/docker-desktop) Compose.

### Run the MySQL container

```
$ docker compose up
```

### Source the .env file

```
$ . ./.env
```

### Run the Spring Boot application

```
$ ./gradlew bootJar
$ java -jar build/libs/App.jar
```

### Access GraphiQL

```
http://localhost:8080/graphiql
```

# Deployment

This project uses Terraform to provision the MySQL database on AWS using RDS.

### Build the AMI and update the Terraform config

```
$ ./build-ami.sh
```

### Provision the database and EC2 instance

```
$ cd terraform
$ terraform apply
```
