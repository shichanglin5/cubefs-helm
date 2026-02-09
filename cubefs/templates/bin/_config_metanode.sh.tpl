#!/bin/bash

# set -ex
# source init_dirs.sh
echo "prepare to create configuration file"

jq -n \
  --arg port "$CBFS_METANODE_PORT" \
  --arg prof "$CBFS_METANODE_PROF" \
  --arg localIP "$CBFS_METANODE_LOCALIP" \
  --arg logLevel "$CBFS_METANODE_LOG_LEVEL" \
  --arg raftHeartbeatPort "$CBFS_METANODE_RAFT_HEARTBEAT_PORT" \
  --arg raftReplicaPort "$CBFS_METANODE_RAFT_REPLICA_PORT" \
  --arg exporterPort "$CBFS_METANODE_EXPORTER_PORT" \
  --arg masterAddrs "$CBFS_MASTER_ADDRS" \
  --arg totalMem "$CBFS_MASTER_TOTAL_MEM" \
  --arg memRatio "$CBFS_MASTER_MEM_RATIO" \
  --arg consulAddr "$CBFS_CONSUL_ADDR" \
    '{
     "role": "metanode",
     "listen": $port,
     "prof": $prof,
     "localIP": $localIP,
     "logLevel": $logLevel,
     "metadataDir": "/cfs/data/metanode/meta",
     "logDir": "/cfs/logs",
     "raftDir": "/cfs/data/metanode/raft",
     "raftHeartbeatPort": $raftHeartbeatPort,
     "raftReplicaPort": $raftReplicaPort,
     "consulAddr": $consulAddr,
     "exporterPort": $exporterPort,
     "totalMem": $totalMem,
     "memRatio": $memRatio,
     "masterAddr": $masterAddrs
 }' | jq '.masterAddr |= split(",")' > /cfs/conf/metanode.json

# merge the override config
# 1. merge global keys (non-object top-level values apply to all nodes)
# 2. merge per-node keys (keyed by localIP, for node-specific overrides)
jq -s '.[0] + (.[1] | to_entries | map(select(.value | type != "object")) | from_entries)' /cfs/conf/metanode.json /cfs/conf-override/metanode.json > tmp.json
mv tmp.json /cfs/conf/metanode.json
jq -s ".[0] + (.[1].\"$CBFS_METANODE_LOCALIP\" // {})" /cfs/conf/metanode.json /cfs/conf-override/metanode.json > tmp.json
mv tmp.json /cfs/conf/metanode.json

cat /cfs/conf/metanode.json
echo "configuration finished"



