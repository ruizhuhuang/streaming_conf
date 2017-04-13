#!/bin/bash

# export env variables
source $DATA/streaming/streaming_conf/env_variables.sh
source $DATA/streaming/streaming_conf/get_node_name.sh

cd $config_dir
sed "s/server1/$node_2/g; s/server2/$node_3/g; s/host1/$node_1/g; s#storm_local_dir#$storm_local_dir#g; s#storm_logs#$storm_logs#g" storm.yaml.default > storm.1.yaml
sed "s/#supervisor.slots.ports:/supervisor.slots.ports:\n    - 6700\n    - 6701\n    - 6702\n    - 6703/g; s/storm1/storm2/g" storm.1.yaml > storm.2.yaml
sed "s/storm2/storm3/g" storm.2.yaml > storm.3.yaml 


# start nimbas/master
ssh $node_1 "source $DATA/streaming/streaming_conf/env_variables.sh; nohup $storm_server_start_dir/storm --config $config_dir/storm.1.yaml nimbus &> $std_out_dir/storm-1.out &"
echo "Starting storm nimbus ... STARTED"
sleep 3
# start supervisor/slave
ssh $node_2 "source $DATA/streaming/streaming_conf/env_variables.sh; nohup $storm_server_start_dir/storm --config $config_dir/storm.2.yaml supervisor &> $std_out_dir/storm-2.out &"
echo "Starting storm supervisor ... STARTED"
sleep 3
# start supervisor/slave
ssh $node_3 "source $DATA/streaming/streaming_conf/env_variables.sh; nohup $storm_server_start_dir/storm --config $config_dir/storm.3.yaml supervisor &> $std_out_dir/storm-3.out &"
echo "Starting storm supervisor ... STARTED"
sleep 3
# start storm-ui
ssh $node_1 "source $DATA/streaming/streaming_conf/env_variables.sh; nohup $storm_server_start_dir/storm --config $config_dir/storm.1.yaml ui &> $std_out_dir/storm-ui.out &" 
echo "Starting ui ... STARTED"
sleep 3
# port forwarding
ssh $node_1 "source $DATA/streaming/streaming_conf/env_variables.sh; nohup ssh -f -g -N -R 58080:127.0.0.1:8080 login1 >> $std_out_dir/storm-ui.out 2>&1 &"
echo "Starting port forwarding to http://wrangler.tacc.utexas.edu:58080/index.html"
