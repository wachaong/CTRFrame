#!/bin/sh

l_workpath=$(cd $(dirname $0)/..;pwd)
l_script=${l_workpath}/script
l_log=${l_workpath}/log
l_config=${l_workpath}/conf
l_tmp=${l_workpath}/tmp
l_lib=${l_workpath}/lib
l_data=${l_workpath}/data

echo "source level"

if [ $# -eq 4 ]
then
        class_name=$1
        hadoop_input=$2
        hadoop_out=$3
	param=$4
else
	echo "Useage: [class_name] [hadoop_input] [hadoop_out] [param]"
fi

echo "class_name "$class_name
echo "input "$hadoop_input
echo "out "$hadoop_out

param_len=`echo $param | awk -F "," '{sum+=1}END{print sum}'`

if [ $param_len -gt 1 ];then
	end_time=`echo $param | awk -F "," '{print $1}'`
	days=`echo $param | awk -F "," '{print $2}'`

	echo $end_time
	echo $days

	source ./common_script.sh
	MULTIDIR $hadoop_input $end_time $days instances
	hadoop_input=$instances
fi

Hadoop=`which hadoop`

$Hadoop fs -test -e $hadoop_out
if [ $? -eq 0 ];then
        $Hadoop fs -rm -r $hadoop_out
fi

$Hadoop jar $l_lib/algo-common-1.0.4-jar-with-dependencies.jar \
com.autohome.adrd.algo.click_model.io.Launcher \
com.autohome.adrd.algo.click_model.source.autohome.$class_name \
-D mapreduce.lib.table.input.projection='adoldclk,adoldpv' \
-D mapreduce.map.memory.mb=6000 \
-D mapreduce.reduce.memory.mb=10000 \
-files $l_config/sessionlog.config.oldad \
-input $hadoop_input \
-output $hadoop_out \
-numReduce 0 \
-input_rcfile

