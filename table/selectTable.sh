#! /usr/bin/bash
export LC_COLLATE=C 
shopt -s extglob # Active Regex 
clear
while true 
do
    read -p "Please enter table name: " Tname
    if [[ -e ../../DataBase/$db/$Tname ]] && [[ -e ../../DataBase/$db/MetaData$Tname ]]
    then

        nrTable=`awk 'END{print NR}' ../../DataBase/$db/MetaData$Tname;` 
        declare -a arrayColumn=()
        for (( i=1 ; i<=$nrTable ; i++ )); do
            arrayColumn+=(`awk -F: -v"i=$i" '{if(NR==i){print $1}}' ../../DataBase/$db/MetaData$Tname;`)
        done
        length=${#arrayColumn[*]}
        clear
        while true
        do
            select select in "All Data" "Selection" "Projection" "Exit"
                do
                case $select in
                    "All Data")
                    echo ""
                        # show columns names
                        for i in "${!arrayColumn[@]}"  
                        do  
                            if [[ $i == $((length-1)) ]]
                            then 
                                echo -n "${arrayColumn[$i]}" 
                            else
                                echo -n "${arrayColumn[$i]}:"
                            fi
                        done 
                        echo ""
                        cat ../../DataBase/$db/$Tname
                        echo ""
                        break
                    ;;
                    "Selection")
                        clear
                        select column in "${arrayColumn[@]}" "Exit"
                        do
                        case $column in                                    
                            "Exit")
                                break 2
                            ;;
                            $column)
                                read -p "enter the value of $column please: " colValue
                                echo ""
                                # show columns names
                                for i in "${!arrayColumn[@]}"  
                                do  
                                    if [[ $i == $((length-1)) ]]
                                    then 
                                        echo -n "${arrayColumn[$i]}" 
                                    else
                                        echo -n "${arrayColumn[$i]}:"
                                    fi
                                done 
                                echo ""
                                
                                sed -n '/'$colValue'/p' ../../DataBase/$db/$Tname
                                echo ""
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
                    "Projection")
                        clear
                        select column in "${arrayColumn[@]}" "Exit"
                        do
                        case $column in                                    
                            "Exit")
                                break 2
                            ;;
                            $column)

                                for i in "${!arrayColumn[@]}"; do
                                    if [[ "${arrayColumn[$i]}" = "${column}" ]]; then
                                        x=${i}
                                        x=$((x+1))
                                        break
                                    fi
                                done
                                echo ""
                                echo $column
                                nrData=`awk 'END{print NR}' ../../DataBase/$db/$Tname;`
                                for (( i=1 ; i<=$nrData ; i++ )); do
                                    Data=(`awk -F: -v"i=$i" -v"x=$x" '{if(NR==i){print $x}}' ../../DataBase/$db/$Tname;`)
                                    echo $Data
                                done
                                echo ""
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
        echo "If you want to exit enter y else if you want to enter new name enter n."
        read x
        if [[ $x = y ]]
        then
            break 2
        fi
    fi
done