#!/bin/bash

echo "bash streaming_services_start.sh hadoop+Evaluating-Identifie+2060 10:00:00 Evaluating-Identifie"   

if [ $# -lt "3" ]; then
  echo "This script requires three arguments:"
  echo "  Reservation"
  echo "  time for the job"
  echo "  Allocation"
  exit -1
fi


reservation=$1
t=$2
allocation=$3

# make directories to store data/logs for three service node(master/slave)
mkdir -p $DATA/streaming/data/zk1 $DATA/streaming/data/zk2 $DATA/streaming/data/zk3
mkdir -p $DATA/streaming/log/zk1 $DATA/streaming/log/zk2 $DATA/streaming/log/zk3
mkdir -p $DATA/streaming/log/kk1 $DATA/streaming/log/kk2 $DATA/streaming/log/kk3
mkdir -p $DATA/streaming/log/storm1 $DATA/streaming/log/storm2 $DATA/streaming/log/storm3

# the directory to check error/exception when starting services
mkdir -p $DATA/streaming/services_start_std_out
# two directories below used to redirect service starting logs writing to installation directory.
mkdir -p $DATA/streaming/log/kafka_logs
mkdir -p $DATA/streaming/log/storm_logs

# copy configuration files to $DATA/streaming
cp -r /data/apps/streaming_conf $DATA/streaming


sbatch -J streaming_apps -o job.%j.out -p hadoop --reservation=$reservation -N 3 -n 3 -t $t -A $allocation << ENDINPUT
#!/bin/bash

export config_dir=\$DATA/streaming/streaming_conf

# zookeeper needs to start before kafka or storm
source \$config_dir/zookeeper_start.sh
source \$config_dir/kafka_start.sh
source \$config_dir/storm_start.sh 

sleep 5

# kill existing topology no kill by scancel slurm job
# Ignore error msg if there is no existing topology  
\$storm_server_start_dir/storm kill TwitterHashtagStorm

echo "Ignore error messages if there is no existing topology..."

sleep 60

# ssh into nimbus/master node to run storm program
ssh \$node_1 "source \$DATA/streaming/streaming_conf/env_variables.sh; \$storm_server_start_dir/storm jar /data/03076/rhuang/mytestapp-jar-with-dependencies.jar org.apache.storm.TwitterHashtagStorm  mJ4B3XXGvVqcpHfYJB5eCcbf1 fmzP5vjCXOMy053UP9TXzdAmdu2PuzDZntHEdWpyjR7Q1GqvUZ 2267758213-9Rxk6noahhJMK6XuhAPXJuLVguAUSyd70EllgQx CuR6gA6Kj2wy55t3EXTracaeNBbzVneSdpJFFVQzzhjks /data/03076/rhuang/HashTagCount.txt food"

echo "Starting TwitterHashtagStorm ...... "


sleep 48h

ENDINPUT
