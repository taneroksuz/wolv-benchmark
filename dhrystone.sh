#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "example usage: ./dhrystone.sh wolv-z0"
  exit 1
fi

cd $1

export BASEDIR=$(pwd)
export $(grep -v '^#' $BASEDIR/.env | xargs)

if [ -d "$BASEDIR/dhrystone" ]; then
  rm -rf $BASEDIR/dhrystone
fi

cp -r $BASEDIR/../dhrystone $BASEDIR/

mkdir -p $BASEDIR/dhrystone/common/

cp $BASEDIR/crt.S $BASEDIR/dhrystone/common/
cp $BASEDIR/test.ld $BASEDIR/dhrystone/common/

cp $BASEDIR/../common/util.h $BASEDIR/dhrystone/common/
cp $BASEDIR/../common/encoding.h $BASEDIR/dhrystone/common/
cp $BASEDIR/../common/strcmp.S $BASEDIR/dhrystone/common/
cp $BASEDIR/../common/syscalls.c $BASEDIR/dhrystone/common/
cp $BASEDIR/../common/dhrystone.mak $BASEDIR/dhrystone/Makefile

cd $BASEDIR/dhrystone

make