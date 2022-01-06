#!/bin/bash
logFile=$1
arrayC=( $(awk '/Created/ {print $9 ":" $16}' ${logFile}) )
arrayF=()
count=0
fileArray=()
for i in ${!arrayC[@]}; do
	block=$(awk 'BEGIN { FS=":" } {print $1}' <<< ${arrayC[$i]})
	score=$(awk 'BEGIN { FS=":" } {print $2}' <<< ${arrayC[$i]} | tr -d ',')
	scoreF=$(awk -v bl="$block" '$7~bl && /Finalized/ {print $14}' ${logFile} | tr -d ',' | uniq)
	
	if [[ $score -eq $scoreF ]] 
	then
		plotID=$(mmx node get block ${block} | tr -d '":,' | awk '/plot_id/ {print $2}')
		filename=$(locate $plotID)
		echo $block  $filename
		count=$(expr $count + 1)
	fi
done
echo $count "total blocks"


