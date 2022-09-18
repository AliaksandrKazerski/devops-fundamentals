#!/bin/bash
SSH_ALIAS=$1
SSH_USER=$2
SERVER_HOST_DIR=/home/user1/nestjs-rest-api
CLIENT_HOST_DIR=/home/user1/shop-react-redux-cloudfront

# destination folder names can be changed
SERVER_REMOTE_DIR=/var/app/store-app
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

check_remote_dir_exists $SERVER_REMOTE_DIR $SSH_ALIAS
check_remote_dir_exists $CLIENT_REMOTE_DIR $SSH_ALIAS

echo "---> Building and copying server files - START <---"
echo $SERVER_HOST_DIR
cd $SERVER_HOST_DIR && npm run build
sudo scp -Cr $SERVER_HOST_DIR/dist package.json tsconfig.build.json tsconfig.json $SSH_ALIAS:$SERVER_REMOTE_DIR
echo "---> Building and transfering server - COMPLETE <---"

echo "---> Building and transfering client files, cert and ngingx config - START <---"
echo $CLIENT_HOST_DIR
cd $CLIENT_HOST_DIR && npm run build && cd ../
sudo scp -Cr $CLIENT_HOST_DIR/dist/* $SSH_ALIAS:$CLIENT_REMOTE_DIR
echo "---> Building and transfering - COMPLETE <---"
