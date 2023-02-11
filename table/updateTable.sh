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
        declare -a ids=()
        ids+=(`awk -F: '{print $1}' ../../DataBase/$db/$Tname;`)
        # get columns names
        declare -a arrayColumn=()
        for (( i=2 ; i<=$nrTable ; i++ )); do
            arrayColumn+=(`awk -F: -v"i=$i" '{if(NR==i){print $1}}' ../../DataBase/$db/MetaData$Tname;`)
        done
        length=${#arrayColumn[*]}

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
                                
                                if [[ $colValue != 0 && " ${ids[@]} " =~ " $colValue " ]]
                                then

                                    read -p "enter the new value of $column please: " newValue

                                    # know column number
                                    for i in "${!arrayColumn[@]}"; do
                                        if [[ "${arrayColumn[$i]}" = "${column}" ]]; then
                                            x=${i}
                                            x=$((x+2))
                                            break
                                        fi
                                    done
                                    
                                    awk -F: -v"colValue=$colValue" -v"newValue=$newValue" -v"x=$x" '
                                    {
                                        if($1==colValue){
                                            $x=newValue
                                        }
                                        {print}
                                    }'  ../../DataBase/$db/$Tname > ../../DataBase/$db/tmp && mv ../../DataBase/$db/tmp ../../DataBase/$db/$Tname
                                    
                                    sed -i 's/'" "'/'":"'/g' ../../DataBase/$db/$Tname
                                    echo ""
                                    echo "updated"
                                    echo ""
                                else
                                    echo "value not exist"
                                fi

                                break
                            ;;
                            "All Data")
                                read -p "enter the value of $column please: " colValue

                                NRTable=`awk 'END{print NR}' ../../DataBase/$db/$Tname;` 
                                declare -a columnValue=()
                                for (( i=1 ; i<=$NRTable ; i++ )); do
                                    columnValue+=(`awk -F: -v"i=$i" -v"x=$x" '{if(NR==i){print $x}}' ../../DataBase/$db/$Tname;`)
                                done

                                if [[ $colValue != 0 && " ${columnValue[@]} " =~ " $colValue " ]]
                                then

                                    read -p "enter the new value of $column please: " newValue

                                    # know column number
                                    for i in "${!arrayColumn[@]}"; do
                                        if [[ "${arrayColumn[$i]}" = "${column}" ]]; then
                                            x=${i}
                                            x=$((x+2))
                                            break
                                        fi
                                    done

                                    sed -i 's/'"$colValue"'/'"$newValue"'/g' ../../DataBase/$db/$Tname
                                    echo ""
                                    echo "updated"
                                    echo ""
                                else
                                    echo "value not exist"
                                    echo ""
                                    echo "please choice again"
                                    echo ""
                                fi

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
                    clear
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
