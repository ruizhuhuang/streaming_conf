#!/bin/bash
export streaming_out=$DATA/streaming
export data_dir=$streaming_out/data/zk1
export log_dir=$streaming_out/log/zk1
export kk_log_dir=$streaming_out/log/kk1
export storm_local_dir=$streaming_out/log/storm1
export std_out_dir=$streaming_out/services_start_std_out

export zookeeper_connect=$node_1:2181,$node_2:2181,$node_3:2181
export config_dir=$DATA/streaming/streaming_conf
export zookeeper_start_dir=/usr/lib/zookeeper/bin
export kafka_server_start_dir=/data/apps/kafka_2.11-0.10.1.0/bin
export storm_server_start_dir=/data/apps/apache-storm-1.0.2/bin

# two directories below used to redirect logs writing to installation directory
export LOG_DIR=$DATA/streaming/log/kafka_logs
export storm_logs=$DATA/streaming/log/storm_logs


#echo $node_1
#echo $node_2
#echo $node_3
#echo $data_dir
#echo $log_dir
#echo $config_dir
#echo $storm_server_start_dir
#echo $kafka_server_start_dir
#echo $zookeeper_start_dir
#echo $std_out_dir
#echo $LOG_DIR
#echo $storm_logs

