#!/bin/bash
# shell 所在目录
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
echo $SHELL_FOLDER

# sdk 安装
sudo apt-get install build-essential ocaml ocamlbuild automake autoconf libtool wget python-is-python3 libssl-dev git cmake perl
git clone https://github.com/intel/linux-sgx.git
cd $SHELL_FOLDER/linux-sgx
make sdk
make sdk_install_pkg
ls
sdk_installer=`find $SHELL_FOLDER/linux-sgx/linux/installer/bin/ -name "sgx_linux_x64_sdk_*.bin"`;
cd /opt/intel
sudo  echo yes | $sdk_installer

# psw 安装
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
cd $SHELL_FOLDER/trex-keyholder
ls

# install rustup && cargo
apt-get update && apt-get install -y pkg-config clang libclang-dev diffutils gcc make m4 curl file cmake
curl -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y
source "$HOME/.cargo/env"
rustup show


# make trex-keyholder
source /opt/intel/sgxsdk/environment
SGX_MODE=HW make
cd $SHELL_FOLDER/trex-keyholder/bin
ls
# TODO:// 生成tee-account并拿到publickey 方便转账需要修改cli