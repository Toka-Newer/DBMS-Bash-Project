#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 

    while true
    do
        PS3="Choice a Number: "
        select choice in "Create Table" "List Tables" "Drop Table" "Insert Into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
        do
        case $choice in
            "Create Table")
                . ./createTable.sh
                break
            ;;
            "List Tables")
                . ./listTable.sh
                break
            ;;
            "Drop Table")
                . ./dropTable.sh
                break
            ;;
            "Insert Into Table")
                . ./insertTable.sh
                break
            ;;
            "Select From Table")
                . ./selectTable.sh
                break
            ;;
            "Delete From Table")
                . ./deleteTable.sh
                break
            ;;
            "Update Table")
                . ./updateTable.sh
                break
            ;;
            "Exit")
                clear
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
