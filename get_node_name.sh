#!/bin/bash
export node_1=`scontrol show hostnames $SLURM_NODELIST|head -n 1`
export node_2=`scontrol show hostnames $SLURM_NODELIST|head -n 2|tail -n 1`
export node_3=`scontrol show hostnames $SLURM_NODELIST|head -n 3|tail -n 1`
