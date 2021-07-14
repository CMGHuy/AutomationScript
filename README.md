# AutomationScript
This repository contains all the codes to control the system including:  

1.  The automation script, which is AutomationTesting.sh. It is the most important script in this folder  
    The script has the sequence of steps to start test execution  
    and the necessary commands to use all the jar files  also the Python scripts
    
2.  The merging report script, which is mergeReport.sh. It has the commands to use Python script and merge test results.
    
3.  The script removing old files, which are not necessary for the next executions.
    
4.  The folders storing test results, test progress, jar files, test configuration files:  
        - testRunner: contains the jar file to modify Terraform configuration files.  
                      When modifying the number of created worker instances in the AutomationTesting.sh script,  
                      the Terraform configuration file needs to update. It is not convenient.  
                      Therefore, the TestRunner.jar file will create new Terraform configuration files  
                      whenever the config in file AutomationTesting.sh is changed.  
        - testProgress:  
            + currentProgress: contains all the converted test progress from the subreport_text files  
            + masterSuite: contains all the divided test sets  
            + subreport_text: contains all the subreport_text from worker instances, which specify the current number of failed/passed tests.  
            + ProgressTracking.jar: the Java application to convert subreport_text to a simple progress file  
        - report: contains the merged test result. This folder is zipped later and pushed into the database  
        - PushBlob_jar: jar file PushBlob.jar has the methods to insert test progress and test result into the hosted web application  
        - MergeReportPython: contains the script to merge test reports to form the final test report  
        - GenerateMainResultHtml: contains the script to convert the test script into the appropriate HTML template  
        - fileDivider: contains the jar file used to divide the master test suite into multiple test sets  
        - configDownloader: contains the jar file, which is testReplyPost.jar, to send SOAP request to Siebel and download the master suite description
            * configXml: output.xml is the returned file from Siebel. test.xml is the request file. 
                         These files are not fully documented since they contain confidential data
            * outputFile: the batchconfig and masterSuite file
        - nginx: contains the scripts to add the test result to nginx hosted folder, which is used for the monitoring web app  