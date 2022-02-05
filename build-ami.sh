#!/bin/bash
./gradlew clean bootJar
packer build build-ami.pkr.hcl
