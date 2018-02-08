#!/bin/bash
# Ubuntu 16.04 Xenial 
# testing new  build

# install debootstrap
sudo apt-get install debootstrap

TS=`date +'%Y%m%d'`
BASENAME="eemt-v$TS"

rm -f $BASENAME.img
singularity create --size 4000 $BASENAME.img
singularity bootstrap $BASENAME.simg Singularity
