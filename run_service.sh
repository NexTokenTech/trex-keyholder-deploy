#!/bin/bash
for parm in "$@"
do
   key=`echo ${parm%%=*}`
   value=`echo ${parm#*=}`
   if [ $key == "--node_host" ];then
      export NODE_HOST=$value
   fi
done
echo $NODE_HOST

# The directory where the shell is located
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
echo $SHELL_FOLDER

cd $SHELL_FOLDER/trex-account-funds
ls
subxt metadata -f bytes > metadata.scale
cargo build --release
./target/release/trex-account-funds -n $NODE_HOST -t $SHELL_FOLDER/trex-keyholder/bin/tee_account_id.txt

# start key holder service
cd $SHELL_FOLDER/trex-keyholder/bin
./trex-keyholder -c $SHELL_FOLDER/config.yml