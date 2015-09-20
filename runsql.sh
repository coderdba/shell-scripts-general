sql=$1
#obj=`echo $obj|sed 's/\$/\\\$/g'`
#echo $obj

sqlplus -s / as sysdba <<EOF
$sql
EOF
