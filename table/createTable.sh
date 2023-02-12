#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true
do
    read -p "Enter Table Name: " table
    if [[ $table =~ ^([a-zA-Z]{3})[a-zA-Z0-9\w]*$ ]]
    then
        if [[ -e ../../DataBase/$db/$table ]]
        then
            echo "Sorry this table already exist.."
            echo "If you want to exit Enter (y) else Enter any key."
            read x
            if [[ $x = y ]]
            then
                clear
                break 
            fi
        else
            touch ../../DataBase/$db/MetaData$table
            touch ../../DataBase/$db/$table
            echo "Table created"

            # create columns
            echo "id:int" >> ../../DataBase/$db/MetaData$table

            while true
            do
                read -p "Please enter column name: " column
                if [[ $column =~ ^([a-zA-Z]{3})[a-zA-Z0-9\w]*$ ]]
                then
                    echo "Please choice column type: "
                    select type in "int" "string"
                    do
                    case $type in
                        "int")
                            echo "$column:$type" >> ../../DataBase/$db/MetaData$table
                            break
                        ;;
                        "string")
                            echo "$column:$type" >> ../../DataBase/$db/MetaData$table
                            break
                        ;;
                        *)
                            echo "Please Choice number from the list"
                        ;;
                    esac
                    done

                    echo "If you want to exit Enter (y) else Enter any key."
                    read x
                    if [[ $x = y ]]
                    then
                        clear
                        break 
                    fi
                else
                    echo "column name should be at least 3 characters and shouldn't start with number or contain special characters."
                    echo "If you want to exit Enter (y) else Enter any key."
                    read x
                    if [[ $x = y ]]
                    then
                        break
                    fi
                fi
            done

            break
        fi
    else
        echo "Table name should be at least 3 characters and shouldn't start with number or contain special characters."
        echo "If you want to exit Enter (y) else Enter any key."
        read x
        if [[ $x = y ]]
        then
            break
        fi
    fi
done