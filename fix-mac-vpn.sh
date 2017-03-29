#!/usr/bin/env bash

echo “Killing racoon”
sudo killall racoon
echo “Killing configd”
sudo killall configd
echo “Killing mDNSResponder”
sudo killall mDNSResponder
echo “Killing nesessionmanager”
sudo killall nesessionmanager
echo “Killing networkd”
sudo killall networkd
