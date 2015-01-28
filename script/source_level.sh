#!/bin/sh

#echo "sssssssssssssssssssssssss"

l_workpath=$(cd $(dirname $0)/..;pwd)
l_script=${l_workpath}/script
l_log=${l_workpath}/log
l_config=${l_workpath}/conf
l_tmp=${l_workpath}/tmp
l_lib=${l_workpath}/lib
l_data=${l_workpath}/data

echo "source level"

echo $1
echo $2
echo $3

if [ $# -eq 4 ]
then
        class_name=$1
        hadoop_input=$2
        hadoop_out=$3
	param=$4
else
	echo "Useage: [class_name] [hadoop_input] [hadoop_out] [param]"
fi

param_len=`echo $param | awk -F "," '{sum+=1}END{print sum}'`

if [ $param_len -gt 1 ];then
	end_time=`echo $param | awk -F "," '{print $1}'`
	days=`echo $param | awk -F "," '{print $2}'`

	echo $end_time
	echo $days

	source ./common_script.sh
	MULTIDIR $hadoop_input $end_time $days instances
fi

Hadoop=`which hadoop`

AD_FEATURE_JAR=$l_lib/algo-features-1.0.10-jar-with-dependencies.jar

num=`echo $instances | awk -F "," '{sum+=1}END{print sum}'`
if [ $num -eq 1 ];then
	hadoop_input=$instances
fi

$Hadoop fs -test -e $hadoop_out
if [ $? -eq 0 ];then
        $Hadoop fs -rm -r $hadoop_out
fi

echo $hadoop_input
exit
#$HADOOP fs -rm -r $hdfs_out
$Hadoop jar $AD_FEATURE_JAR \
com.autohome.adrd.algo.click_model.io.Launcher \
$class_name \
-D mapreduce.map.memory.mb=6000 \
-D mapreduce.reduce.memory.mb=10000 \
-input $hadoop_input \
-output $hadoop_out \
-numReduce 0

