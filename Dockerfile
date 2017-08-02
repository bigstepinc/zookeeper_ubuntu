FROM ubuntu:14.04
 
ENV ZK_HOME /opt/zookeeper-3.5.2-alpha

ADD zk-init.sh $ZK_HOME/bin/
RUN chmod 777 /opt/zookeeper-3.5.2-alpha/bin/zk-init.sh

ADD version.json /opt

EXPOSE 2181 2888 3888
ENTRYPOINT ["/opt/zookeeper-3.5.2-alpha/bin/zk-init.sh"]
