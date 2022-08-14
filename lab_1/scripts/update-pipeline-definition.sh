#!/bin/bash - 
#===============================================================================
#
#          FILE: update-pipeline-definition.sh
# 
#         USAGE: ./update-pipeline-definition.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Aliaksandr Kazerski (Admin), aliaksandr_kazerski@epam.com
#  ORGANIZATION: EPAM
#       CREATED: 08/14/2022 02:32:54 PM
#      REVISION:  ---
#===============================================================================

path=""
branch="main"
owner=""
changes=false
config=""
data_path=~/devops-fundamentals1/devops-fundamentals/lab_1/data
date=$(date +"%d-%m-%y")

while true; do
	case "$1" in
 	--branch ) branch=$2; shift ;;
	--owner ) owner=$2; shift ;;
	--configuration ) config=$2; shift ;;
	--poll-for-source-changes ) changes=true; shift ;;
	*.json ) path=$1; shift;;
	-- ) shift; break ;;
	* ) break ;;
	esac
done

while true; do
	case "$2" in
	--branch ) branch=$3; shift ;;
	--owner ) owner=$3; shift ;;
	--configuration ) config=$4; shift ;;
	--poll-for-source-changes ) changes=true; shift ;;
 	*.json ) path=$2; shift;;
	-- ) shift; break ;;
	* ) break ;;
	esac
done

while true; do
	case "$3" in
	--branch ) branch=$4; shift ;;
	--owner ) owner=$4; shift ;;
	--configuration ) config=$4; shift ;;
	--poll-for-source-changes ) changes=true; shift ;;
	*.json) path=$3; shift;;
	-- ) shift; break ;;
	* ) break ;;
	esac
done

while true; do
	case "$4" in
	--branch ) branch=$5; shift ;;
	--owner ) owner=$5; shift ;;
	--configuration ) config=$5; shift ;;
	--poll-for-source-changes ) changes=true; shift ;;
	*.json) path=$4; shift;;
 	-- ) shift; break ;;
 	* ) break ;;
	esac
done
echo $@
echo $branch $owner $config $changes $path

~/../../sbin/ldconfig -p | grep jq
if ! [ $?  -eq 0 ] 
then
	echo Error: Please install jq lib in order to perform this script https://stedolan.github.io/jq/download/
	exit 125
fi

if [[ $path = "" ]]
then
	echo Error: Please provide path to pipeline file as first argument
	exit 125
fi


if [[ $owner = "" ]] || [[ $config = "" ]]
then
	jq 'del(.metadata) | .pipeline.version +=1' ${path} > ${data_path}/pipeline-${date}.json

	echo Error: Please provide --owner and --configuration params
	exit 125
fi

jq --arg branch "$branch" --arg changes "$changes" --arg owner "$owner" --arg config "$config" 'del(.metadata) | .pipeline.version +=1 | .pipeline.stages[0].actions[0].configuration.Branch = $branch  | .pipeline.stages[0].actions[0].configuration.Owner = $owner | .pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $changes | .pipeline.stages[].actions[].configuration.EnvironmentVariables = $config' ${path} > ${data_path}/pipeline-${date}.json


