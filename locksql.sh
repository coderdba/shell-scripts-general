#!/bin/ksh
#
#  locksql.sh
#
#  Gets details of locking and waiting sessions
#  - Locked objects
#  - SQLs being run
# 
#  NOTE:  Holding session's sql cannot be listed somehow from v$sql_text
#

# Set environment here


export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4.RAC
export ORACLE_SID=RACPROD011
export PATH=/bin:/sbin:/etc:/usr/bin:/usr/sbin:/usr/local/bin:/usr/lib:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export LIBPATH=$ORACLE_HOME/lib

scriptpath=$0
script=`basename $scriptpath`
scriptdir=`dirname $scriptpath`
cd $scriptdir
scriptdir=`pwd`
installdir=`dirname $scriptdir`

logdir=${scriptdir}
logfile=${logdir}/${script}.log
tmpfile1=${logdir}/${script}.tmp1
tmpfile2=${logdir}/${script}.tmp2


exec >> $logfile 2>> $logfile

echo
echo =====================================
echo INFO - Locks at `date`


sqlplus -s / as sysdba <<EOF

set pages 1000
set lines 200

prompt
prompt Listing from dba_waiters
prompt ========================
select * from dba_waiters;

prompt
prompt Locked objects by Holding Session
prompt =================================
select *
from   gv\$locked_object a,
       dba_waiters b
where  a.session_id = b.holding_session;


prompt
prompt Locked objects by Waiting Session
prompt =================================
select *
from   gv\$locked_object a,
       dba_waiters b
where  a.session_id = b.waiting_session;


prompt
prompt Holding session
prompt ===================

select b.inst_id, b.sid, b.username, b.machine, b.osuser, b.module, b.sql_id, b.sql_hash_value, c.sql_text
from   dba_waiters a, gv\$session b, gv\$sql c
where  a.holding_session = b.sid
and    b.sql_id = c.sql_id
and    b.sql_hash_value = c.hash_value;
--and    b.sql_child_number = c.child_number;

prompt
prompt Waiting session
prompt ===================

select b.inst_id, b.sid, b.username, b.machine, b.osuser, b.module, b.sql_id, b.sql_hash_value, c.sql_text
from   dba_waiters a, gv\$session b, gv\$sql c
where  a.waiting_session = b.sid
and    b.sql_id = c.sql_id
and    b.sql_hash_value = c.hash_value;
--and    b.sql_child_number = c.child_number;


EOF
