#!/bin/bash

# set -ex

mkdir -p /cfs/mnt

# mv /cfs/conf/cli.json  ~/.cfs-cli.json
if [ -f /cfs/conf/cli.json ]; then
    mv /cfs/conf/cli.json ~/.cfs-cli.json
fi

cat /cfs/conf/fuse.json
echo "start client"
/cfs/bin/cfs-client -f -c /cfs/conf/fuse.json