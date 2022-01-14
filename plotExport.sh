#!/bin/bash
logFile=$1
arrayC=( $(awk '/Created/ {print $9 ":" $16}' ${logFile}) )
arrayF=()
count=0
csvFile=$(echo $logFile | awk 'BEGIN{FS = "/"}; {sub("txt", "csv", $NF); print $NF}')
echo "Block,k-size,plotID,Score,Difficulty" > $csvFile
for i in ${!arrayC[@]}; do
	block=$(awk 'BEGIN { FS=":" } {print $1}' <<< ${arrayC[$i]})
	score=$(awk 'BEGIN { FS=":" } {print $2}' <<< ${arrayC[$i]} | tr -d ',')
	scoreF=$(awk -v bl="$block" '$7~bl && /Finalized/ {print $14}' ${logFile} | tr -d ',' | uniq)

	if [[ $score -eq $scoreF ]] 
	then
		blockJson=$(mmx node get block ${block})
		plotID=$(echo ${blockJson} | tr -d '":,' | awk '/plot_id/ {print $28}')
		kSize=$(echo ${blockJson} | tr -d '":,' | awk '/ksize/ {print $24}')
		sdiff=$(echo ${blockJson} | tr -d '":,' | awk '{print $13}')
		echo $block,$kSize,$plotID,$score,$sdiff >> $csvFile
		count=$(expr $count + 1)
	fi
done
#echo $count "total blocks"

