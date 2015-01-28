#!/bin/sh

#echo "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
#echo $2
#echo $3

echo "model level"

l_workpath=$(cd $(dirname $0)/..;pwd)
l_script=${l_workpath}/script
l_log=${l_workpath}/log
l_config=${l_workpath}/conf
l_tmp=${l_workpath}/tmp
l_lib=${l_workpath}/lib
l_data=${l_workpath}/data

model_name=$1
hadoop_input=$2
hadoop_out=$3

Hadoop=`which hadoop`
$Hadoop fs -test -e $hadoop_out
if [ $? -eq 0 ];then
        $Hadoop fs -rm -r $hadoop_out
fi  

case "$model_name" in
	"LR" )
		echo $hadoop_out;;
	"FM" )
		echo $hadoop_out;;
	"GBDT" )
		echo $hadoop_out;;
	esac

