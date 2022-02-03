#!/bin/bash
./gradlew clean bootJar
packer build -force main.pkr.hcl
