#!/bin/bash

# Prepare environment
apt-get update && apt-get -y install wget tar openjdk-8-jdk dnsutils  net-tools && apt-get clean

# Application download and install
cd /opt && wget http://mirror.evowise.com/apache/zookeeper/zookeeper-3.5.2-alpha/zookeeper-3.5.2-alpha.tar.gz
cd /opt && tar xzvf /opt/zookeeper-3.5.2-alpha.tar.gz
rm -rf /opt/zookeeper-3.5.2-alpha.tar.gz
cd /opt/zookeeper-3.5.2-alpha
