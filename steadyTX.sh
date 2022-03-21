#!/usr/bin/bash
mmxcoin=$1 #amount to send in mojo
coin=$(awk -v mmx=$mmxcoin 'BEGIN {print mmx / 1000000}')
numTX=$2 #number of times to run
inter=$3 #interval between sends in seconds
self=mmx1mqxtcngn4lv0y3n30c5mw4lhh4x7h7zjrs0r2qynethgy20fayaq3ngsm8
height=$(mmx node info | awk '/Height/ {print $2}')
i=1
while (($i <= $numTX));do
	rand=$(shuf -i 1-$height -n 1)
	checkHeight=$(expr $height - $rand)
	address=$(mmx node get block $checkHeight | tr -d '",:' | awk '/address/ && ++i==2 {print $2;exit;}')
	if [[ -z $address ]];then
		:
	elif [[ $address == $self ]];then
		:
	else
		$(mmx wallet send -j 0 -a $coin -t $address &>/dev/null)
		echo $i "/" $numTX " " $checkHeight " " $address " " $coin
		i=$(expr $i + 1)
		sleep $inter
	fi
done
