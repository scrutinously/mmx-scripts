#!/usr/bin/bash
num=$1
height=$(mmx node info | awk '/Height/ {print $2}')
startheight=$(expr $height - $num)
address=()
echo "Getting addresses from " $startheight " to " $height

for ((i = $startheight ; i <= $height ; i++)); do
	 address+=( $(mmx node get block $i | tr -d '",:' | awk '/address/ {print $2;exit;}') )
done

echo ${address[@]} | tr ' ' '\n' | sort -u 
