#!/usr/bin/bash
for i in {1..10000}
do
 echo -n $i && echo -n " " && curl 192.168.3.173:9000 &
done