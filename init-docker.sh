#!/bin/bash

# Prepare environment
apt-get update && apt-get -y install wget tar openjdk-8-jdk dnsutils  net-tools && apt-get clean

# Application download and install
cd /opt && wget https://www-eu.apache.org/dist/zookeeper/stable/zookeeper-3.4.12.tar.gz
cd /opt && tar xzvf /opt/zookeeper-3.4.12.tar.gz
rm -rf /opt/zookeeper-3.4.12.tar.gz
cd /opt/zookeeper-3.4.12
