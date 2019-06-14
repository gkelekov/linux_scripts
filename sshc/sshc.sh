#!/bin/bash

# Bash SSH Menu
##########################################################################################
# Install jq as this script is using settings from it's MANDATORY json file ".sshconfig" #
# Edit settings in ".sshconfig" file. 							 #
# Dependencies: sshpass (https://linux.die.net/man/1/sshpass)				 #
#		jq (https://stedolan.github.io/jq/)					 #
# Created by Goran Kelekovic                                                             #
##########################################################################################

## Configuration file location
config=(".sshconf")

#### List of avalible DC's read from config file; adding exit link; DC array lenght
dc=($( jq -r '.dc[]| .dcname ' $config ))
dc+=($( jq -r '.exit[] | .servername' $config ))

dcLen=$(expr ${#dc[@]} - 1) 

## Various texts and helpers
echo -e "\n───────────────────────────\nSSH Quick Connect\n                   by Skela\n---------------------------\n$dcLen Data Centers Available\n───────────────────────────"

## General text displayed after every select
PS3=$(echo -e "───────────────────────────\nSelect number to connect: ") 

nok () {
    echo -e "\n✘ Not valid option. Please try again.\n  ▔▔▔▔▔▔▔▔▔"
}
exit () {
    echo -e "Script exited."
}

## Populate server, ip and witch user to use for particular DC
## Lists are regenerated for every DC from begining
## All data is stored in ".sshconfig" json file
addLists () {
            server=()
            ip=()
            user=()
            # Calculate length of array of servers for any particular DC
            temp=$( jq -r '.'$1' | length' $config )
            dcLength=$(($temp -1))
            # Check if list of DC servers is 0, as this only happend if there is single server
            # If there are more servers, iterate until finished adding to lists
            if [ $dcLength -eq 0 ]
                    then
	                server=($( jq -r '.'$1'[] | select(.id=="server0") | .servername' $config ))
                        ip=($( jq -r '.'$1'[] | select(.id=="server0") | .serverip' $config ))
                        user=($( jq -r '.'$1'[] | select(.id=="server0") | .serveruser' $config ))
                elif [ $dcLength -ge 0 ]
                    then
                        for i in `seq 0 $dcLength`;
                        do 
	                    server+=($( jq -r '.'$1'[] | select(.id=="server'$i'") | .servername' $config ))
                            ip+=($( jq -r '.'$1'[] | select(.id=="server'$i'") | .serverip' $config ))
                            user+=($( jq -r '.'$1'[] | select(.id=="server'$i'") | .serveruser' $config ))
                        done 
                else
                    echo "Something has gone terribly wrong."
            fi
            ## Adding exit "server"
            server+=($( jq -r '.exit[] | .servername' $config ))
}

## Connect to server function
## Takes 3 arguments: 	$1 - serveruser (identifies whitch user to be used)
##			$2 - servername (identifies whitch server we are connecting to)
##			$3 - serverip (gets IP address or DNS for connection)

connectServer () {
                if [ $1 -eq 0 ]
                    then
                        echo "Connecting as $( jq -r '.conn.username' $config ) to $2"
                        # sshpass adding pass from config file; adding username from config file
			sshpass -p $( jq -r '.conn.password' $config ) ssh $( jq -r '.conn.username' $config )@$3
                        break
                elif [ $1 -eq 1 ]
                    then
                        echo "Connecting as $( jq -r '.conn.username2' $config ) to $2"
                        # getting key location from config file; adding username from config file
                        ssh -i $( jq -r '.conn.username2key' $config ) $( jq -r '.conn.username2' $config )@$3
                        break
                else
                    echo "No user or server arguments provided, or arguments invalid."
                fi
            }

# Display all DC's avalible and add number to the begginging of every selectable DC
# Switch statement than checks what has been selected and connects to proper DC
# Then server within this DC's are displayed and user chan select to witch to connect to
select dc in "${dc[@]}"
do
    case $dc in
        # Get DC name from config  
        "$(jq -r '.dc[]| select(.id=="dc0") | .dcname ' $config)") #get name from config
            echo -e "\n$(jq -r '.dc[]| select(.id=="dc0") | .dcinfo ' $config)\n───────────────────────────"
            
            # Insert into server, ip and user lists
            addLists "$(jq -r '.dc[]| select(.id=="dc0") | .dcname ' $config)"

            select opt in "${server[@]}"
                do
                    case $opt in
                        "${server[0]}")
                                connectServer ${user[0]} ${server[0]} ${ip[0]}
                                ;;
                        "✖")
                                exit
                                break
                                ;;
                        *) nok;;
                    esac
                done
            break
            ;;
        # Get DC name from config  
        "$(jq -r '.dc[]| select(.id=="dc1") | .dcname ' $config)") #get name from config
            echo -e "\n$(jq -r '.dc[]| select(.id=="dc1") | .dcinfo ' $config)\n───────────────────────────"

            # Insert into server, ip and user lists
            addLists "$(jq -r '.dc[]| select(.id=="dc1") | .dcname ' $config)"

            select opt in "${server[@]}"
                do
                    case $opt in
                        "${server[0]}")  
                                connectServer ${user[0]} ${server[0]} ${ip[0]}
				;;
                        "${server[1]}") 
                                connectServer ${user[1]} ${server[1]} ${ip[1]}
                                ;;
                        "${server[2]}") 
                                connectServer ${user[2]} ${server[2]} ${ip[2]}
                                ;;
                        "✖")   
                                exit
                                break
                                ;;
                        *) nok;;
                    esac
                done
            break
            ;;
        # Get DC name from config  
        "$(jq -r '.dc[]| select(.id=="dc2") | .dcname ' $config)")
            echo -e "\n$(jq -r '.dc[]| select(.id=="dc2") | .dcinfo ' $config)\n───────────────────────────"

            # Insert into server, ip and user lists
            addLists "$(jq -r '.dc[]| select(.id=="dc2") | .dcname ' $config)"

            select opt in "${server[@]}"
                do
                    case $opt in
                        "${server[0]}")  
                                connectServer ${user[0]} ${server[0]} ${ip[0]}
                                ;;
                        "${server[1]}") 
                                connectServer ${user[1]} ${server[1]} ${ip[1]}
                                ;;
                        "${server[2]}")
                                connectServer ${user[2]} ${server[2]} ${ip[2]}
                                ;;
                        "${server[3]}")  
                                connectServer ${user[3]} ${server[3]} ${ip[3]}
                                ;;
                        "✖")   
                                exit
                                break
                                ;;
                        *) nok;;
                    esac
                done
            break
            ;;
        # Get DC name from config    
        "$(jq -r '.dc[]| select(.id=="dc3") | .dcname ' $config)") 
            echo -e "\n$(jq -r '.dc[]| select(.id=="dc3") | .dcinfo ' $config)\n───────────────────────────"

            # Insert into server, ip and user lists
            addLists "$(jq -r '.dc[]| select(.id=="dc3") | .dcname ' $config)"

            select opt in "${server[@]}"
                do
                    case $opt in
                        "${server[0]}")
                                connectServer ${user[0]} ${server[0]} ${ip[0]}
                                ;;
                        "✖")
                                exit
                                break
                                ;;
                        *) nok;;
                    esac
                done
            break
            ;;

"✖")
            exit
            break
            ;;
        *) nok;;
    esac
done

