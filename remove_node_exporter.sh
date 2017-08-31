#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please use sudo while running this script !!!"
  exit 0
fi
sudo rm -r prometheus_node_exporter_installation_2017
sudo rm /usr/bin/node_exporter
sudo systemctl stop node_exporter.service
sudo systemctl disable node_exporter.service
sudo rm /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
sudo systemctl status node_exporter.service 

echo -e "**** If you are getting Active: inactive (dead) , \n\tnode_exporter has been removed from this system !!!"
 
