FROM ubuntu:14.04

# Prepare the environment
ADD init-docker.sh /opt

# Add entrypoint
ADD entrypoint.sh /opt/zookeeper-3.4.12/bin/
RUN chmod 777 /opt/zookeeper-3.4.12/bin/entrypoint.sh
ENV ZK_HOME /opt/zookeeper-3.4.12

# Add versioning details
ADD version.json /opt

EXPOSE 2181 2888 3888
ENTRYPOINT ["/opt/zookeeper-3.4.12/bin/entrypoint.sh"]
