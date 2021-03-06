[![Coverage](https://codecov.io/gh/itsandreramon/terraform-starter/branch/master/graph/badge.svg)](https://codecov.io/gh/itsandreramon/terraform-starter)
[![Build](https://github.com/itsandreramon/terraform-starter/workflows/Build/badge.svg?branch=master)](https://github.com/itsandreramon/terraform-starter/actions)

<img width="auto" height="100px" src="https://i.imgur.com/wGJQmTN.png">

# Stack

| What          | How                                                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------------------------------|
| Framework     | [Spring Boot 2](https://spring.io/)                                                                                        |
| GraphQL       | [Netflix DGS](https://github.com/Netflix/dgs-framework)                                                                    |
| Database      | [MySQL](https://www.mysql.com/)                                                                                            |
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

#### Structure

- EC2 instance in public subnet
- RDS instance in private subnet

#### Create .env file

```
DB_HOST=localhost
DB_PORT=3306

TF_VAR_region=us-east-2
TF_VAR_name=demo
```

This project uses [Packer](https://www.packer.io/) & [Terraform](https://www.terraform.io/) to provision both the MySQL
database as well as the Spring Boot application on AWS. To demonstrate a more realistic environment, we are deploying
into a custom
VPC and allow access to RDS only from the EC2 instance. Ensure that AWS and Terraform are configured correctly by
setting
the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. Ensure that the IAM user has the privileges
needed to run this project:

- AmazonRDSFullAccess
- AmazonEC2FullAccess
- AmazonS3FullAccess (Remote State)
- AmazonDynamoDBFullAccess (Remote State)

#### Setup Terraform remote state using AWS S3

To be able to use [outputs](https://www.terraform.io/language/values/outputs) of various modules across Terraform,
a [remote backend](https://www.terraform.io/language/settings/backends/s3) is used to store the state in S3.

```
$ terraform -chdir=terraform/global/s3 init
$ terraform -chdir=terraform/global/s3 apply
```

#### Build the AMI and deploy to AWS

Before deploying with Terraform, make sure that you have a valid Key Pair by creating and downloading it via the EC2
dashboard. Place the .pem file inside `~/.ec2/` and run `chmod 600 ~/.ec2/` on it. Verify that the file has the correct
name inside your Terraform configuration.

```
$ ./build-ami.sh
$ ./deploy-app.sh
```
