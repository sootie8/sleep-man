#!/bin/bash
systemctl stop log-last-arp;
systemctl stop sleep-man;
systemctl disable log-last-arp;
systemctl disable sleep-man;
cp ./log-last-arp.service /usr/lib/systemd/system/;
cp ./sleep-man.service /usr/lib/systemd/system/;
systemctl daemon-reload;
systemctl enable log-last-arp;
systemctl enable sleep-man;
systemctl start log-last-arp;
systemctl start sleep-man;
