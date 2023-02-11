#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true 
do
    read -p "Please enter table name: " Tname
    if [[ -e ../../DataBase/$db/$Tname ]] && [[ -e ../../DataBase/$db/MetaData$Tname ]]
    then
        clear
        nrTable=`awk 'END{print NR}' ../../DataBase/$db/MetaData$Tname;` 
        # get columns names
        declare -a arrayColumn=()
        for (( i=2 ; i<=$nrTable ; i++ )); do
            arrayColumn+=(`awk -F: -v"i=$i" '{if(NR==i){print $1}}' ../../DataBase/$db/MetaData$Tname;`)
        done
        
        while true
        do
            select column in "${arrayColumn[@]}" "Exit"
            do
            case $column in                                    
                "Exit")
                    break 2
                ;;
                $column)

                    select update in "Specific id" "All Data" "Exit"
                    do
                        case $update in                                    
                            "Specific id")
                                read -p "enter the value of $update please: " colValue
                                read -p "enter the new value of $column please: " newValue

                                # know column number
                                for i in "${!arrayColumn[@]}"; do
                                    if [[ "${arrayColumn[$i]}" = "${column}" ]]; then
                                        x=${i}
                                        x=$((x+2))
                                        break
                                    fi
                                done

                                # nfData=`awk -F: 'END{print NF}' ../../DataBase/$db/$Tname;` 
                                
                                awk -F: -v"colValue=$colValue" -v"newValue=$newValue" -v"x=$x" -v"nfData=$nfData" '
                                {
                                    if($1==colValue){
                                        
                                        $x=newValue
                                        
                                    }
                                    {print}
                                }'  ../../DataBase/$db/$Tname > ../../DataBase/$db/tmp && mv ../../DataBase/$db/tmp ../../DataBase/$db/$Tname

                                sed -i 's/'" "'/'":"'/g' ../../DataBase/$db/$Tname

                                echo "updated"

                                    # sed -i "${nrDel[$i]}"'d' ../../DataBase/$db/$Tname

                                break
                            ;;
                            "All Data")
                                read -p "enter the value of $column please: " colValue
                                read -p "enter the new value of $column please: " newValue

                                # know column number
                                for i in "${!arrayColumn[@]}"; do
                                    if [[ "${arrayColumn[$i]}" = "${column}" ]]; then
                                        x=${i}
                                        x=$((x+1))
                                        break
                                    fi
                                done

                                sed -i 's/'"$colValue"'/'"$newValue"'/g' ../../DataBase/$db/$Tname
                                
                                break
                            ;;
                            "Exit")
                                break 2
                            ;;
                        esac
                    done                    
                    break
                ;;
                *)
                    echo "please choice a number"
                    break
                ;;
            esac
            done
        done
        
        break
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
