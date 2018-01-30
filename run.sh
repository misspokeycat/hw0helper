#!/bin/bash

# A helper script for some of HW0.

# We'll just store all the test results in a temp folder.
DIR=`mktemp -d`
cd $DIR

# A bit of a safety check, since we don't want to delete our home directory at teh end if this doesn't work.
if [[ ! "$DIR" || ! -d "$DIR" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

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
  (time ./knapsack_O0 input) >/dev/null 2>>test_results.log
done

# Compile with optimization level 4

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
cat /proc/cpuinfo | grep -c ^processor >> test_results.log

echo "" >> test_results.log

echo "CPU Frequency" >> test_results.log
cat /proc/cpuinfo | grep MHz | head -1 >> test_results.log

echo "" >> test_results.log

echo "Current users" >> test_results.log
who >> test_results.log

echo "" >> test_results.log

echo "Current load averages" >> test_results.log
uptime >> test_results.log

# Display the results at the end
less test_results.log

# And cleanup
rm -r $DIR
