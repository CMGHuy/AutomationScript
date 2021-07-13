# Used for merging test result

testName=$( cat "/home/ubuntu/mnt/executable/testName")
now=`date +"%Y-%m-%d"`

# Unzip all zipped report folder
cd ~/mnt/ansible/reportResult
#for file in * ; do mv "$file" "$file".zip; done
#for file in * ; do mkdir --parents "$file"hi/reports/; mv $file $_ ; done
find . -iname '*.zip' -exec sh -c 'unzip -o -d "${0%.*}" "$0"' '{}' ';'
cd ~/mnt/executable/GenerateMainResultHtml
# Generate HTML result file with template
java -jar archive.jar ~/mnt/ansible/reportResult Fleet
# Merge all reports
python3 ~/mnt/executable/MergeReportPython/Main.py merge -i ~/mnt/ansible/reportResult
rm ~/mnt/executable/MergeReportPython/report.zip
echo $testName.zip
# Remove all old screenshots
cd ~/mnt/executable/MergeReportPython/reports/screenshots
find . ! -newermt $now ! -type d -delete
# Zip the merged reports folder
zip -r ~/mnt/executable/MergeReportPython/$testName.zip ~/mnt/executable/MergeReportPython/reports
cp -r ~/mnt/executable/MergeReportPython/reports ~/mnt/executable/report/
# Copy merged report to nginx host folder
sudo cp -r ~/mnt/executable/MergeReportPython/reports /var/www/host/$testName
# Push reports to database
cd  ~/mnt/executable/PushBlob_jar
java -jar PushBlob.jar -r ../MergeReportPython/reports/logs/testCaseFile.txt ../MergeReportPython/$testName.zip
cd /etc/nginx/sites-available/
sudo bash /etc/nginx/sites-available/script 
