#! /usr/bin/bash
                                # system(`awk -f ./checkExist.sh`)
# exist = `awk -F: -vprimary=value '{if($2 == primary){print 0}}'../DataBase/$db/$table/Data;`
# return exist
# check = awk -F : '
# {
#     if(value == $2){
#         print 0
#     }
# }
# ' ../DataBase/$db/$table/Data
# nr=`awk -F:  '{print NR}' ../DataBase/$db/$table/MetaData`
	typeset -i nf=`awk -F: '{print NR}' ../DataBase/cat/catty/MetaData;`
echo $nf