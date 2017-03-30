#!/bin/bash

set -ex

: ${LISTENPORT:=30303}
D4=$LISTENPORT
D5=$(($LISTENPORT+1))

iptables -F
iptables -N disc_tcp_out
iptables -A disc_tcp_out -j ACCEPT -m comment --comment "bw:p2p_tcp_out"
iptables -N disc_tcp_in
iptables -A disc_tcp_in -j ACCEPT -m comment --comment "bw:p2p_tcp_in"
iptables -N disc_udp_out
iptables -A disc_udp_out -j ACCEPT -m comment --comment "bw:p2p_udp_out"
iptables -N disc_udp_in
iptables -A disc_udp_in -j ACCEPT -m comment --comment "bw:p2p_udp_in"
iptables -N oob_out
iptables -A oob_out -j ACCEPT -m comment --comment "bw:oob_out"
iptables -N oob_in
iptables -A oob_in -j ACCEPT -m comment --comment "bw:oob_in"
iptables -N bw_out
iptables -A bw_out -j ACCEPT -m comment --comment "bw:bw_out"
iptables -N bw_in
iptables -A bw_in -j ACCEPT -m comment --comment "bw:bw_in"
iptables -N dns_out
iptables -A dns_out -j ACCEPT -m comment --comment "bw:dns_out"

iptables -A INPUT -p tcp -m multiport --dport 28589 -m state --state ESTABLISHED -j oob_in -m comment --comment "bwx:oob_in"
iptables -A INPUT -p tcp -m multiport --dport 4514 -m state --state ESTABLISHED -j bw_in -m comment --comment "bwx:bw2_in"
iptables -A INPUT -p tcp -m multiport --dport $D4,$D5,30302,30303,30200:30299 -m state --state ESTABLISHED -j disc_tcp_in -m comment --comment "bwx:disc_tcp_in"
iptables -A INPUT -p tcp -m multiport --dport 30304 -m state --state ESTABLISHED -j disc_tcp_in -m comment --comment "bwx:discv5_tcp_in"
iptables -A INPUT -p tcp -m multiport --sport $D4,$D5,30304,30400:30499 -m state --state ESTABLISHED -j disc_tcp_in -m comment --comment "bwx:discv5_tcp_src_in"
iptables -A INPUT -p tcp -m multiport --sport 30300:30399 -m state --state ESTABLISHED -j disc_tcp_in -m comment --comment "bwx:discv5_misc_src_in"
iptables -A INPUT -p tcp -m multiport --dport 7700:7799 -j ACCEPT -m comment --comment "bwx:stats_in"
iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT -m comment --comment "bw:untracked_tcp_in"
iptables -A INPUT -p tcp -j ACCEPT -m comment --comment "bwx:untracked_tcp_noest_in"

iptables -A INPUT -p udp --dport $D4 -j disc_udp_in -m comment --comment "bwx:disc_udp_in"
iptables -A INPUT -p udp --dport $D5 -j disc_udp_in -m comment --comment "bwx:discv5_udp_in"
iptables -A INPUT -p udp -j ACCEPT -m comment --comment "bw:untracked_udp_in"

iptables -A OUTPUT -p tcp --sport 28589 -m state --state ESTABLISHED -j oob_out -m comment --comment "bwx:oob_src_out"
iptables -A OUTPUT -p tcp --sport 4514 -m state --state ESTABLISHED -j bw_out -m comment --comment "bwx:bw2_src_out"
iptables -A OUTPUT -p tcp --sport $D4 -m state --state ESTABLISHED -j disc_tcp_out -m comment --comment "bwx:disc_tcp_src_out"
iptables -A OUTPUT -p tcp --sport $D5 -m state --state ESTABLISHED -j disc_tcp_out -m comment --comment "bwx:discv5_tcp_src_out"
iptables -A OUTPUT -p tcp --sport 7777 -j ACCEPT -m comment --comment "bwx:stats_src_out"

iptables -A OUTPUT -p tcp -m multiport --dport 28500:28599 -m state --state ESTABLISHED -j oob_out -m comment --comment "bwx:oob_out"
iptables -A OUTPUT -p tcp -m multiport --dport 4500:4599 -m state --state ESTABLISHED -j bw_out -m comment --comment "bwx:bw2_out"
iptables -A OUTPUT -p tcp -m multiport --dport $D4,$D5,30302,30200:30299 -m state --state ESTABLISHED -j disc_tcp_out -m comment --comment "bwx:disc_tcp_out"
iptables -A OUTPUT -p tcp -m multiport --dport 30304,30400:30499 -m state --state ESTABLISHED -j disc_tcp_out -m comment --comment "bwx:discv5_tcp_out"
iptables -A OUTPUT -p tcp -m multiport --dport 30300:30399 -m state --state ESTABLISHED -j disc_tcp_out -m comment --comment "bwx:misc_tcp_out"
iptables -A OUTPUT -p tcp -m multiport --dport 7700:7799 -j ACCEPT -m comment --comment "bwx:stats_out"
iptables -A OUTPUT -p tcp -m state --state ESTABLISHED -j ACCEPT -m comment --comment "bw:untracked_tcp_out"
iptables -A OUTPUT -p tcp -j ACCEPT -m comment --comment "bwx:untracked_tcp_noest_out"

iptables -A OUTPUT -p udp -m multiport --dport 30200:30299 -j disc_udp_out -m comment --comment "bwx:disc_udp_out"
iptables -A OUTPUT -p udp -m multiport --dport 30400:30499 -j disc_udp_out -m comment --comment "bwx:discv5_udp_out"
iptables -A OUTPUT -p udp -m multiport --dport 30300:30399 -j disc_udp_out -m comment --comment "bwx:misc_udp_out"
iptables -A OUTPUT -p udp -m multiport --sport $D4,$D5,30300:30399 -j disc_udp_out -m comment --comment "bwx:misc_udp_src_out"
iptables -A OUTPUT -p udp -m multiport --dport 53 -j dns_out -m comment --comment "bwx:dns_udp_out"
iptables -A OUTPUT -p udp -m multiport --sport 53 -j dns_out -m comment --comment "bwx:dns_udp2_out"
iptables -A OUTPUT -p udp -j ACCEPT -m comment --comment "bw:untracked_udp_out"

if [[ "$NET_BW" != "" ]]
then
    if [[ "$NET_DELAY" != "" ]]
    then
        tc qdisc add dev eth0 root netem delay $NET_DELAY rate $NET_BW 
    else
        tc qdisc add dev eth0 root netem rate $NET_BW
    fi
fi

export BW2_HACKY_IPTABLES_EP=y
cd /root
IP=$(ifconfig eth0 | grep "inet addr:" | cut -d : -f 2 | cut -d " " -f 1)
echo "{\"endpoint\":\"http://${IP}:7777/metrics\"}" > /var/metrics.json
cat /var/metrics.json
if [ ! -e bw2.ini ]
then
  : ${MINERTHREADS:=0}
  : ${MINERBENIFICIARY:=0xe244fc97fbc0819a508cb02a7bbd9495a07eedf4}
  : ${MAXPEERS:=20}
  : ${MAXLIGHTPEERS:=0}
  bw2 makeconf --maxpeers $MAXPEERS --maxlightpeers $MAXLIGHTPEERS  --externalip "${EXTERNALIP}" --listenport "${LISTENPORT}" --listenglobal --minerthreads=${MINERTHREADS} --benificiary=${MINERBENIFICIARY} ${BW2_MAKECONF_OPTS}
fi
cat bw2.ini
set +ex
export GOGC=40
while true
do
  bw2 router
  echo "XXX XTAG HARD RESET"
done
