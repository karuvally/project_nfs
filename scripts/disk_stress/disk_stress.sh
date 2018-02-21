#!/bin/bash
# Emulates disk IO during normal use
# Copyright 2018, Aswin Babu Karuvally

# set source and destination
nfs_path=/mnt/remotenfs/$HOSTNAME
tmp_source=$nfs_path/tmp/tmp_files
tmp_destination=$nfs_path/tmp/tmp_destination

# create running directory
if [ ! -d $nfs_path ];
then
    echo "creating working directory"
    mkdir $nfs_path
fi

# warn if running with incorrect path
if [ "$nfs_path" != "/mnt/remotenfs/$HOSTNAME" ];
then
    echo "warning: nfs path might not be correctly set!"
fi

# check if rsync is installed
if [ ! -e /usr/bin/rsync ];
then
    echo "error: rsync is not installed"
    exit
fi

# create temp files if they do not exist
if [ ! -d $tmp_source ];
then
    echo "creating temp file blocks"
    mkdir -p $tmp_source
    mkdir -p $tmp_destination

    dd if=/dev/zero of=$tmp_source/4KB bs=4K count=1
    dd if=/dev/zero of=$tmp_source/16KB bs=16K count=1
    dd if=/dev/zero of=$tmp_source/64KB bs=64K count=1
    dd if=/dev/zero of=$tmp_source/512KB bs=512K count=1
    dd if=/dev/zero of=$tmp_source/1MB bs=1M count=1
    dd if=/dev/zero of=$tmp_source/16MB bs=1M count=16
    dd if=/dev/zero of=$tmp_source/64MB bs=1M count=64
else
    # clean junk files
    echo "cleaning junk files"
    rm $tmp_destination/*
fi

# emulate disk IO
echo "running tests"

while true
do
    rsync --bwlimit=4 $tmp_source/4KB $tmp_destination
    sleep 0.5

    rsync --bwlimit=15000 $tmp_source/16MB $tmp_destination
    sleep 0.1

    rsync --bwlimit=16 $tmp_source/16KB $tmp_destination
    sleep 0.4

    rm $tmp_destination/16MB
    sleep 0.3

    rsync /etc/nanorc $tmp_destination
    sleep 2

    rm $tmp_destination/4KB
    sleep 0.5

    rsync --bwlimit=94 $tmp_source/512KB $tmp_destination
    sleep 0.2

    rsync --bwlimit=20000 $tmp_source/64MB $tmp_destination
    sleep 0.4

    rsync --bwlimit=4600 $tmp_source/16MB $tmp_destination
    sleep 0.2

    # add reading of random files
done
