#!/bin/bash
#This script will disable Azure VM from auto updates.

#/etc/apt/apt.conf.d/50unattended-upgrades

sed -i 's+"${distro_id}:${distro_codename}-security";+//"${distro_id}:${distro_codename}-security";+g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's+"${distro_id}:${distro_codename}-updates";;+//"${distro_id}:${distro_codename}-updates";+g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's+"${distro_id}:${distro_codename}-proposed";+//"${distro_id}:${distro_codename}-proposed";+g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's+"${distro_id}:${distro_codename}-backports";+//"${distro_id}:${distro_codename}-backports";+g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's+"${distro_id}:${distro_codename}";+//"${distro_id}:${distro_codename}";+g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's+"${distro_id}ESMApps:${distro_codename}-apps-security";+//"${distro_id}ESMApps:${distro_codename}-apps-security";+g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's+"${distro_id}ESM:${distro_codename}-infra-security";+//"${distro_id}ESM:${distro_codename}-infra-security";+g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's+Unattended-Upgrade::DevRelease "auto";+Unattended-Upgrade::DevRelease "false";+g' /etc/apt/apt.conf.d/50unattended-upgrades

#/etc/apt/apt.conf.d/10periodic
sed -i 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/g' /etc/apt/apt.conf.d/10periodic
sed -i 's/APT::Periodic::Download-Upgradeable-Packages "1";/APT::Periodic::Download-Upgradeable-Packages "0";/g' /etc/apt/apt.conf.d/10periodic
sed -i 's/APT::Periodic::AutocleanInterval "1";/APT::Periodic::AutocleanInterval "0";/g' /etc/apt/apt.conf.d/10periodic
sed -i 's/APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "0";/g' /etc/apt/apt.conf.d/10periodic

#/etc/apt/apt.conf.d/20auto-upgrades
sed -i 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/g' /etc/apt/apt.conf.d/20auto-upgrades
sed -i 's/APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "0";/g' /etc/apt/apt.conf.d/20auto-upgrades

