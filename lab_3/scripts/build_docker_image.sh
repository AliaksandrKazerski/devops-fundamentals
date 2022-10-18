#!/bin/bash - 
#===============================================================================
#
#          FILE: build_docker_image.sh
# 
#         USAGE: ./build_docker_image.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Aliaksandr Kazerski (Admin), aliaksandr_kazerski@epam.com
#  ORGANIZATION: EPAM
#       CREATED: 08/14/2022 01:50:56 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

path=~/devops-fundamentals1/devops-fundamentals/lab_3/data/

cd ${path}
systemctl start docker

docker build -t nestjs-rest-api .
docker login
docker tag nestjs-rest-api:latest aliaksandrkazerski/nestjs-rest-api:latest
docker push aliaksandrkazerski/nestjs-rest-api:latest

echo "Finish"
