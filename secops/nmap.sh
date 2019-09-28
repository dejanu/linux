#run it from shell
for i in $(ls /usr/share/nmap/scripts | grep smb | grep vuln); do nmap --script=$i <ip_addr>; done
