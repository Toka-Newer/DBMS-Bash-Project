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
                while true
                do
                    read -p "Enter Table Name: " table
                    if [[ -e ../DataBase/$db/$table ]]
                    then
                        echo "Sorry this table already exist.."
                        break 2
                    elif [[ $table = +([*a-zA-z0-9]) ]]
                    then

                        touch ../DataBase/$db/MetaData$table
                        touch ../DataBase/$db/$table
                        echo "Table created"
                        
                        #######################################
                        # create columns
                        #######################################

                        echo "id:int" >> ../DataBase/$db/MetaData$table

                        while true
                        do
                            read -p "Please enter column name: " column
                            echo "Please choice column type: "
                            select type in "int" "string"
                            do
                            case $type in
                                "int")
                                    # echo -n "$column:$type" >> ../DataBase/$db/MetaData$table
                                    echo "$column:$type" >> ../DataBase/$db/MetaData$table
                                    break
                                ;;
                                "string")
                                    # echo -n ":$column:$type" >> ../DataBase/$db/MetaData$table
                                    echo "$column:$type" >> ../DataBase/$db/MetaData$table
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
                        if [[ $x = y ]]
                        then
                            break 2
                        fi
                    fi
                done
                break
            ;;
            "List Tables")
                echo "listed Tables"
                cd ../DataBase/$db
                ls -F | grep -v / | grep -v Meta
                cd ../../scripts
                break
            ;;
            "Drop Table")
                while true
                do
                    read -p "Enter Table Name: " table
                    if [[ -e ../DataBase/$db/$table ]]  && [[ -e ../DataBase/$db/MetaData$table ]]
                    then
                        rm ../DataBase/$db/$table
                        rm ../DataBase/$db/MetaData$table
                        echo "Table deleted."
                        break 2
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
                break
            ;;
            "Insert Into Table")
                while true
                do
                    read -p "Enter Table Name: " table
                    if [[ -e ../DataBase/$db/$table ]] && [[ -e ../DataBase/$db/MetaData$table ]]
                    then
                    ####################################
                        # insert into table
                    ####################################

                        nr=`awk -F: 'END{print $1}' ../DataBase/$db/$table;`
                        # echo $nr
                        nr=$((nr+1))
                        
                        awk -F : '
                        BEGIN{print $1} 
                        {
                            if($1 == "id"){
                                printf '$nr' >> "../DataBase/'$db'/'$table'"
                                
                            }else{
                                printf "Please enter " $1 " value: "
                                getline value < "-" 
                            }
                        }
                        $2 == "int"{
                            if(NR==1){

                            }else if(value~"[0-9]"){
                                printf ":"value >> "../DataBase/'$db'/'$table'"
                            }else {
                                f=1;
                                while (f){
                                    print "please enter a valid value"
                                    getline new < "-"
                                    if(new~"[0-9]"){
                                        printf ":"value >> "../DataBase/'$db'/'$table'"
                                        f=0
                                    }
                                }
                            }
                        }
                        $2 == "string" {
                            if (value~"[a-zA-z]"){
                                printf ":"value >> "../DataBase/'$db'/'$table'"
                            }else {
                                f=1;
                                while (f){
                                    print "please enter a valid value"
                                    getline new < "-"
                                    if(new~"[a-zA-z]"){
                                        printf ":"value >> "../DataBase/'$db'/'$table'"
                                        f=0
                                    }
                                }
                            }
                        }
                        END{} ' ../DataBase/$db/MetaData$table
                        
                        echo "" >> "../DataBase/$db/$table"
                        sed -i 's/'" "'/'""'/g' ../DataBase/$db/$table

                        break 2

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
                break
            ;;
            "Select From Table")
                while true 
                do
                    read -p "Please enter table name: " Tname
                    if [[ -e ../DataBase/$db/$Tname ]] && [[ -e ../DataBase/$db/MetaData$Tname ]]
                    then

                        nrTable=`awk 'END{print NR}' ../DataBase/$db/MetaData$Tname;` 
                        declare -a arrayColumn=()
                        for (( i=1 ; i<=$nrTable ; i++ )); do
                            arrayColumn+=(`awk -F: -v"i=$i" '{if(NR==i){print $1}}' ../DataBase/$db/MetaData$Tname;`)
                        done
                        length=${#arrayColumn[*]}

                        while true
                        do
                            select select in "All Data" "Selection" "Projection" "Exit"
                                do
                                case $select in
                                    "All Data")
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
                                        cat ../DataBase/$db/$Tname
                                        break
                                    ;;
                                    "Selection")
                                        
                                        select column in "${arrayColumn[@]}" "Exit"
                                        do
                                        case $column in                                    
                                            "Exit")
                                                break 2
                                            ;;
                                            $column)
                                                read -p "enter the value of $column please: " colValue

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
                                                
                                                sed -n '/'$colValue'/p' ../DataBase/$db/$Tname
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

                                                echo $column
                                                nrData=`awk 'END{print NR}' ../DataBase/$db/$Tname;`
                                                for (( i=1 ; i<=$nrData ; i++ )); do
                                                    Data=(`awk -F: -v"i=$i" -v"x=$x" '{if(NR==i){print $x}}' ../DataBase/$db/$Tname;`)
                                                    echo $Data
                                                done

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
                break
            ;;
            "Delete From Table")
                while true 
                do
                    read -p "Please enter table name: " Tname
                    if [[ -e ../DataBase/$db/$Tname ]] && [[ -e ../DataBase/$db/MetaData$Tname ]]
                    then

                        nrTable=`awk 'END{print NR}' ../DataBase/$db/MetaData$Tname;` 
                        declare -a arrayColumn=()
                        for (( i=1 ; i<=$nrTable ; i++ )); do
                            arrayColumn+=(`awk -F: -v"i=$i" '{if(NR==i){print $1}}' ../DataBase/$db/MetaData$Tname;`)
                        done

                        while true
                        do
                            select select in "All Data" "Specific Column" "Exit"
                                do
                                case $select in
                                    "All Data")
                                        sed -i 'd' ../DataBase/$db/$Tname
                                        # echo -n > ../DataBase/$db/$Tname
                                        break
                                    ;;
                                    "Specific Column")
                                        
                                        select column in "${arrayColumn[@]}" "Exit"
                                        do
                                        case $column in                                    
                                            "Exit")
                                                break 2
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
                                                
                                                declare -a nrDel=(`awk -F: -v"colValue=$colValue" -v"x=$x" '{if(colValue == $x){print NR}}' ../DataBase/$db/$Tname;`)
                                            
                                                length=${#nrDel[*]}
                                                echo $length
                                                length=$((length-1))
                                                echo $length

                                                for (( i=$length; i>=0; --i ))
                                                do
                                                    sed -i "${nrDel[$i]}"'d' ../DataBase/$db/$Tname
                                                    echo "delete"
                                                done
                                                
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
                break
            ;;
            "Update Table")
                while true 
                do
                    read -p "Please enter table name: " Tname
                    if [[ -e ../DataBase/$db/$Tname ]] && [[ -e ../DataBase/$db/MetaData$Tname ]]
                    then

                        nrTable=`awk 'END{print NR}' ../DataBase/$db/MetaData$Tname;` 
                        declare -a arrayColumn=()
                        for (( i=2 ; i<=$nrTable ; i++ )); do
                            arrayColumn+=(`awk -F: -v"i=$i" '{if(NR==i){print $1}}' ../DataBase/$db/MetaData$Tname;`)
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
                                                
                                                # need work on########################################################################################################
                                                # declare -a nrUp=(`awk -F: -v"colValue=$colValue" -v"x=$x" '{if(colValue == $1){print NR,$x}}' ../DataBase/$db/$Tname;`)
                                                # echo $nrUp

                                                nfData=`awk 'END{print NF}' ../DataBase/$db/$Tname;` 
                                                awk -F: -v"colValue=$colValue" -v"newValue=$newValue" -v"x=$x" -v"nfData=$nfData" '
                                                {
                                                    if($1==colValue){
                                                        if($x==nfData){
                                                            $x=":"newValue
                                                        }else{
                                                            $x=":"newValue":"
                                                        }
                                                    }
                                                    {print}
                                                }'  ../DataBase/$db/$Tname > ../DataBase/$db/tmp && mv ../DataBase/$db/tmp ../DataBase/$db/$Tname

                                                sed -i 's/'" "'/'""'/g' ../DataBase/$db/$Tname

                                                    # sed -i "${nrDel[$i]}"'d' ../DataBase/$db/$Tname

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

                                                sed -i 's/'"$colValue"'/'"$newValue"'/g' ../DataBase/$db/$Tname
                                                
                                                break
                                            ;;
                                            "Exit")
                                                break 2
                                            ;;
                                        esac
                                    done

                                    # read -p "enter the value of $column please: " colValue
                                    # read -p "enter the new value of $column please: " newValue

                                    # know column number
                                    # for i in "${!arrayColumn[@]}"; do
                                    #     if [[ "${arrayColumn[$i]}" = "${column}" ]]; then
                                    #         x=${i}
                                    #         x=$((x+1))
                                    #         break
                                    #     fi
                                    # done

                                    # if [[ $x -eq 1 ]]
                                    # then
                                        
                                    # else
                                        
                                        
                                        # declare -a nrDel=(`awk -F: -v"colValue=$colValue" -v"x=$x" '{if(colValue == $x){print NR}}' ../DataBase/$db/$Tname;`)
                                    
                                        # length=${#nrDel[*]}
                                        # echo $length
                                        # length=$((length-1))
                                        # echo $length

                                        # for (( i=$length; i>=0; --i ))
                                        # do
                                        #     sed -i "${nrDel[$i]}"'d' ../DataBase/$db/$Tname
                                        #     echo "delete"
                                        # done

                                        # sed -i 's/'"$colValue"'/'"$newValue"'/g' ../DataBase/$db/$Tname

                                    # fi

                                    
                                    
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
                break
            ;;
            "Exit")
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
