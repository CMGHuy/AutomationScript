#!/bin/sh
#PATH=/home/ubuntu/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
#exec 3>&1 4>&2
#trap 'exec 2>&4 1>&3' 0 1 2 3  15 RETURN
#exec 1>/home/ubuntu/mnt/executable/testlog 2>&1

noMachine="10"
mastersuite=""
executableP="/home/ubuntu/mnt/executable"
ansibleP="/home/ubuntu/mnt/ansible"
testName="TestCase45"
testrunId="1-PKGHFN"

rm /home/ubuntu/mnt/executable/testName
touch /home/ubuntu/mnt/executable/testName
now=`date +"%Y-%m-%d"`
echo  $testName-${now} | sed 's/[[:space:]]//g' >> /home/ubuntu/mnt/executable/testName

#create NOMACHINE machines
java -jar $executableP/testRunner/TestRunner.jar $noMachine
#download config files
java -jar $executableP/configDownloader/testReplyPost.jar  $executableP/configDownloader/configXml/test.xml   $executableP/configDownloader/configXml/output.xml  $executableP/configDownloader/outputFile/batchconfig.xml  $executableP/configDownloader/outputFile/mastersuite.csv "C2C Test Suite Main" "1-PKGHFN"
#divide test file to NOMACHINE machines
java -jar $executableP/fileDivider/DivideFile.jar $executableP/configDownloader/outputFile/mastersuite.csv $executableP/fileDivider/DividedFile/ test $noMachine
#send test file to machines
ansible-playbook -i $ansibleP/hosts $ansibleP/playCopyConfig.yml --extra-var 'testName="C2C Test Suite Main"'
#run gethost.sh
sh $ansibleP/getHost.sh
#RDP to machine, restart
ansible-playbook -i $ansibleP/hostsRdp $ansibleP/playRdp.yml
#copy startUpBatch
ansible-playbook -i $ansibleP/hosts $ansibleP/playStart.yml
#RDP to machine, effective start
ansible-playbook -i $ansibleP/hostsRdp $ansibleP/playRdp.yml
#remove resume file
ansible-playbook -i $ansibleP/hosts $ansibleP/playRemoveResume.yml
#createCronJob
ansible-playbook -i $ansibleP/hosts $ansibleP/playCreateCron.yml
