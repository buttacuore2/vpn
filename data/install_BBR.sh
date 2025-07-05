#!/bin/bash
#Script Variables
PORT_TCP='1194'
PORT_UDP='2200'

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
apt install -y linux-generic-hwe-20.04
grub-set-default 0
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
INSTALL_BBR=true
sudo sysctl -p
sudo iptables -t nat -A POSTROUTING -o $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -s 10.20.0.0/16 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -s 10.30.0.0/16 -j MASQUERADE
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get install iptables-persistent -y
sudo iptables -t nat -A POSTROUTING -o $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -s 10.20.0.0/16 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -s 10.30.0.0/16 -j MASQUERADE

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

DEV=$(ip -4 route ls|grep default|grep -Po "(?<=dev )(\S+)"|head -1);

cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
sudo iptables -t nat -A POSTROUTING -o $DEV -s 10.20.0.0/16 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o $DEV -s 10.30.0.0/16 -j MASQUERADE
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo iptables -t nat -A POSTROUTING -o $DEV -s 10.20.0.0/16 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o $DEV -s 10.30.0.0/16 -j MASQUERADE
exit 0
END
sudo systemctl daemon-reload
sudo systemctl enable rc-local.service

