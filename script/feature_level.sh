#!/bin/sh

l_workpath=$(cd $(dirname $0)/..;pwd)
l_script=${l_workpath}/script
l_log=${l_workpath}/log
l_config=${l_workpath}/conf
l_tmp=${l_workpath}/tmp
l_lib=${l_workpath}/lib
l_data=${l_workpath}/data

echo "feature_level"

if [ $# -eq 3 ]
then
	set_file=$1
	hadoop_input=$2
	hadoop_out=$3
else
	echo "Useage: [set_file] [hadoop_in] [hadoop_out]"
	exit 1
fi

echo "set_file: "$1
echo "hadoop_in: "$hadoop_input
echo "hadoop_out: "$hadoop_out

Hadoop=`which hadoop`
$Hadoop fs -test -e $hadoop_out
if [ $? -eq 0 ];then
	$Hadoop fs -rm -r $hadoop_out
fi  

spark-submit \
--class feature_level \
--master yarn-cluster \
--executor-memory 28g \
--executor-cores 30 \
--num-executors 30 \
--driver-memory 28G \
$l_lib/sample_operator-1.0-SNAPSHOT.jar \
$set_file \
$hadoop_input \
$hadoop_out 
