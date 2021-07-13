# The most important file, which control the sequence steps of running tests

########## Config
# Number of created worker instances
noMachine="9"
# Path to automation scripts in the master machine
executableP="/home/ubuntu/mnt/executable"
# Path to Ansible scripts
ansibleP="/home/ubuntu/mnt/ansible"
# Master test suite name
testName="MasterTestSuiteName"

########## Prepareation steps
# Create the test suite name with current date
rm /home/ubuntu/mnt/executable/testName
touch /home/ubuntu/mnt/executable/testName
now=`date +"%Y-%m-%d"`
echo  $testName-${now} | sed 's/[[:space:]]//g' >> /home/ubuntu/mnt/executable/testName

########## Star
# Create $noMachine worker instances
java -jar $executableP/testRunner/TestRunner.jar $noMachine
# Download config files
java -jar $executableP/configDownloader/testReplyPost.jar  $executableP/configDownloader/configXml/test.xml   $executableP/configDownloader/configXml/output.xml  $executableP/configDownloader/outputFile/batchconfig.xml  $executableP/configDownloader/outputFile/mastersuite.csv "MasterTestSuiteName"
# Divide Master Suite into $noMachine parts
java -jar $executableP/fileDivider/DivideFile.jar $executableP/configDownloader/outputFile/mastersuite.csv $executableP/fileDivider/DividedFile/ test $noMachine
# Send divided test parts to each worker instances
ansible-playbook -i $ansibleP/hosts $ansibleP/playCopyConfig.yml --extra-var 'testName="MasterTestSuiteName"'
# Get all the hosts (worker instances) IP addresses
sh $ansibleP/getHost.sh
# RDP to machine, restart
ansible-playbook -i $ansibleP/hostsRdp $ansibleP/playRdp.yml
# Copy startUpBatch, which initiates test running after restarting
ansible-playbook -i $ansibleP/hosts $ansibleP/playStart.yml
# RDP to machine, effective start running test
ansible-playbook -i $ansibleP/hostsRdp $ansibleP/playRdp.yml
# Remove resume file
ansible-playbook -i $ansibleP/hosts $ansibleP/playRemoveResume.yml
# Create Cronjob to periodically report the test status
ansible-playbook -i $ansibleP/hosts $ansibleP/playCreateCron.yml --extra-var 'testName="MasterTestSuiteName"'
