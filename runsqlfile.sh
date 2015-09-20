sqlfile=$1

sqlplus -s / as sysdba <<EOF
@$sqlfile
EOF
