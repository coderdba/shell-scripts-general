#
#
# auditbeat_exadata.sh
#
#

if [ $# -lt 2 ]
then

echo
echo Usage: $0 , appName ,  install or establish or install_and_establish or auditd_non_immutable 
echo

exit 1

fi

script=$0
app=$1
action=$2

if [ "$app" == "abc" ]
then
     ymlfile=auditbeat.yml.exadata-abc
else
     ymlfile=auditbeat.yml.exadata-non-abc
fi

datetime=`date +%Y%m%d_%H%M%S`
auditbeatyml=/etc/auditbeat/auditbeat.yml
cksum_auditbeatyml=`cksum $auditbeatyml | awk '{print $1}'`
cksum_ymlfile=`cksum $ymlfile | awk '{print $1}'`

check_error()
{

if [ $retcode -ne 0 ]
then

echo ERR - Error in the last operation
exit

fi

}

install_auditbeat()
{
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# INSTALL AUDITBEAT AND COPY CORRECT YML
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if !(rpm -qa | grep auditbeat) > /dev/null
then

echo
echo INFO - Install auditbeat rpm
rpm -Uvh auditbeat-6.2.4-x86_64.rpm
retcode=$?
check_error retcode

else

echo
echo INFO - Auditbeat rpm already installed
rpm -qa | grep auditbeat

fi

echo
echo INFO - Verify
rpm -qa|grep auditb
which auditbeat


if [ "$cksum_auditbeatyml" != "$cksum_ymlfile" ]
then

echo
echo INFO - Backup current auditbeat.yml
/bin/cp -p ${auditbeatyml} ${auditbeatyml}.${datetime}

echo
echo INFO - Copy the correct/new auditbeat.yml
cp $ymlfile /etc/auditbeat/auditbeat.yml
retcode=$?
check_error retcode

else

echo
echo INFO - Current $auditbeatyml is same as $ymlfile. No need to replace it.
echo       

fi

}


configure_auditd_non_immutable()
{
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Comment out "-e 2" immutable setting in /etc/auit/audit.rules
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
audit_rules_file=/etc/audit/audit.rules

if (grep "^\-e 2" $audit_rules_file) > /dev/null 
then

echo
echo INFO - $audit_rules_file is immutable - need to make it non-immutable
echo

echo INFO - Backing up current audit.rules file
cp $audit_rules_file ${audit_rules_file}.${datetime}

echo INFO - making $audit_rules_file writeable by root using chattr
echo
chattr -i $audit_rules_file

echo
echo INFO - Making audit.rules file non-immutable
sed -e '/\-e 2$/ s/^#*/#/' -i ${audit_rules_file}

echo INFO - making $audit_rules_file non-writeable by root using chattr
echo
chattr +i $audit_rules_file

echo
echo INFO - Verify - no results means good
echo

if (grep "^\-e 2" $audit_rules_file) 
then
     echo INFO - Last operation not successful
     exit

else

echo
echo INFO - Restarting auditd - NOTE - if it says anything about 'immutable' - note it down - it may then need machine restart
echo
service auditd restart
echo

fi

else

echo INFO - $audit_rules_file already is non-immutable

fi

}

replace_auditd_start_auditbeat()
{

echo
echo INFO - Stopping auditd
service auditd stop
retcode=$?
echo retcode = $retcode
check_error retcode

echo
echo INFO - Verify
service auditd status

echo
echo INFO - Disable auditd from starting
chkconfig auditd off
retcode=$?
check_error retcode

echo
echo INFO - Verify
chkconfig --list auditd

echo
echo INFO - Add auditbeat to auto-start
chkconfig --add auditbeat
retcode=$?
check_error retcode

echo
echo INFO - Verify
chkconfig --list auditbeat

echo
echo INFO - Start auditbeat service
service auditbeat start
retcode=$?
check_error retcode

echo
echo INFO - Verify
service auditbeat status

echo 
echo  ------------------------------
echo INFO - Verify remote-server connection established using netstat -anp
sleep 15
netstat -anp |grep auditbeat
retcode=$?
check_error retcode

}

if [ "$action" == "install" ]
then

echo 
echo INFO - THIS WILL ONLY INSTALL AUDITBEAT AND COPY THE CORRECT YML
echo

install_auditbeat
configure_auditd_non_immutable

elif [ "$action" == "establish" ]
then

echo 
echo INFO - THIS WILL STOP AUDITD AND START AUDITBEAT 
echo
echo        Prerequiste 1 - AUDITBEAT ALREADY INSTALLED
echo
echo        Prerequiste 2 - AUDITD RULES IN NON-IMMUTABLE STATE
echo

echo INFO - Checking if auditbeat is installed
if !(rpm -qa | grep auditbeat) > /dev/null
then

echo
echo ERR - Auditbeat rpm is not installed.  Run this program with 'install' option first
echo

exit 1

fi

replace_auditd_start_auditbeat

elif [ "$action" == "install_and_establish" ]
then

install_auditbeat
configure_auditd_non_immutable
replace_auditd_start_auditbeat

elif [ "$action" == "auditd_non_immutable" ]
then

echo 
echo INFO - THIS WILL MAKE AUDITD NON-IMMUTABLE
echo

configure_auditd_non_immutable


fi

echo 
echo INFO - Completing program and exiting
echo
