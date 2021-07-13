# AutomationScript
All the code to control the system including:  
    - The automation script, which is AutomationTesting.sh. It is the most important script in this folder  
      The script has the sequence of steps to start test execution  
      and the necessary commands to use all the jar files  also the Python scripts
    - The folders storing test results, test progress, jar files, test configuration files:  
        + testRunner: contains the jar file to modify Terraform configuration files.  
                      When modifying the number of created worker instances in the AutomationTesting.sh script,  
                      the Terraform configuration file needs to update. It is not convenient.  
                      Therefore, the TestRunner.jar file will create new Terraform configuration files  
                      whenever the config in file AutomationTesting.sh is changed.
        + testProgress:
            * currentProgress: contains all the converted test progress from the subreport_text files
            * masterSuite: contains all the divided test sets
            * subreport_text: contains all the subreport_text from worker instances, which specify the current number of failed/passed tests.
            * ProgressTracking.jar: the Java application to convert subreport_text to a simple progress file