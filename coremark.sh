#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "example usage: ./coremark.sh wolv-z0"
  exit 1
fi

cd $1

export BASEDIR=$(pwd)
export $(grep -v '^#' $BASEDIR/.env | xargs)

if [ -d "$BASEDIR/coremark" ]; then
  rm -rf $BASEDIR/coremark
fi

cp -r $BASEDIR/../coremark $BASEDIR/

mkdir -p $BASEDIR/coremark/common/

cp $BASEDIR/crt.S $BASEDIR/coremark/common/
cp $BASEDIR/test.ld $BASEDIR/coremark/common/

cp $BASEDIR/../common/util.h $BASEDIR/coremark/common/
cp $BASEDIR/../common/encoding.h $BASEDIR/coremark/common/
cp $BASEDIR/../common/strcmp.S $BASEDIR/coremark/common/
cp $BASEDIR/../common/syscalls.c $BASEDIR/coremark/common/
cp $BASEDIR/../common/ee_printf.c $BASEDIR/coremark/common/
cp $BASEDIR/../common/core_portme.c $BASEDIR/coremark/common/
cp $BASEDIR/../common/core_portme.h $BASEDIR/coremark/common/
cp $BASEDIR/../common/coremark.mak $BASEDIR/coremark/Makefile

cd $BASEDIR/coremark

make