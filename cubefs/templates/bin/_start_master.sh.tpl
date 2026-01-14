#!/bin/bash
# set -ex

# mv /cfs/conf/cli.json  ~/.cfs-cli.json
if [ -f /cfs/conf/cli.json ]; then
    mv /cfs/conf/cli.json ~/.cfs-cli.json
fi

mkdir -p /cfs/data/master/raft
mkdir -p /cfs/data/master/rocksdbstore

cat /cfs/conf/master.json
echo "start master"
exec /cfs/bin/cfs-server -f {{ if .Values.log.do_not_redirect_std -}} -redirect-std=false {{- end }} -c /cfs/conf/master.json