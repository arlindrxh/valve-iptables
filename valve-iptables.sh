#-------------------------------------------------
created with love by Arlind Rexha ♥



#-------------------------------------------------
apt-get install iptables && apt-get install ipset



#-------------------------------------------------
#!/bin/bash
# Arlind Rexha. - Valve DDOS Protection
# Use this command line "chmod 777 valve.sh && ./valve.sh"
# The IPTABLES script has been created to keep the Valve Servers alive by Arlind Rexha.
# Your SSH port must be 22
# Your web applications must be 80 or 443
# File Transfer Port: 21
# There is a command line "-d valve" in the bash script, please change it by using your external ip address. For example; "-d 34.34.34.34" or whatever it is.

echo "VALVE RULES CREATED BY ARLIND REXHA HAS BEEN SUCCESSFULLY STARTED"
ipset create valve_allowed hash:ip hashsize 2097152 maxelem 40000000 timeout 259200

iptables -N VALVES -t raw
iptables -N VALVE -t raw

iptables -A PREROUTING -t raw -j VALVES

iptables -A VALVE -d <your_external_ip> -t raw -m set ! --match-set valve_allowed src -j VALVE

iptables -A VALVE -t raw -p tcp -m multiport --dports 21,22,80,443,27015:27030,27036:27037 -j RETURN
iptables -A VALVE -t raw -p udp --sport 53 -m length --length 750:65535 -j DROP
iptables -A VALVE -t raw -p udp ! --sport 53 -m hashlimit --hashlimit-upto 7/sec --hashlimit-burst 10 --hashlimit-mode dstip --hashlimit-name valve --hashlimit-htable-max 2000000 -m string --string "TSource" --algo kmp -j SET --add-set valve_allowed src
iptables -A VALVE -t raw -m set ! --match-set valve_allowed src -j DROP

echo "VALVE RULE SET HAS BEEN SUCCESSFULLY DONE"
Replace <your_external_ip> with your external IP address.


#--------------------------------------------
chmod 777 valve.sh && valve.sh




#--------------------------------------------
iptables -A VALVE -t raw -p udp --dport xxxxx -j DROP



#--------------------------------------------
ipset add valve_allowed <ip_address>
Replace <ip_address> with the IP address you want to add to the set.




#--------------------------------------------
TCP OPTIONS DROP&RATELIMIT
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT


#--------------------------------------------
iptables -A INPUT -p tcp --tcp-flags ALL ALL -m limit --limit 1/h -j ACCEPT

#--------------------------------------------
iptables -A INPUT -p tcp --tcp-flags ALL NONE -m limit --limit 1/h -j ACCEPT

#--------------------------------------------
iptables -A INPUT -p tcp --syn -m limit --limit 2/s --limit-burst 30 -j ACCEPT

#--------------------------------------------
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

#--------------------------------------------
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP

#--------------------------------------------
iptables-save
