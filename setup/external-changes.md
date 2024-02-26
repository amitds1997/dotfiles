# Changes outside the home directory

01. Set `KillUserProcesses=true` on user logout in /etc/systemd/logind.conf.
02. Created /etc/X11/xorg.conf.d/30-touchpad.conf
03. Enabled following systemd services
    1. bluetooth.service
    2. nvidia-powerd.service
04. Enabled `reflector.service` and `reflector.timer`. Updated `/etc/xdg/reflector/reflector.conf`
    with correct parameters to update the mirrorlist at `/etc/pacman.d/mirrorlist`
05. Added the file /etc/modprobe.d/nvidia.conf
06. Added `nvidia_drm.modeset=1` in `/boot/loader/entries/2024-02-04_12-50-56_linux.conf`
07. Masked `systemd-rfkill.service` and `systemd-rfkill.socket` as per ArchLinux docs for TLP.
08. Uncommented `Color` in /etc/pacman.conf
09. Created a hook at `/etc/pacman.d/hooks/50-pacman-list.hook` for syncing all packages
10. Uncommented `tlp-rdw` params in `/etc/tlp.conf`
