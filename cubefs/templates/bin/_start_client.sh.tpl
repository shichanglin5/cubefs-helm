#!/bin/bash

# set -ex

mkdir -p /cfs/mnt

# 如果 /cfs/conf/cli.json 存在，那么移动到 ~/.cfs-cli.json
if [ -f /cfs/conf/cli.json ]; then
    mv /cfs/conf/cli.json ~/.cfs-cli.json
fi

cat /cfs/conf/fuse.json
echo "start client"
/cfs/bin/cfs-client -f -c /cfs/conf/fuse.json