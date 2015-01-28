#!bin/sh
function MULTIDIR()
{
	if [ $# -eq 4 ];then                        # check date
		TMP_BASE_PATH=$1
		TMP_END_DATE=`date -d $2 +%Y%m%d`
		TMP_BEGIN_DATE=`date -d "$2 $(($3-1)) days ago" +%Y%m%d`
		local __MULTIPATH=$4
		local MULTIPATH=''
	else
		echo "[INFO] USAGE: $0 HDFS_BASIC_PATH STARTDATE (format: YYYY/mm/dd) [DAYSAGO_NUM] [out:MULTIPATH]";
		return 1;
	fi

	while [ $TMP_BEGIN_DATE -le $TMP_END_DATE ]; do
		YEAR=${TMP_BEGIN_DATE:0:4}
		MONTH=${TMP_BEGIN_DATE:4:2}
		DAY=${TMP_BEGIN_DATE:6:2}
		TMP_LOC=$TMP_BASE_PATH$YEAR$MONTH$DAY,
		MULTIPATH=$MULTIPATH${TMP_LOC}
		TMP_BEGIN_DATE=`date -d "$TMP_BEGIN_DATE UTC +1 day" +"%Y%m%d"`
	done
	eval $__MULTIPATH="${MULTIPATH%/,}"
}
