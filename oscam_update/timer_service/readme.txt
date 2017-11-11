cp * /usr/lib/systemd/system/

systemctl start softcam-update.timer
systemctl enable softcam-update.timer
## to check ##
systemctl is-active softcam-update.timer
#after start
journalctl -xe