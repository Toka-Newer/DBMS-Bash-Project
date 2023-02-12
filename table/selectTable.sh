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
            # array length
            length=${#arrayColumn[*]}

            clear
            while true
            do
                select select in "All Data" "Selection" "Projection" "Exit"
                do
                    case $select in
                        "All Data")
                            clear
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
                                    break
                                ;;
                                $column)
                                    read -p "enter the value of $column please: " colValue
                                    echo ""
                                    clear
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

                                    # know column number
                                    for i in "${!arrayColumn[@]}"; do
                                        if [[ "${arrayColumn[$i]}" = "${column}" ]]; then
                                            x=${i}
                                            x=$((x+1))
                                            break
                                        fi
                                    done
                                    declare -a showRecord=()
                                    showRecord+=(`awk -F: -v"colValue=$colValue" -v"x=$x" '{if( $x == colValue ){print $0; }}' ../../DataBase/$db/$Tname;`)

                                    for i in "${!showRecord[@]}"; do
                                        echo ${showRecord[$i]}
                                    done

                                    echo ""
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
                                    clear
                                    break
                                ;;
                                $column)
                                    clear
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
                            esac
                            done

                            break
                        ;;
                        "Exit")
                            clear
                            break 3
                        ;;
                        *)
                            clear
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
                break 2
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