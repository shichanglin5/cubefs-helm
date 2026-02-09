#!/bin/bash

# set -ex
# source init_dirs.sh
echo "prepare to create configuration file"
CBFS_HOSTNAME_INDEX=""
CBFS_ID=""
CBFS_HOSTNAME_INDEX=`echo $POD_NAME | awk -F '-' '{print $2}'`
CBFS_ID=$(($CBFS_HOSTNAME_INDEX+1))

# cfs-cli
# 解析 CBFS_MASTER_PEERS : 1:master-0.master-service:17010,2:master-1.master-service:17010,3:master-2.master-service:17010 为数组形式:
# ["master-0.master-service:17010","master-1.master-service:17010","master-2.master-service:17010"]
CLEAN_ADDRS=$(echo "$CBFS_MASTER_PEERS" | tr -d '[:space:]' | sed 's/[0-9]*:\([^,]*\)/\1/g')
jq -n \
  --arg masterAddr "$CLEAN_ADDRS" \
  '{
      "masterAddr": ($masterAddr | split(",") | map(select(. != ""))), 
      "timeout": 60
    }' > /cfs/conf/cli.json

cat /cfs/conf/cli.json

# cfs-master
jq -n \
  --arg clusterName "$CBFS_MASTER_CLUSTER" \
  --arg id $CBFS_ID \
  --arg ip "$POD_IP" \
  --arg port "$CBFS_MASTER_PORT" \
  --arg prof "$CBFS_MASTER_PROF" \
  --arg peers "$CBFS_MASTER_PEERS" \
  --arg retainLogs "$CBFS_MASTER_RETAIN_LOGS" \
  --arg exporterPort "$CBFS_MASTER_EXPORTER_PORT" \
  --arg logLevel "$CBFS_MASTER_LOG_LEVEL" \
  --arg consulAddr "$CBFS_CONSUL_ADDR" \
  --arg metaNodeReservedMem "$CBFS_METANODE_RESERVED_MEM" \
  --arg legacyDataMediaType "$CBFS_LEGACY_DATA_MEDIA_TYPE" \
  '{
    "role": "master",
    "ip": $ip,
    "listen": $port,
    "prof": $prof,
    "id": $id,
    "peers": $peers,
    "retainLogs": $retainLogs,
    "logDir": "/cfs/logs",
    "logLevel": $logLevel,
    "walDir": "/cfs/raft/master",
    "storeDir": "/cfs/data/master/rocksdbstore",
    "consulAddr": $consulAddr,
    "exporterPort": $exporterPort,
    "clusterName": $clusterName,
    "metaNodeReservedMem": $metaNodeReservedMem,
    "legacyDataMediaType": $legacyDataMediaType
}' > /cfs/conf/master.json

cat /cfs/conf/master.json
echo "configuration finished"
