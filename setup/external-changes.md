# Changes outside the home directory

1. Set `KillUserProcesses=true` on user logout in /etc/systemd/logind.conf.
2. Create /etc/X11/xorg.conf.d/30-touchpad.conf
3. Enabled following systemd services
   1. bluetooth.service
   2. nvidia-powerd.service
4. Enabled `reflector.service`. Updated `/etc/xdg/reflector/reflector.conf`
   with correct parameters to update the mirrorlist at `/etc/pacman.d/mirrorlist`
5. Added the file /etc/modprobe.d/nvidia.conf
6. Add `nvidia_drm.modeset=1` to kernel parameters
