#!/usr/bin/bash
logFile=$1
eligible=( $(awk '/plots were/ {printf "%d %s %s %s/\n",$5,$6,$7,$8}' $logFile | sort | uniq -c) )
lookup=( $(awk '/plots were/ {printf "%f/\n",$17}' $logFile) )
vdf=( $(awk '/Verified VDF/ {printf "%f %f/\n",$12,$15}' $logFile) )
router=( $(awk '/dropped/ {printf "%d/%d/%d/%d/%d\n",$19,$21,$23,$25,$27}' $logFile) )
blockCount=0

blockCount=$(awk '/Created block/ {bl=$9; sc[bl]=$16};
        /Finalized/ {if ($17 == sc[$7]) c++}; END {print c}' $logFile)

echo ${eligible[@]} | awk 'BEGIN {RS = "/"}; {if ($1 != "") printf "%-2d %s %s %s: %7d\n",$2,$3,$4,$5,$1}'
echo ${lookup[@]} | awk 'BEGIN {RS = "/"}; $1>0.5{c1++}; $1>1{c2++}; 1>5{c3++}; {l="Lookups Longer Than"};
	{sum+=$1}; END {printf "%-22s %5d\n%-22s %5d\n%-22s %5d\n%-22s %9f %s\n",l" 0.5s:",c1,"\033[33m"l" 1.0s:",c2,"\033[31m"l" 5.0s:",c3,"\033[37mAverage Lookup:",sum / NR,"sec"}'
echo ${lookup[@]} | awk 'BEGIN {RS = "/"}; $1>max{max=$1}; END {printf "%-16s %10f %s\n","Longest Lookup:",max,"sec"}'
awk '/Finalized/ {print $14}' $logFile | awk '{ sum += $1 }; END { if (NR > 0) printf "%16s %8d\n","Network Average Score:",sum/NR}'
printf "\033[32mBlocks Won: %19d\n" $blockCount
printf "\033[37m----------------------\n"
echo ${vdf[@]} | awk 'BEGIN {RS = "/"}; $2>2{v1++}; $2>5{v2++}; $1>15{d++}; {l="VDF Verification >"}
	{sum+=$2}; END {printf "%-16s %14d\n%-16s %7d\n%-16s %7d\n%-22s %9f %s\n","VDF Delta >15s:",d,l"2.0s:",v1,"\033[31m"l"5.0s:",v2,"\033[37mAverage VDF Time:",sum / NR,"sec"}'
awk '/Finalized/ $23>max{max=$23}; END {printf "%-22s %8d\n","Fastest Timelord:",max}' $logFile
echo "----------------------"
echo ${router[@]} | awk 'BEGIN {RS = " "} {FS = "/"}; {bl+=$1}; {td+=$2}; {vd+=$3}; {pd+=$4}; {bd+=$5}; {if ($2 + $3 + $4 + $5 > 100) hi++};
	END {printf "%-22s %8d\n%-22s %8d\n%-22s %8d\n%-22s %8d\n%-22s %8d\n%-22s %8d\n",\
	"Blocks Uploaded:",bl,"TX Dropped:",td,"VDFs Dropped:",vd,"Proofs Dropped:",pd,"Blocks Dropped:",bd,"Lossy Router Count:",hi}'
