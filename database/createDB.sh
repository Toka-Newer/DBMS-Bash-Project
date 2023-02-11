#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true
do
    read -p "Enter Database Name: " db
    if [[ -e ../../DataBase/$db ]]
    then
        echo "Sorry this Database already exist.."
        break 2
    elif [[ $db = +([*a-zA-z0-9]) ]]
    then
        mkdir ../../DataBase/$db
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