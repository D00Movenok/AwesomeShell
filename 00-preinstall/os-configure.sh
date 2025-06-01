#!/bin/bash

# disable KVM at boot and fix network interfaces naming
sudo sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="kvm.enable_virt_at_load=0 net.ifnames=0 biosdevname=0"/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
