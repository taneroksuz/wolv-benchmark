#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "example usage: ./riscv.sh wolv-z0"
  exit 1
fi

cd $1

export BASEDIR=$(pwd)
export $(grep -v '^#' $BASEDIR/.env | xargs)

GCC_VERSION="basepoints/gcc-15"
NEWLIB_VERSION="newlib-4.4.0"
BINTUILS_VERSION="binutils-2_42"

if [ -d "$RISCV" ]; then
  sudo rm -rf $RISCV
fi

sudo mkdir -p $RISCV
sudo chown -R $USER:$USER $RISCV

sudo apt-get -y install autoconf automake autotools-dev curl \
                        python3 python3-pip libmpc-dev libmpfr-dev \
                        libgmp-dev gawk build-essential bison flex \
                        texinfo gperf libtool patchutils bc \
                        zlib1g-dev libexpat-dev ninja-build git \
                        cmake libglib2.0-dev libslirp-dev

if [ -d "$BASEDIR/gcc" ]; then
  rm -rf $BASEDIR/gcc
fi
if [ -d "$BASEDIR/binutils" ]; then
  rm -rf $BASEDIR/binutils
fi
if [ -d "$BASEDIR/newlib" ]; then
  rm -rf $BASEDIR/newlib
fi
if [ -d "$BASEDIR/combined" ]; then
  rm -rf $BASEDIR/combined
fi

git clone --branch $GCC_VERSION --depth=1 https://github.com/gcc-mirror/gcc.git $BASEDIR/gcc
git clone --branch $NEWLIB_VERSION --depth=1 https://github.com/bminor/newlib.git $BASEDIR/newlib
git clone --branch $BINTUILS_VERSION --depth=1 https://github.com/bminor/binutils-gdb.git $BASEDIR/binutils

mkdir -p $BASEDIR/combined/build

ln -s $BASEDIR/newlib/* $BASEDIR/combined/.
ln --force -s $BASEDIR/binutils/* $BASEDIR/combined/.
ln --force -s $BASEDIR/gcc/* $BASEDIR/combined/.

cd $BASEDIR/combined/build

../configure --target=riscv32-unknown-elf --enable-languages=c \
             --disable-shared --disable-threads --disable-multilib \
             --disable-gdb --disable-libssp --with-newlib \
             --with-arch=$ARCH --with-abi=$ABI --prefix=$RISCV

make -j$(nproc)
make install