#!/bin/bash
# export env variables
source $DATA/streaming/streaming_conf/env_variables.sh
source $DATA/streaming/streaming_conf/get_node_name.sh

cd $config_dir
sed "s/broker.id=0/broker.id=1/g; s#/tmp/kafka-logs#$kk_log_dir#g; s/localhost:2181/$zookeeper_connect/g" server.properties > server.1.properties
sed "s/broker.id=1/broker.id=2/g; s/kk1/kk2/g" server.1.properties > server.2.properties
sed "s/broker.id=1/broker.id=3/g; s/kk1/kk3/g" server.1.properties > server.3.properties

ssh $node_1 "source $DATA/streaming/streaming_conf/env_variables.sh; nohup $kafka_server_start_dir/kafka-server-start.sh $config_dir/server.1.properties &> $std_out_dir/kk-1.out &"
echo "Starting kafka ... STARTED"
sleep 3
ssh $node_2 "source $DATA/streaming/streaming_conf/env_variables.sh; nohup $kafka_server_start_dir/kafka-server-start.sh $config_dir/server.2.properties &> $std_out_dir/kk-2.out &"
echo "Starting kafka ... STARTED"
sleep 3
ssh $node_3 "source $DATA/streaming/streaming_conf/env_variables.sh; nohup $kafka_server_start_dir/kafka-server-start.sh $config_dir/server.3.properties &> $std_out_dir/kk-3.out &"
echo "Starting kafka ... STARTED"
sleep 3
