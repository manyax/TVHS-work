1. Install postfix
 
pacman -S postfix
echo "[smtp.gmail.com]:587 user@gmail.com:password" > /etc/postfix/sasl_passwd
sudo chmod 400 /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd
cat /etc/ssl/certs/thawte_Primary_Root_CA.pem | sudo tee -a /etc/postfix/cacert.pem

cat <<EOF >> /etc/postfix/main.cf 
###Gmail
relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/postfix/cacert.pem
smtp_use_tls = yes
###
EOF

#Uncomment in /etc/postfix/aliases
## Person who should get root's mail. Don't receive mail as root!
#  root:           admin
## Basic system aliases -- these MUST be present
#  MAILER-DAEMON:  postmaster
#  postmaster:     admin

postalias /etc/postfix/aliases
newaliases

#Change display name on hts user in /etc/passwd #tvhssrv TVHS
hts:x:1337:91:tvhssrv TVHS:/home/hts:/bin/false

2.Copy email_boot.sh to /opt/script/email_boot.sh
3.Copt email-on-reboot.service to /etc/systemd/system/
4. Enable services 
systemctl enable postfix
systemctl enable email-on-reboot