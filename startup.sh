#!/bin/sh

NODES=""
IFS=','
for i in $SLAVES; do
	m=$(echo $i | awk -F '-' '{print $1}')
	NODES="$NODES $PREFIX$m:$PORT"
done

master="redis-cli --cluster create$NODES --cluster-replicas 0 --cluster-yes"
eval $master

for i in $SLAVES; do
	node1=$PREFIX$(echo $i | awk -F '-' '{print $1}')
	node2=$PREFIX$(echo $i | awk -F '-' '{print $2}')

	slave="redis-cli --cluster add-node $node2:$PORT $node1:$PORT --cluster-slave --cluster-master-id \$(redis-cli -c -h $node1 cluster nodes | grep myself | awk '{print \$1}')"
	eval $slave
done
