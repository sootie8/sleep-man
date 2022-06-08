#!/bin/bash
systemctl stop log-resume-time;
systemctl stop sleep-man;
systemctl disable log-resume-time;
systemctl disable sleep-man;
cp ./log-resume-time.service /usr/lib/systemd/system/;
cp ./sleep-man.service /usr/lib/systemd/system/;
systemctl daemon-reload;
systemctl enable log-resume-time;
systemctl enable sleep-man;
systemctl start log-resume-time;
systemctl start sleep-man;
