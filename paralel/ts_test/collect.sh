#!/bin/bash

touch procs; touch times; touch speedup2k.log

echo '1' > procs
tail -n -1 time1.log | awk '{print $3}' > times

for (( i=2; i<=400; i=$i+2 )); do
	echo $i >> procs
	tail -n -1 time$i.log | awk '{print $3}' >> times
done

paste procs times > speedup2k.log
rm procs times
