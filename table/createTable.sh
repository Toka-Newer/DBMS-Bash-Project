#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true
do
    read -p "Enter Table Name: " table
    if [[ -e ../../DataBase/$db/$table ]]
    then
        echo "Sorry this table already exist.."
        break 2
    elif [[ $table = +([*a-zA-z0-9]) ]]
    then

        touch ../../DataBase/$db/MetaData$table
        touch ../../DataBase/$db/$table
        echo "Table created"
        
        #######################################
        # create columns
        #######################################

        echo "id:int" >> ../../DataBase/$db/MetaData$table

        while true
        do
            read -p "Please enter column name: " column
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

            echo "If you want to exit enter y else if you want to enter new column enter n."
            read x
            if [[ $x = y ]]
            then
                break 
            fi

        done

        break 2
    else
        echo "Table name shouldn't start with number or contain special characters."
        echo "If you want to exit enter y else if you want to enter new name enter n."
        read x
        if [[ $x == y ]]
        then
            clear
            break 2
        fi
    fi
done