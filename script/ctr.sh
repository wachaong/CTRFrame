#!/bin/sh

l_workpath=$(cd $(dirname $0)/..;pwd)
l_script=${l_workpath}/script
l_log=${l_workpath}/log
l_config=${l_workpath}/conf
l_tmp=${l_workpath}/tmp
l_lib=${l_workpath}/lib
l_data=${l_workpath}/data

setfile=$1

CTR=/dw/mds/ctr
setFile=$CTR/config_file/parse_xml_result
#source_input_file=$CTR/sessionlog_ad/
source_out_file=$CTR/source_level_out/
feature_level=$CTR/feature_level_out/
transform_level=$CTR/transform_level_out/
model=$CTR/model_level_out/

Hadoop=`which hadoop`
Scala=`which scala`

$Scala $l_workpath/tools/parse_xml.scala $setfile > $l_data/parse_xml_result

$Hadoop fs -test -e $CTR/config_file/parse_xml_result
if [ $? -eq 0 ];then
	$Hadoop fs -rm -r $CTR/config_file/parse_xml_result
else
	$Hadoop fs -test -e $CTR/config_file
	if [ $? -ne 0 ];then
		$Hadoop fs -mkdir $CTR/config_file/
	fi
fi

$Hadoop fs -test -e /dw/mds/ctr/config_file/parse_xml_result
if [ $? -eq 0 ];then
	$Hadoop fs -rm -r /dw/mds/ctr/config_file/parse_xml_result
fi
$Hadoop fs -put $l_data/parse_xml_result /dw/mds/ctr/config_file/parse_xml_result

begin=1
end=0

cat $l_data/parse_xml_result | while read LINE
	do
		col_num=`echo $LINE | awk '{print NF}' | head -n 1`
		declare -a array
		for((i=1;i<=$col_num;++i))
		do
			array[i-1]=`echo $LINE | cut -d' ' -f$i`
		done
		type=`echo ${array[0]}|awk -F ":" '{print $2}'`
		case "$type" in
			"source" )
				class_name=`echo ${array[1]} | awk -F ":" '{print $2}'`
				source_input_file=`echo ${array[4]} | awk -F ":" '{print $2}'`
				sh $l_script/source_level.sh $class_name $source_input_file $source_out_file"source_base_sample" ${array[2]}
				;;
			"feature" )
				if [ $begin != $end ];then
					sh $l_script/feature_level.sh $setFile $source_out_file"source_base_sample" $feature_level
					begin=$end
				fi
				exit
				;;
			"transform" )
				type=`echo ${array[4]} | awk -F ":" '{print $2}'`
				param=`echo ${array[2]} | awk -F ":" '{print $2}'`
				for file in `hadoop fs -ls $feature_level`
				do
					len=`expr length $feature_level`
	                                substr=`expr substr "$file" 1 $len`
	                                tmp=`expr length $file`
					if [ "$substr" = "$feature_level" ];then
						len=`expr $len + 1`
						name=`expr substr "$file" $len $tmp`
						sh $l_script/transform_level.sh $file $transform_level$name"_"$type $type $param
					fi
				done
				;;
			"model" )
				for file in `hadoop fs -ls $transform_level`
				do
					#echo "file: " $file
					#echo "transform_level: "$transform_level
					len=`expr length $transform_level`
					substr=`expr substr "$file" 1 $len`
					#echo "file: " $substr
					tmp=`expr length $file`
					if [ "$substr" = "$transform_level" ];then
						len=`expr $len + 1`
						name=`expr substr "$file" $len $tmp`
						model_name=`echo ${array[2]}|awk -F ":" '{print $2}'`
						sh $l_script/model_level.sh $model_name $file $model$name"_model_"$model_name
					fi
				done
				;;
		esac
		unset array
	done
