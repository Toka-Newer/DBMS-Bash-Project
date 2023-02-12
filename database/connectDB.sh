#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true
do
    read -p "Enter Database Name: " db
    if [[ $db =~ ^([a-zA-Z]{3})[a-zA-Z0-9\w]*$ ]]
    then
        if [[ -e ../../DataBase/$db ]]
        then
            cd ../table
            . ./tables.sh
            cd ../database
            break
        else
            echo "Database name doesn't exist."
            echo "If you want to exit Enter (y) else Enter any key."
            read x
            if [[ $x = y ]]
            then
                break
            fi
        fi
    else
        echo "Database name should be at least 3 characters and shouldn't start with number or contain special characters."
        echo "If you want to exit Enter (y) else Enter any key."
        read x
        if [[ $x = y ]]
        then
            break
        fi
    fi
done