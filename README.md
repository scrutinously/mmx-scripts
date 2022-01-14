# mmx-scripts
Simple bash scripts for interacting with mmx-node

## Current scripts
getAddresses.sh
Get unique addresses from a number of the last blocks

plotLookup.sh
Parse a log file and return filenames for plots that have won blocks

steadyTX.sh
Send a number of transactions to random addresses at a set interval

colorizeLog
awk script to add color to the log file based on certain patterns

plotExport.sh
Parse log file and return block win details, output to CSV format

## Usage
To use the scripts, they must be run from a terminal session that has the added the mmx-node to the $PATH variable (i.e. the activate.sh script has been run) and ideally from the mmx-node directory.
To achieve this you can copy the scripts into the mmx-node directory, or you can run `export PATH=$PATH:/path/to/directory` to add this directory to the PATH variable for your current session.
To permanently add this directory to your PATH for every new session, add that `export` to your user's shell rc file. 
When added to PATH, binaries no longer require `./` to execute and can be executed from any working directory.

To get the full repository and set up the PATH:
```
git clone https://github.com/scrutinously/mmx-scripts.git
cd mmx-scripts
export PATH=$PATH:$PWD
```
Using the scripts:
### getAddresses.sh
`getAddresses.sh <number of blocks to search>`
ex. `getAddresses.sh 100` will return unique addresses from the last 100 blocks

### plotLookup.sh
`plotLookup.sh <path to log file>`
ex. `plotlookup.sh ~/mmx-node/testnet3/logs/mmx_node_2022_01_06.txt` will output block wins line by line and end with a total

This script takes a long time to run, and I recommend running it with an output to file so you can easily parse it later like so:
`plotlookup.sh ~/mmx-node/testnet3/logs/mmx_node_2022_01_06.txt > won_plots_1_6.txt`
`cat won_plots_1_6.txt | awk '/plot-mmx/{print $2} {if(/total/) {print $0}}' | sort | uniq -c | sort`
This will output how many times each individual plot file has won.
If you are actively plotting, run `sudo updatedb` so that the locate command can find the file.

### steadyTX.sh
`steadyTX.sh <amount in mojos> <number of TX> <delay interval in sec>`
ex. `steadyTX.sh 2000 100 0.1` will send 100 transactions of 2000 mojos every 0.1 sec

### colorizeLog
`colorizeLog <path to log file>`
ex. `./colorizeLog ~/mmx-node/testnet3/logs/mmx_node_2022_01_10.txt | less` Will show the full log with colors 
`tail -f ~/mmx-node/testnet3/logs/mmx_node_2022_01_10.txt | ./colorizeLog` Will continuously watch new entries with colors

### plotExport.sh
`plotExport.sh <path to log file>`
ex. `plotExport.sh ~/mmx-node/testnet3/logs/mmx_node_2022_01_14.txt` will parse the input log file and output a CSV file with the same name.
The CSV will contain the won block height, k size of the plot, the plot ID, the score that won, and the space difficulty at the time.
