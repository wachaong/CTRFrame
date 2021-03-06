#!/bin/sh

l_workpath=$(cd $(dirname $0)/..;pwd)
l_script=${l_workpath}/script
l_log=${l_workpath}/log
l_config=${l_workpath}/conf
l_tmp=${l_workpath}/tmp
l_lib=${l_workpath}/lib
l_data=${l_workpath}/data

Hadoop=`which hadoop`

input_file=$1
output_file=$2

$Hadoop fs -rm -r $output_file

spark-submit \
--class feature_level \
--master yarn-cluster \
--executor-memory 28G \
--executor-cores 30 \
--num-executors 30 \
--driver-memory 28G \
./target/*.jar \
/dw/mds/ctr/config_file/parse_xml_result \
$input_file \
$output_file \
$3

