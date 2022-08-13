#!/bin/bash - 
#===============================================================================
#
#          FILE: db.sh
# 
#         USAGE: ./db.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Aliaksandr Kazerski (Admin), aliaksandr_kazerski@epam.com
#  ORGANIZATION: EPAM
#       CREATED: 08/11/2022 09:52:55 PM
#      REVISION:  ---
#===============================================================================

if [ "$#" = 0 ]
then
	echo "Please provide argument check --help for info"
else
	path=~/devops-fundamentals/devops-fundamentals/lab_1/data


	check_is_users_exist ()
	{
		if [[ ! -f "${path}/users.db" ]]
		then
			read -p "users.db file doesn't exist. Create new one? yes/no": answer

			if [[ $answer = 'yes' ]]
			then
				touch ${path}/users.db
			else
				exit	
			fi
		fi
	}	# ----------  end of function check_is_users_exist  ----------

	add ()
	{
		
		while true; do
			read -p "Enter user name: " name

			if ! [[ "$name" =~ ^[A-Z]?[a-z] ]]
			then 
				echo "User name should contatin only latin characters"
			else
				break
			fi
		done
		 
		while true; do
			read -p "Enter user role: " role

			if ! [[ "$role" =~ ^[A-Z]?[a-z] ]]
			then 
				echo "User role should contatin only latin characters"
			else
				break
			fi
		done
 		echo "${name}, ${role}">> ${path}/users.db
	}	# ----------  end of function add  ----------


	backup ()
	{
		current_time=$(date "+%Y.%m.%d")
		cp ${path}/users.db ${path}/${current_time}-users.db.backup
	}	# ----------  end of function backup  ----------


	restore ()
	{
		if [ $( find ${path} -name '*.db.backup' ) ]  
		then
			latest=""
			files="../data/*"

			for file in $files; do
				[[ $file -nt $latest ]] && latest=$file
			done

			echo "$latest"
			cat $latest > ${path}/users.db
		else	
			echo "No backup file found"
		fi

	}	# ----------  end of function restore  ----------

	find ()
	{
		read -p "Enter user name: " name
		result=$(grep -Fw ${name} ${path}/users.db) 
		if [[ ${result} ]]
		then 
			echo ${result}
		else
			echo "User not found"
		fi	
	}	# ----------  end of function find  ----------

	list ()
	{
		readarray -t lines <  ${path}/users.db
		lenght=${#lines[@]}
	
		if [ "$#" =  "2" ] && [ "$2" = "--reverse" ]
		then
			for (( j=${lenght}-1 ; j >=  0 ; j-- )); do
				echo  "$((j + 1)). ${lines[${j}]}"
			done
		else	
			j=0
			for i in "${lines[@]}"; do
				((j++))	
				echo "${j}. ${i}"
			done
		fi
	}	# ----------  end of function list  ----------
	
	
help ()
{
	echo $' add - Adds a new line to the users.db: user, role \n backup - Creates a new file, named %date%-users.db.backup which is a copy of current users.db \n restore - Takes the last created backup file and replaces users.db with it. \n find - Prompts the user to type a username, then prints username and role if such exists in users.db. \n list - Prints the content of the users.db in the format: N. username, role Accepts an additional optional parameter --inverse which allows results in the opposite order – from bottom to top.'
}	# ----------  end of function help  ----------
	check_is_users_exist

	case $1  in
	"add")
	add;;

	"help")
	help;;

	"backup")
	backup;;

	"restore")
	restore;;

	"find")
	find;;

	"list")
	list $1 $2;;

	*)
	echo Wrong argument please check --help;;
	esac
fi

