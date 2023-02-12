#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true
do
    read -p "Enter Table Name: " table
    if [[ $table =~ ^([a-zA-Z]{3})[a-zA-Z0-9\w]*$ ]]
    then
        if [[ -e ../../DataBase/$db/$table ]] && [[ -e ../../DataBase/$db/MetaData$table ]]
        then
            while true 
            do
                nr=`awk -F: 'END{print $1}' ../../DataBase/$db/$table;`
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
                            printf "please enter a valid value: "
                            getline new < "-"
                            if(new~"[0-9]"){
                                printf ":"new >> "../../DataBase/'$db'/'$table'"
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
                            printf "please enter a valid value: "
                            getline new < "-"
                            if(new~"[a-zA-z]"){
                                printf ":"new >> "../../DataBase/'$db'/'$table'"
                                f=0
                            }
                        }
                    }
                }
                END{} ' ../../DataBase/$db/MetaData$table
                
                echo "" >> "../../DataBase/$db/$table"
                sed -i 's/'" "'/'""'/g' ../../DataBase/$db/$table

                echo ""
                echo "data inserted successfully"
                echo ""
                
                echo "If you want to exit Enter (y) else if you want to insert more enter any key."
                read x
                if [[ $x = y ]]
                then
                    clear
                    break
                fi

            done    

            break

        else
            echo "Table name doesn't exist."
            echo "If you want to exit Enter (y) else Enter any key."
            read x
            if [[ $x = y ]]
            then
                clear
                break
            fi
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