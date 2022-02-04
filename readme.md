[![Coverage](https://codecov.io/gh/itsandreramon/spring-starter-rds/branch/master/graph/badge.svg)](https://codecov.io/gh/itsandreramon/spring-starter)
[![Build](https://github.com/itsandreramon/spring-starter-rds/workflows/Build/badge.svg?branch=master)](https://github.com/itsandreramon/spring-starter/actions)

<img width="auto" height="100px" src="https://i.imgur.com/wGJQmTN.png">

# Stack

| What          | How                                                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------------------------------|
| Framework     | [Spring Boot 2](https://spring.io/)                                                                                        |
| GraphQL       | [Netflix DGS](https://github.com/Netflix/dgs-framework)                                                                    |
| Persistence   | [MySQL](https://www.mysql.com/)                                                                                            |
| Serialization | [kotlinx.serialization](https://github.com/Kotlin/kotlinx.serialization)                                                   |
| Testing       | [JUnit 5](https://github.com/junit-team/junit5) & [Testcontainers](https://github.com/testcontainers/testcontainers-java/) |

# Instructions

This project depends on a MySQL instance which should be run
using [Docker](https://www.docker.com/products/docker-desktop) Compose.

#### Run the MySQL container

```
$ docker compose up
```

#### Source the .env file

```
$ . ./.env
```

#### Run the Spring Boot application

```
$ ./gradlew bootJar
$ java -jar build/libs/App.jar
```

#### Access GraphiQL

```
http://localhost:8080/graphiql
```

# Deployment
This project uses Packer & Terraform to provision both the MySQL database as well as the Spring Boot application on AWS. Ensure that AWS and Terraform are configured correctly by setting the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. Ensure that the IAM user has the privileges needed to run this project:

  - AmazonRDSFullAccess
  - AmazonEC2FullAccess
  - AmazonS3FullAccess (Remote State)
  - AmazonDynamoDBFullAccess (Remote State)

#### Build the AMI and update the Terraform config

```
$ ./build-ami.sh

==> spring-ubuntu.amazon-ebs.ubuntu: Creating AMI spring-ubuntu from instance
    spring-ubuntu.amazon-ebs.ubuntu: AMI: ami-abc123
```

#### Provision the database and EC2 instance

```
$ terraform -chdir=terraform apply -var="ami=abc123"
```
