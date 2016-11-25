#!/bin/sh

# Determine the local ip
ifconfig | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" >> output
local_ip=$(head -n1 output)
rm output

# Determine the local ZK index
myindex=$(echo $local_ip | sed -e 's/\.//g')

# Wait for containers to be up and running
sleep 10

nslookup $HOSTNAME
nslookup $HOSTNAME >> zk.cluster

# Configure Zookeeper
no_instances=$(($(wc -l < zk.cluster) - 2))

while [ $no_instances -le $NO ] ; do
        rm -rf zk.cluster
        nslookup $HOSTNAME
        nslookup $HOSTNAME >> zk.cluster
        no_instances=$(($no_instances + 1))
done

while read line; do
        ip=$(echo $line | grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b")
        echo "$ip" >> zk.cluster.tmp
done < 'zk.cluster'
rm zk.cluster

sort -n zk.cluster.tmp > zk.cluster.tmp.sort
mv zk.cluster.tmp.sort zk.cluster.tmp

touch $ZK_HOME/conf/zoo.cfg.dynamic
chmod -R 777 $ZK_HOME

# Check the configuration of the rest of the servers
while read line; do
    
        if [ "$line" != "" ]; then 
                index=$(echo $line | sed -e 's/\.//g')
                echo "server.$index=$line:2888:3888:participant;2181" >> $ZK_HOME/conf/zoo.cfg.dynamic
        fi
        
done < 'zk.cluster.tmp'

rm zk.cluster.tmp

$ZK_HOME/bin/zkServer-initialize.sh --force --myid=$myindex
ZOO_LOG_DIR=/var/log ZOO_LOG4J_PROP='INFO,CONSOLE,ROLLINGFILE' $ZK_HOME/bin/zkServer.sh start-foreground
