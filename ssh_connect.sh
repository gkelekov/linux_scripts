#!/bin/bash
# Bash SSH Menu
# by Skela (Goran Kelekovic)

#### List of avalible DC's - insert your DC names
dc=("DC1" "DC1" "DC3" "✖")

dcLen=$(expr ${#dc[@]} - 1)                                             
echo -e "────────────────────────\n$dcLen Data Centers Available\n────────────────────────"
#### General text displayed after every select
PS3=$(echo -e "───────────────────────────\nSelect number to connect: ") 

#### Add your usernames for connecting to servers
users=("username1" "username2")

# Helper functions
nok () {
    echo -e "\n✘ Not valid option. Please try again.\n  ▔▔▔▔▔▔▔▔▔"
}

exit () {
    echo -e "Exiting..."
}


# Display all DC's avalible and add number to the begginging of every selectable DC
# Switch statement than checks what has been selected and connects to proper DC
# Then servers within this DC's are displayed and user chan select to witch to connect to
select dc in "${dc[@]}"
do
    case $dc in
        "DC1")
            #### Your named text displayed after DC selected
            echo -e "\nDC1 info\n───────────────"
            #### List of your servers inside of DC - insert your server names
            # Note: Name inside list must be the same as in switch cases
            servers=(
                "Server1"
                "Server2"
                "Server3"
                "✖")
            #### List of IP or DNS addreses of your servers (sorry Bash does not support 2D array)
            # NOTE: position of IP must be in same order as servers
            ip=(
                "10.0.0.0"
                "server2.companydns.com"
                "192.168.0.1"
            )
            # Connection using 2 attributes, first is id from list "users", second is id from "servers" and "ip" lists
            connect_server () {
                if [ $1 -eq 0 ]
                    then
                        echo "Connecting as '${users[0]}' to ${servers["$2"]}"
                        ssh ${users[0]}@${ip[$2]}
                        break
                elif [ $1 -eq 1 ]
                    then
                        echo "Connecting as '${users[1]}' to ${servers[$2]}"
                        ssh -i /Users/${users[0]}/.ssh/${users[1]}.key ${users[1]}@${ip[$2]}
                        break
                else
                    echo "No user or server arguments provided."
                fi
            }
            
            select opt in "${servers[@]}"
                do
                    case $opt in
                    #### Add new server and attributes, first atribute is whitch user to use, 
                    #### Second assribute is server and IP number (list ID numbers from servers and ip lists)
                        "${servers[0]}")  
                                connect_server 0 0
                                ;;
                        "${servers[1]}") 
                                connect_server 0 1
                                ;;
                        "${servers[2]}") 
                                connect_server 1 2
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

        "DC2")
            #### Your named text displayed after DC selected
            echo -e "\DC info\n────────────"
            #### List of your servers inside of DC - insert your server names
            # Note: Name inside list must be the same as in switch cases
            servers=(
                "server1"
                "✖")
            #### List of IP or DNS addreses of your servers (sorry Bash does not support 2D array)
            # NOTE: position of IP must be in same order as servers
            ip=(
                "server1.companydns.com"
            )
            # Connection using 2 attributes, first is id from list "users", second is id from "servers" and "ip" lists
            connect_server () {
                if [ $1 -eq 0 ]
                    then
                        echo "Connecting as '${users[0]}' to ${servers["$2"]}"
                        ssh ${users[0]}@${ip[$2]}
                        break
                elif [ $1 -eq 1 ]
                    then
                        echo "Connecting as '${users[1]}' to ${servers[$2]}"
                        ssh -i /Users/${users[0]}/.ssh/${users[1]}.key ${users[1]}@${ip[$2]}
                        break
                else
                    echo "No user or server arguments provided."
                fi
            }

            select opt in "${servers[@]}"
                do
                    case $opt in
                    #### Add new server and attributes, first atribute is whitch user to use, 
                    #### Second assribute is server and IP number (list ID numbers from servers and ip lists)
                        "${servers[0]}")
                                connect_server 0 0
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
