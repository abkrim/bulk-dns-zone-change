#!/usr/bin/env bash
# Script for change nameservers on all zones, and update serial zone
# You can use for other pourposes
# Script need
# 1 - old nameserver domain (FQDN, not host) domain.com OK | ns1.domain.com Not OK
# 2 - new nameserver domain (FQDN, not host) domain.com OK | ns1.domain.com Not OK
# 3 - prefix of hots namaserer such ns, dns, (not prefix + number)


if [ "$#" -ne 3 ]; then
    echo "Ilegal number of parameters. Read script comments"
    exit
fi


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
oldnameserver=$1
newnameserver=$2
prefix=$3

echo -e "You like change old nameservers ${RED}${3}1.${1}${NC} for ${GREEN}${3}1.${2}${NC} and  ${RED}${3}2.${1}${NC} for ${GREEN}${3}2.${2}${NC}"
echo
echo
echo "Please READ BY CAREFULLY and after continue"
echo
echo "Script create a backup of actual zones on /var/named.backup"
echo -e "${RED}"
read -p "Are you sure? Y|N " -n 1 -r
echo -e "${NC}"
if [[ $REPLY =~ ^[Yy]$ ]]
then
    cp -rpf /var/named /var/named.backup
    replace $1 $2 -- /var/named/*.db
    grep "serial, todays" /var/named/*.db | sed "s/://g" | cut -d/ -f4 | awk {'system("replace "$2" "strftime("%Y%m%d")"00 -- /var/named/"$1)'}
fi


