#!/bin/bash
# Receive external parameters
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

# sdk install
sudo apt-get install build-essential ocaml ocamlbuild automake autoconf libtool wget python-is-python3 libssl-dev git cmake perl
git clone https://github.com/intel/linux-sgx.git
cd $SHELL_FOLDER/linux-sgx
make sdk
make sdk_install_pkg
ls
sdk_installer=`find $SHELL_FOLDER/linux-sgx/linux/installer/bin/ -name "sgx_linux_x64_sdk_*.bin"`;
cd /opt/intel
sudo  echo yes | $sdk_installer

# psw install
cd $SHELL_FOLDER/linux-sgx
sudo apt-get install libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake reprepro unzip pkgconf libboost-dev libboost-system-dev protobuf-c-compiler libprotobuf-c-dev lsb-release
make psw
make deb_psw_pkg

# make deb local repo && add env to /etc/apt/sources.list
make deb_local_repo
CODE_NAME=`lsb_release -c --short`
sudo echo "deb [trusted=yes arch=amd64] file:$SHELL_FOLDER/linux-sgx/linux/installer/deb/sgx_debian_local_repo $CODE_NAME main">>/etc/apt/sources.list

# For PSW install the selected modules based on the needs.
sudo apt update
sudo apt-get install libssl-dev libcurl4-openssl-dev libprotobuf-dev
sudo apt-get install libsgx-launch libsgx-urts
sudo apt-get install libsgx-epid libsgx-urts
sudo apt-get install libsgx-quote-ex libsgx-urts
sudo apt-get install libsgx-dcap-ql

# install psw
cd $SHELL_FOLDER/linux-sgx
make psw_install_pkg
psw_installer=`find $SHELL_FOLDER/linux-sgx/linux/installer/bin/ -name "sgx_linux_x64_psw_*.bin"`;
sudo $psw_installer

# git clone trex-keyholder
cd $SHELL_FOLDER
git clone https://github.com/NexTokenTech/trex-keyholder.git
git fetch
git checkout deployment
git status
cd $SHELL_FOLDER/trex-keyholder
ls

# install rustup && cargo
apt-get update && apt-get install -y pkg-config clang libclang-dev diffutils gcc make m4 curl file cmake
curl -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
source "$HOME/.cargo/env"
rustup show
rustup default nightly

# make trex-keyholder
source /opt/intel/sgxsdk/environment
SGX_MODE=HW make
cd $SHELL_FOLDER/trex-keyholder/bin

# generate tee account in enclave
./cli -c $SHELL_FOLDER/trex-keyholder/service/src/config.yml -s $SHELL_FOLDER/trex-keyholder/service/src/seed.yml signing-pub-key
ls

# use subxt send funds to tee-account from wellknown account Alice.
cd $SHELL_FOLDER
ls
git clone https://github.com/NexTokenTech/trex-account-funds.git
cd $SHELL_FOLDER/trex-account-funds
ls
cargo install subxt-cli
subxt metadata -f bytes > metadata.scale
cargo build --release
./target/release/trex-account-funds -n $NODE_HOST -t $SHELL_FOLDER/trex-keyholder/bin/tee_account_id.txt

# start key holder service
cd $SHELL_FOLDER/trex-keyholder/bin
./trex-keyholder -c $SHELL_FOLDER/trex-keyholder/service/src/config.yml
