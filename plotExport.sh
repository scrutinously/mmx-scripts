#!/bin/bash
logFile=$1
count=0
csvFile=$(echo $logFile | awk 'BEGIN{FS = "/"}; {sub("txt", "csv", $NF); print $NF}')
echo "Block,k-size,plotID,Score,Difficulty" > $csvFile

arrayB=( $(awk '/Created block/ {bl=$9; sc[bl]=$16};
        /Finalized/ {if ($17 == sc[$7]) print $7}' $logFile) )
for i in ${!arrayB[@]}; do
		blockJson=$(mmx node get block ${arrayB[$count]})
		echo ${blockJson} | tr -d '":,' | awk '{printf "%s,%s,%s,%s,%s\n",$9,$24,$28,$26,$13}' >> $csvFile
		count=$(expr $count + 1)
done
echo $count "total blocks"
