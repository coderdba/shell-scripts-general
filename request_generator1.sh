#!/bin/ksh

if [ $# -lt 2 ]
then
echo "ERR - provide arguments 1. safe name, 2. dbname|all"
exit 1
fi

safe=$1
dbname=$2

echo "Safe,Platform Id,Account Name,Username,Password,Address,Port,Remarks"

if [ "$dbname" = "all" ]
then

# pvuseradmin accounts
ps -ef|grep pmon |grep -v grep |grep -v ASM | grep -v MGMTDB |cut -d_ -f3 | sort | sed 's/.$//g'  | while read dbname
do

acct_pvuseradmin=${dbname}adminuser
echo "admin-safe,OracleDB,${acct_pvuseradmin},adminuser,password,${dbname},1521,none"

done

# dbaopr accounts
ps -ef|grep pmon |grep -v grep |grep -v ASM | grep -v MGMTDB |cut -d_ -f3 | sort | sed 's/.$//g'  | while read dbname
do

acct_dbaopr=${dbname}operatoruser
echo "$safe,${acct_dbaopr},operatoruser,password,${dbname},1521,none"

done


else

acct_pvuseradmin=${dbname}adminuser
acct_dbaopr=${dbname}operatoruser

echo "admin-safe,OracleDB,${acct_pvuseradmin},adminuser,password,${dbname},1521,none"
echo "$safe,${acct_dbaopr},operatoruser,password,${dbname},1521,none"

fi
