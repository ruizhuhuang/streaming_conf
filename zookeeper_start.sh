#!/bin/bash
# export env variables
source $DATA/streaming/streaming_conf/env_variables.sh
source $DATA/streaming/streaming_conf/get_node_name.sh

cd $config_dir
sed "s#data_dir#$data_dir#g; s#log_dir#$log_dir#g; s/server1/$node_1/g; s/server2/$node_2/g; s/server3/$node_3/g" zoo_default.cfg > zoo_1.cfg
sed "s/zk1/zk2/g" zoo_1.cfg >zoo_2.cfg
sed "s/zk1/zk3/g" zoo_1.cfg >zoo_3.cfg
echo 1 > $streaming_out/data/zk1/myid
echo 2 > $streaming_out/data/zk2/myid
echo 3 > $streaming_out/data/zk3/myid

ssh $node_1 "source $DATA/streaming/streaming_conf/env_variables.sh; cd $config_dir;cp zoo_1.cfg zoo.cfg; export ZOOCFGDIR=$config_dir; $zookeeper_start_dir/zkServer.sh start"
sleep 3
ssh $node_2 "source $DATA/streaming/streaming_conf/env_variables.sh; cd $config_dir;cp zoo_2.cfg zoo.cfg; export ZOOCFGDIR=$config_dir; $zookeeper_start_dir/zkServer.sh start"
sleep 3
ssh $node_3 "source $DATA/streaming/streaming_conf/env_variables.sh; cd $config_dir;cp zoo_3.cfg zoo.cfg; export ZOOCFGDIR=$config_dir; $zookeeper_start_dir/zkServer.sh start"
sleep 3
