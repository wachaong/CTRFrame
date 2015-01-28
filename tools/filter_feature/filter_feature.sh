#!/bin/sh 

#mvn clean package

#
#	arg(1) input file path in hdfs
#	arg(2) feature Number
#	arg(3) iterator Number
#
#if [ $# -eq 4 ]
#then
input_file=$1
out_file=$2
filter_threshold=$3
#else
#	echo "input_file feature_num iter_num weight_path"
#        exit
#fi

work_path=`cd $(dirname $0);pwd`

#########################################
#	generate train data		#
#########################################

hadoop fs -rm -r $out_file

spark-submit \
--class feature_filter \
--master yarn-cluster \
--executor-memory 20g \
--executor-cores 30 \
--num-executors 20 \
--driver-memory 20G \
$work_path/target/*jar \
$input_file \
$out_file \
$filter_threshold
