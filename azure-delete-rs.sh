#!/bin/bash
#This script helps to remove resource groups from Azure subscription.
#This script helps to remove records from Azure DNS Zones.
#Make sure to be connected to the right subscription and then run the script.
#if you wish to remove all resource groups in a subscription please run the script as is. 
#if you need to delete only specific resource groups , please edit the list manually.
NC='\033[0m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
# set -x 

function delete-rs {
    for rs in ${RESOURCE_GROUPS[@]}
    do
        az group delete --resource-group ${rs} -y 2>/dev/null
        if [ $? == 0 ]
        then 
            echo -e "${GREEN}${rs} Deleted!${NC}"
        else
            echo -e "${RED}${rs} Not deleted yet , please check logs in console${NC}"
        fi

    done
}

function remove-dns-record {
    echo "Please provide dns zone"
    read dns_zone
    RECORDS=$(az network dns record-set list --resource-group admin --zone-name ${dns_zone} --query "[].name" | sed '1,3d' | sed 's/,/ /g')
    for record in ${RECORDS[@]}
    do
        record=$(echo ${record} | tr -d '"')
        echo -e "${YELLOW}Do you wish to remove ${record}${NC}(y/n)?"
        read answer
        if [ "${answer}" == "y" ]
        then
            record_types=( "a" "cname" "txt" )
            for record_type in ${record_types[@]}
            do
                az network dns record-set ${record_type} delete --resource-group admin --zone-name ${dns_zone} --name ${record} -y
            done
            if [ $? == 0 ]
            then
                echo -e "${GREEN}A record ${record} deleted!${NC}"
            else 
                echo -e "${RED}A record ${record} failed delete!${NC}"
            fi
        fi
    done

}

###Start Here###

# RESOURCE_GROUPS=$(az group list --query "[].name" | tr -d '\n' | sed 's/[][]//g') #uncomment to get list of all resource groups in a subscription 
RESOURCE_GROUPS=("test" "dev-test") #set resource groups manually.
delete-rs
remove-dns-record