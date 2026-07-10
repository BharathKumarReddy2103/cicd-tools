#!/bin/bash
set -euxo pipefail

# Resize disk
growpart /dev/nvme0n1 4

lvextend -L +10G /dev/RootVG/rootVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

xfs_growfs /
xfs_growfs /var
xfs_growfs /var/tmp

# Jenkins Repository
curl -L -o /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/rpm-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Java
dnf install -y fontconfig java-21-openjdk

# Refresh repositories
dnf clean all
dnf makecache

# Install Jenkins
dnf install -y jenkins

# Start Jenkins
systemctl daemon-reload
systemctl enable --now jenkins
systemctl is-active jenkins