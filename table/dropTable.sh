#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true
do
    read -p "Enter Table Name: " table
    if [[ -e ../../DataBase/$db/$table ]]  && [[ -e ../../DataBase/$db/MetaData$table ]]
    then
        rm ../../DataBase/$db/$table
        rm ../../DataBase/$db/MetaData$table
        echo "Table deleted."
        break 2
    else
        echo "Table name doesn't exist."
        echo "If you want to exit enter y else if you want to enter new name enter n."
        read x
        if [[ $x = y ]]
        then
            break 2
        fi
    fi
done