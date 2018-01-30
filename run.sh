#!/bin/bash

# A helper script for some of HW0.

# We'll just store all the test results in a temp folder.
DIR=`mktemp -d`
cd $DIR

# A bit of a safety check, since we don't want to delete our home directory at the end if this doesn't work.
if [[ ! "$DIR" || ! -d "$DIR" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

# Okay, now here are the commands you would normally run...

# Download the tarball for the knapsack program (I mirrored it here because SCPing a file twice is annoying)
wget https://github.com/pokemonmegaman/hw0helper/raw/master/knapsack.tar.gz

# Untar the file
tar -xvf knapsack.tar.gz

# Compile with defualts
g++ -o knapsack_O0 knapsack.cpp

# Test with defaults, log to a file
echo 'Testing knapsack (Optimization O0)...'
echo 'Knapsack (Optimization O0)' >> test_results.log

# Let's run it 5 times.
for i in {1..5}
do
  echo "Pass $i"
  # All the fancy input redirection is so we can just extract the 'time' bit
  # Really all we're doing is 'time ./knapsack_O0 input'.
  (time ./knapsack_O0 input) >/dev/null 2>>test_results.log
done

# Compile with optimization level 4 (-O4)

g++ -o knapsack_O4 -O4 knapsack.cpp

echo "===============" >> test_results.log

# Test O4
echo 'Testing knapsack (Optimization O4)...'
echo 'Knapsack (Optimization O4)' >> test_results.log

for i in {1..5}
do
  echo "Pass $i"
  (time ./knapsack_O4 input) >/dev/null 2>>test_results.log
done

echo "===============" >> test_results.log

# Get some relevent system data and store to the test results as well

echo "Core Count" >> test_results.log

# Literally opens /proc/cpuinfo and counts the number of times the word "processor" is said.
# Fairly effective means of determining core count.
cat /proc/cpuinfo | grep -c ^processor >> test_results.log

echo "" >> test_results.log

# All the cores are (hopefully) at the same clock speed (weird stuff is abrew if this is not the case).
# We're gonna just get the first one (which is what the head -1 is for)
echo "CPU Frequency" >> test_results.log
cat /proc/cpuinfo | grep MHz | head -1 >> test_results.log

echo "" >> test_results.log

echo "Current users" >> test_results.log
# For some reason, 'w' doesn't want to work on the POWER8 machines.  'who' is pretty similar for getting who's logged in.
# Realistically, load averages will give us a better picture of the actual CPU load.
who >> test_results.log

echo "" >> test_results.log

echo "Current load averages" >> test_results.log
# Uptime, in additon to other things, gives the load averages (the three numbers at the end).
# I coulndn't be bothered to "sed"ify this, but all the info it gives is pretty useful anyways.
uptime >> test_results.log

echo "" >> test_results.log

# /proc/version has many things, including the Linux kernel version, the OS, and the GCC version.
echo "Linux version / OS version / GCC version" >> test_results.log
cat /proc/version >> test_results.log

# Display the results at the end
less test_results.log

# And cleanup our temp dir.
rm -r $DIR

# Hey, you made it to the end!  If you are actually reading this, cool trick: you can run this really easily, just do
# curl https://raw.githubusercontent.com/pokemonmegaman/hw0helper/master/run.sh | bash
# on your desired machine.
