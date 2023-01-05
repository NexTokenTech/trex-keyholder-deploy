{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;\f1\fnil\fcharset134 PingFangSC-Regular;\f2\fnil\fcharset0 Menlo-Bold;
}
{\colortbl;\red255\green255\blue255;\red46\green174\blue187;\red0\green0\blue0;\red47\green180\blue29;
\red64\green11\blue217;\red159\green160\blue28;\red180\green36\blue25;\red200\green20\blue201;}
{\*\expandedcolortbl;;\cssrgb\c20199\c73241\c78251;\csgray\c0;\cssrgb\c20241\c73898\c14950;
\cssrgb\c32309\c18666\c88229;\cssrgb\c68469\c68012\c14211;\cssrgb\c76411\c21697\c12527;\cssrgb\c83397\c23074\c82666;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\fs22 \cf2 \CocoaLigature0 #!/bin/bash\cf3 \
\cf2 # shell 
\f1 \'cb\'f9\'d4\'da\'c4\'bf\'c2\'bc
\f0 \cf3 \
SHELL_FOLDER\cf4 =$(
\f2\b \cf5 cd
\f0\b0 \cf3  
\f2\b \cf6 "$(dirname "\cf7 $0\cf6 ")"
\f0\b0 \cf4 ;\cf3 pwd\cf4 )\cf3 \

\f2\b \cf5 echo
\f0\b0 \cf3  
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 \
\
\cf2 # sdk 
\f1 \'b0\'b2\'d7\'b0
\f0 \cf3 \
sudo apt-get 
\f2\b \cf5 install
\f0\b0 \cf3  build-essential ocaml ocamlbuild automake autoconf libtool wget python-is-python3 libssl-dev git cmake perl\
git clone https\cf4 :\cf3 //github.com/intel/linux-sgx.git\

\f2\b \cf5 cd
\f0\b0 \cf3  
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 /linux-sgx\

\f2\b \cf5 make
\f0\b0 \cf3  sdk\

\f2\b \cf5 make
\f0\b0 \cf3  sdk_install_pkg\
ls\
sdk_installer\cf4 =`\cf3 find 
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 /linux-sgx/linux/installer/bin/ -name 
\f2\b \cf6 "sgx_linux_x64_sdk_*.bin"
\f0\b0 \cf4 `;\cf3 \

\f2\b \cf5 cd
\f0\b0 \cf3  /opt/intel\
sudo  
\f2\b \cf5 echo
\f0\b0 \cf3  yes \cf4 |\cf3  
\f2\b \cf7 $sdk_installer
\f0\b0 \cf3 \
\
\cf2 # psw 
\f1 \'b0\'b2\'d7\'b0
\f0 \cf3 \

\f2\b \cf5 cd
\f0\b0 \cf3  
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 /linux-sgx\
sudo apt-get 
\f2\b \cf5 install
\f0\b0 \cf3  libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake reprepro unzip pkgconf libboost-dev libboost-system-dev protobuf-c-compiler libprotobuf-c-dev lsb-release\

\f2\b \cf5 make
\f0\b0 \cf3  psw\

\f2\b \cf5 make
\f0\b0 \cf3  deb_psw_pkg\
\
\cf2 # make deb local repo && add env to /etc/apt/sources.list\cf3 \

\f2\b \cf5 make
\f0\b0 \cf3  deb_local_repo\
CODE_NAME\cf4 =`\cf3 lsb_release
\f2\b \cf8  -c --short
\f0\b0 \cf4 `\cf3 \
sudo 
\f2\b \cf5 echo
\f0\b0 \cf3  
\f2\b \cf6 "deb [trusted=yes arch=amd64] file:$SHELL_FOLDER/linux-sgx/linux/installer/deb/sgx_debian_local_repo $CODE_NAME main"
\f0\b0 \cf4 >>\cf3 /etc/apt/sources.list\
\
\cf2 # For PSW install the selected modules based on the needs.\cf3 \
sudo apt update\
sudo apt-get 
\f2\b \cf5 install
\f0\b0 \cf3  libssl-dev libcurl4-openssl-dev libprotobuf-dev\
sudo apt-get 
\f2\b \cf5 install
\f0\b0 \cf3  libsgx-launch libsgx-urts\
sudo apt-get 
\f2\b \cf5 install
\f0\b0 \cf3  libsgx-epid libsgx-urts\
sudo apt-get 
\f2\b \cf5 install
\f0\b0 \cf3  libsgx-quote-ex libsgx-urts\
sudo apt-get 
\f2\b \cf5 install
\f0\b0 \cf3  libsgx-dcap-ql\
\
\cf2 # install psw\cf3 \

\f2\b \cf5 cd
\f0\b0 \cf3  
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 /linux-sgx\

\f2\b \cf5 make
\f0\b0 \cf3  psw_install_pkg\
psw_installer\cf4 =`\cf3 find 
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 /linux-sgx/linux/installer/bin/ -name 
\f2\b \cf6 "sgx_linux_x64_psw_*.bin"
\f0\b0 \cf4 `;\cf3 \
sudo 
\f2\b \cf7 $psw_installer
\f0\b0 \cf3 \
\
\cf2 # git clone trex-keyholder\cf3 \

\f2\b \cf5 cd
\f0\b0 \cf3  
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 \
git clone https\cf4 :\cf3 //github.com/NexTokenTech/trex-keyholder.git\

\f2\b \cf5 cd
\f0\b0 \cf3  
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 /trex-keyholder\
ls\
\
\cf2 # install rustup && cargo\cf3 \
apt-get update \cf4 &&\cf3  apt-get 
\f2\b \cf5 install\cf8  -y
\f0\b0 \cf3  pkg-config clang libclang-dev diffutils gcc 
\f2\b \cf5 make
\f0\b0 \cf3  m4 curl file cmake\
curl -sSf https\cf4 :\cf3 //sh.rustup.rs \cf4 |\cf3  sh
\f2\b \cf8  -s
\f0\b0 \cf3  --
\f2\b \cf8  --default-toolchain
\f0\b0 \cf3  none
\f2\b \cf8  -y
\f0\b0 \cf3 \
source 
\f2\b \cf6 "$HOME/.cargo/env"
\f0\b0 \cf3 \
rustup show\
\
\cf2 # make trex-keyholder\cf3 \
source /opt/intel/sgxsdk/environment\
SGX_MODE\cf4 =\cf3 HW 
\f2\b \cf5 make
\f0\b0 \cf3 \

\f2\b \cf5 cd
\f0\b0 \cf3  
\f2\b \cf7 $SHELL_FOLDER
\f0\b0 \cf3 /trex-keyholder/bin\
ls\
\cf2 # TODO:// 
\f1 \'c9\'fa\'b3\'c9
\f0 tee-account
\f1 \'b2\'a2\'c4\'c3\'b5\'bd
\f0 publickey 
\f1 \'b7\'bd\'b1\'e3\'d7\'aa\'d5\'cb\'d0\'e8\'d2\'aa\'d0\'de\'b8\'c4
\f0 cli}