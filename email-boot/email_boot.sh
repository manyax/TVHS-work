#!/usr/bin/env bash
sleep 20
while true
do
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
CPU_L=$(top -b -d1 -n1|grep -i "Cpu0"|cut -d ' ' -f2-)
CPU_T=$(awk '{printf "%3.1fC\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp)
IPPUB=$(wget -qO- http://ip.manyax.net ; echo)
IPPRV=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)
HOSTNAME=$(hostname -f)
sleep 5
echo -e "${HOSTNAME} online. \nCPU load "${CPU_L}" \nCPU temp  : ${CPU_T} \nPublic IP address: ${IPPUB}\nLocal IP address: ${IPPRV}\n\n$(date +"%a %x %X")\n" |sudo -u hts mail -s "$HOSTNAME restarted" manyax@manyax.net
exit 0
else
sleep 5
fi
done
