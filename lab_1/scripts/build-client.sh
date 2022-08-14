#!/bin/bash - 
#===============================================================================
#
#          FILE: build-client.sh
# 
#         USAGE: ./build-client.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Aliaksandr Kazerski (Admin), aliaksandr_kazerski@epam.com
#  ORGANIZATION: EPAM
#       CREATED: 08/14/2022 12:52:19 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

path=~/devops-fundamentals1/devops-fundamentals/lab_1/scripts/shop-angular-cloudfront

if [[ -f ${path} ]]
then
	rm -fr ${path}
fi

git clone https://github.com/EPAM-JS-Competency-center/shop-angular-cloudfront.git 

npm install --prefix ${path}

export ENV_CONFIGURATION="production"
npm run build --configuration

if [[ -f ${path}/dist/client-app.zip ]]
then
	rm -f ${path}/dist/client-app.zip
fi

mkdir ${path}/dist	
zip -r ${path}/dist/client-app.zip ${path}
 
echo "Finish"

