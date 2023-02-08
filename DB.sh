#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 

if [[ -e ../DataBase ]]
then

# Database menu
    while true
    do
        PS3="Choice a Number: "
        select choice in "Create DB" "List DB" "Drop DB" "Connect DB" "Exit"
        do
        case $choice in
            "Create DB")
                while true
                do
                    read -p "Enter Database Name: " db
                    if [[ -e ../DataBase/$db ]]
                    then
                        echo "Sorry this Database already exist.."
                        break 2
                    elif [[ $db = +([*a-zA-z0-9]) ]]
                    then
                        mkdir ../DataBase/$db
                        echo "Database created"
                        break 2
                    else
                        echo "Database name shouldn't start with number or contain special characters."
                        echo "If you want to exit enter y else if you want to enter new name enter n."
                        read x
                        if [[ $x = y ]]
                        then
                            break 2
                        fi
                    fi
                done
                break
            ;;
            "List DB")
                echo "listed Databases"
                cd ../DataBase
                ls -F | grep /
                cd ../scripts
                break
            ;;
            "Drop DB")
                while true
                do
                    read -p "Enter Database Name: " db
                    if [[ -e ../DataBase/$db ]]
                    then
                        rm -r ../DataBase/$db
                        echo "Database deleted."
                        break 2
                    else
                        echo "Database name doesn't exist."
                        echo "If you want to exit enter y else if you want to enter new name enter n."
                        read x
                        if [[ $x = y ]]
                        then
                            break 2
                        fi
                    fi
                done
                break
            ;;
            "Connect DB")
                while true
                do
                    read -p "Enter Database Name: " db
                    if [[ -e ../DataBase/$db ]]
                    then
                        . ./tables.sh
                        # cd ../DataBase/$db
                        # echo "now you are connected to $db"



                        # cd ../../scripts
                        break 2
                    else
                        echo "Database name doesn't exist."
                        echo "If you want to exit enter y else if you want to enter new name enter n."
                        read x
                        if [[ $x = y ]]
                        then
                            break 2
                        fi
                    fi
                done
                break
            ;;
            "Exit")
                echo "thank you for using this program"
                break 2
            ;;
            *)
                echo "Please Choice number from the list"
                break
            ;;
        esac
        done
    done
else
    mkdir ../DataBase
fi