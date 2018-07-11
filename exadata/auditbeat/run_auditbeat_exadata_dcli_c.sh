if [ $# -lt 3 ]
then

echo
echo Usage: $0 mahine_to_run_on , appName ,  install or establish or install_and_establish or auditd_non_immutable
echo
exit 1

fi

machine=$1
app=$2
action=$3

script=auditbeat_exadata.sh
script_basename=`basename $script`

remotedir=/root/tmp_${script_basename}_run

echo INFO - Creating $remotedir on $machine
dcli -c $machine -l root "mkdir -p $remotedir"

echo INFO - Copying $script_basename, rpmfile and yml files to $machine:$remotedir
scp -q $script ${machine}:${remotedir}/.
scp -q auditbeat.yml.exadata-tvx ${machine}:${remotedir}/.
scp -q auditbeat.yml.exadata-non-tvx ${machine}:${remotedir}/.

if [ "$action" == "install" ]
then

scp -q auditbeat-6.2.4-x86_64.rpm ${machine}:${remotedir}/.

fi

if [ "$action" == "install_and_establish" ]
then

scp -q auditbeat-6.2.4-x86_64.rpm ${machine}:${remotedir}/.

fi

dcli -c $machine -l root "chmod 700 ${remotedir}/${script_basename}; cd ${remotedir}; ${remotedir}/${script_basename} $app $action; cd /root; rm -rf $remotedir"
echo
echo
