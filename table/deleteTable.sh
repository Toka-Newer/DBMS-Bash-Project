#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true 
do
    read -p "Please enter table name: " Tname
    if [[ $Tname =~ ^([a-zA-Z]{3})[a-zA-Z0-9\w]*$ ]]
    then
        if [[ -e ../../DataBase/$db/$Tname ]] && [[ -e ../../DataBase/$db/MetaData$Tname ]]
        then
            nrTable=`awk 'END{print NR}' ../../DataBase/$db/MetaData$Tname;` 
            declare -a arrayColumn=()
            for (( i=1 ; i<=$nrTable ; i++ )); do
                arrayColumn+=(`awk -F: -v"i=$i" '{if(NR==i){print $1}}' ../../DataBase/$db/MetaData$Tname;`)
            done

            while true
            do
                select select in "All Data" "Specific Column" "Exit"
                    do
                    case $select in
                        "All Data")
                            sed -i 'd' ../../DataBase/$db/$Tname
                            echo ""
                            echo "all data deleted"
                            echo ""
                            break
                        ;;
                        "Specific Column")
                            select column in "${arrayColumn[@]}" "Exit"
                            do
                            case $column in                                    
                                "Exit")
                                    break
                                ;;
                                $column)
                                    read -p "enter the value of $column please: " colValue

                                    # know column number
                                    for i in "${!arrayColumn[@]}"; do
                                        if [[ "${arrayColumn[$i]}" = "${column}" ]]; then
                                            x=${i}
                                            x=$((x+1))
                                            break
                                        fi
                                    done
                                    
                                    NRTable=`awk 'END{print NR}' ../../DataBase/$db/$Tname;` 
                                    declare -a columnValue=()
                                    for (( i=1 ; i<=$NRTable ; i++ )); do
                                        columnValue+=(`awk -F: -v"i=$i" -v"x=$x" '{if(NR==i){print $x}}' ../../DataBase/$db/$Tname;`)
                                    done

                                    if [[ $colValue != 0 && " ${columnValue[@]} " =~ " $colValue " ]]
                                    then

                                        declare -a nrDel=(`awk -F: -v"colValue=$colValue" -v"x=$x" '{if(colValue == $x){print NR}}' ../../DataBase/$db/$Tname;`)
                                    
                                        length=${#nrDel[*]}
                                        length=$((length-1))

                                        check=0;
                                        for (( i=$length; i>=0; --i ))
                                        do
                                            sed -i "${nrDel[$i]}"'d' ../../DataBase/$db/$Tname
                                        done

                                        echo ""
                                        echo "deleted"
                                        echo ""

                                    else
                                        echo ""
                                        echo "value not exist"
                                        echo ""
                                    fi
                                    
                                    break
                                ;;
                                *)
                                    echo "please choice a number"
                                    break
                                ;;
                            esac
                            done
                            
                            break
                        ;;
                        "Exit")
                            clear
                            break 3
                        ;;
                        *)
                            echo "Please Choice number from the list"
                        ;;
                    esac
                done
            done
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
            clear
            break
        fi
    fi
done