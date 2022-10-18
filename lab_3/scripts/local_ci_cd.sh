#!/bin/bash
SSH_ALIAS=$1
SSH_USER=$2

CLIENT_HOST_DIR=~/devops-fundamentals1/devops-fundamentals/lab_3/data/shop-angular-cloudfront

# destination folder names can be changed

CLIENT_REMOTE_DIR=/var/www/store-server

check_remote_dir_exists() {
  echo "Check if remote directories exist"

  if ssh $2 "[ ! -d $1 ]"; then
    echo "Creating: $1"
	ssh -t $2 "sudo bash -c 'mkdir -p $1 && chown -R $SSH_USER: $1'"
  else
    echo "Clearing: $1"
    ssh $2 "sudo -S rm -r $1/*"
  fi
}

check_remote_dir_exists $CLIENT_REMOTE_DIR $SSH_ALIAS

echo "---> Run quality checks - START <---"
cd ~/devops-fundamentals1/devops-fundamentals/lab_3/scripts
bash quality-check-shop-angular-cloudfront.sh
echo "---> Run quality checks - COMPLETE <---"

echo "---> Building and transfering client files, cert and ngingx config - START <---"
echo $CLIENT_HOST_DIR
cd $CLIENT_HOST_DIR && npm run build && cd ../
sudo scp -Cr $CLIENT_HOST_DIR/dist/* $SSH_ALIAS:$CLIENT_REMOTE_DIR
echo "---> Building and transfering - COMPLETE <---"
