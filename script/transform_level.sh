#!/bin/sh

echo "transform_level"
echo "hadoop_input_file: " $1
echo "hadoop_out_file: " $2
echo "type: " $3
echo "param: " $4 

if [ $# -eq 4 ];then
        hadoop_input=$1
        hadoop_out=$2
	type=$3
	param=$4
else
	echo "Useage: [hadoop_input_file] [hadoop_out_file] [transform_type] [param]"
        exit 1
fi

Hadoop=`which hadoop`
$Hadoop fs -test -e $hadoop_out
if [ $? -eq 0 ];then
	$Hadoop fs -rm -r $hadoop_out
fi

$Hadoop fs -test -e $hadoop_out"_"$param
if [ $? -eq 0 ];then
	$Hadoop fs -rm -r $hadoop_out"_"$param
fi

case "$type" in
	"filter" )
	$Hadoop fs -mkdir $hadoop_out"_"$param
	;;
	"discretization" )
	$Hadoop fs -mkdir $hadoop_out
	;;
esac
