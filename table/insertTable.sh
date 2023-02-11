#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true
do
    read -p "Enter Table Name: " table
    if [[ -e ../../DataBase/$db/$table ]] && [[ -e ../../DataBase/$db/MetaData$table ]]
    then
    ####################################
        # insert into table
    ####################################

        nr=`awk -F: 'END{print $1}' ../../DataBase/$db/$table;`
        # echo $nr
        nr=$((nr+1))
        
        awk -F : '
        BEGIN{print $1} 
        {
            if($1 == "id"){
                printf '$nr' >> "../../DataBase/'$db'/'$table'"
                
            }else{
                printf "Please enter " $1 " value: "
                getline value < "-" 
            }
        }
        $2 == "int"{
            if(NR==1){

            }else if(value~"[0-9]"){
                printf ":"value >> "../../DataBase/'$db'/'$table'"
            }else {
                f=1;
                while (f){
                    print "please enter a valid value"
                    getline new < "-"
                    if(new~"[0-9]"){
                        printf ":"value >> "../../DataBase/'$db'/'$table'"
                        f=0
                    }
                }
            }
        }
        $2 == "string" {
            if (value~"[a-zA-z]"){
                printf ":"value >> "../../DataBase/'$db'/'$table'"
            }else {
                f=1;
                while (f){
                    print "please enter a valid value"
                    getline new < "-"
                    if(new~"[a-zA-z]"){
                        printf ":"value >> "../../DataBase/'$db'/'$table'"
                        f=0
                    }
                }
            }
        }
        END{} ' ../../DataBase/$db/MetaData$table
        
        echo "" >> "../../DataBase/$db/$table"
        sed -i 's/'" "'/'""'/g' ../../DataBase/$db/$table

        break 2

    else
        echo "Table name doesn't exist."
        echo "If you want to exit enter y else if you want to enter new name enter n."
        read x
        if [[ $x = y ]]
        then
            clear
            break 2
        fi
    fi
done