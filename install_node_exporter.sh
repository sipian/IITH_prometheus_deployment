#!/bin/bash

function is_port_free() { 
    echo "**** Checking Whether Port 9100 Is Free Or Not ..."
    isfree=$(netstat -taln | grep 9100)

    if [[ -n "$isfree" ]]
    then 
        echo "9100 Port Is Busy. Exiting Installation ..."
        exit 0
    else 
        echo "9100 Port Is Free. Starting Installation ..."
    fi
}

if [ "$EUID" -ne 0 ]
  then echo "Please use sudo while running this script !!!"
  exit 0
fi

is_port_free

mkdir prometheus_node_exporter_installation_2017
cd prometheus_node_exporter_installation_2017

echo "**** Downloading Node_Exporter ..."
wget https://github.com/prometheus/node_exporter/releases/download/v0.14.0/node_exporter-0.14.0.linux-amd64.tar.gz -O node_exporter-0.14.0.linux-amd64.tar.gz

echo "**** Extracting node_exporter-0.14.0.linux-amd64.tar.gz ..."
tar -xvzf node_exporter-0.14.0.linux-amd64.tar.gz

cd node_exporter-0.14.0.linux-amd64

echo "**** Making node_exporter start on system boot ..."

sudo mv node_exporter /usr/bin/

systemdFile="
 [Unit]
 \n
Description=Prometheus Node Exporter
\n
After=local-fs.target network.target network-online.target
\n
Wants=local-fs.target network-online.target network.target
\n\n
[Service]
\n
ExecStart=/usr/bin/node_exporter
\n
Type=simple
\n\n
[Install]
\n
WantedBy=multi-user.target\n
"

sudo echo -e $systemdFile > /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable node_exporter.service 
sudo systemctl start node_exporter.service 

echo "**** Checking Node Exporter Confuration ..."
sleep 1
sudo systemctl status node_exporter.service 

cd ../../
sudo rm -r prometheus_node_exporter_installation_2017

echo "**** Installed And Running Successfully On Port 9100 !!!"
