# Assumes Module is in same folder as your GAM scripts
Import-Module "$PSScriptRoot\GAMFunctions" -Force

# Source your config variables
. "$PSScriptRoot\config.ps1"

# Make your SQL query and output it into a CSV file named gamclassinfo.csv
$sql_response = Invoke-Sqlcmd -ConnectionString $ConnectionString -Query $sqlquery
$sql_response | Export-Csv -path "$PSScriptRoot\example_gamclassinfo.csv" -NoTypeInformation 

# Create Hashtable for all returned classes and store it
# Get-Classes also accepts parameters for Term and SchoolID
$classes = Get-Classes -InputFilePath "$PSScriptRoot\example_gamclassinfo.csv"

# Create classes with GAM and set to Provisioned 
Set-GAMClasses -Classes $classes -ClassState PROVISIONED -GAMAction CREATE
