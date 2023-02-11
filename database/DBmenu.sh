#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 

while true
do
    PS3="Choice a Number: "
    select choice in "Create DB" "List DB" "Drop DB" "Connect DB" "Exit"
    do
    case $choice in
        "Create DB")
            . ./createDB.sh
            break
        ;;
        "List DB")
            . ./listDB.sh
            break
        ;;
        "Drop DB")
            . ./dropDB.sh
            break
        ;;
        "Connect DB")
            . ./connectDB.sh
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