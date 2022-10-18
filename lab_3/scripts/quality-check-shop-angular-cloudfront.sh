#!/bin/bash - 
#===============================================================================
#
#          FILE: quality-check-shop-angular-cloudfront.sh
# 
#         USAGE: ./quality-check-shop-angular-cloudfront.sh 
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

path=~/devops-fundamentals1/devops-fundamentals/lab_3/data/shop-angular-cloudfront

npm --prefix ${path} run test

if ! [ $? -eq 0 ]
then
	exit 1
fi

npm --prefix ${path} run lint

if ! [ $? -eq 0 ]
then
	exit 1
fi

npm --prefix ${path} run e2e

if ! [ $? -eq 0 ]
then
	exit 1
fi

npm --prefix ${path} run commitlint

if ! [ $? -eq 0 ]
then
        exit 1
fi

npm --prefix ${path} run sonar-scaner

if ! [ $? -eq 0 ]
then
        exit 1
fi


npm --prefix ${path} audit

echo "Finish"
