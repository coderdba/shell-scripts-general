#!/bin/ksh
#
# http://www.cyberciti.biz/faq/bash-infinite-loop/
#
#

exec >> tranlog.sh.out 2>> tranlog.sh.out

while :
do

ggsci <<EOF

dblogin useridalias OGGUSER;
add TRANDATA OMSADM.YFS_ORDER_HEADER ALLCOLS;

EOF

done
