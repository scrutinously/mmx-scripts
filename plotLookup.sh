#!/bin/bash
logFile=$1
count=0
arrayB=( $(awk '/Created block/ {bl=$9; sc[bl]=$16};
        /Committed/ {if ($17 == sc[$7]) print $7}' $logFile) )

for i in ${!arrayB[@]}; do
	plotID=$(mmx node get block ${arrayB[$count]} | tr -d '":,' | awk '/plot_id/ {print $2}')
	filename=$(locate $plotID)
	echo ${arrayB[$count]}  $filename
	count=$(expr $count + 1)
done
echo $count "total blocks"
