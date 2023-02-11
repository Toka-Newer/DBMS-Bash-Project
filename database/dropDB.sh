#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true
do
    read -p "Enter Database Name: " db
    if [[ -e ../../DataBase/$db ]]
    then
        rm -r ../../DataBase/$db
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