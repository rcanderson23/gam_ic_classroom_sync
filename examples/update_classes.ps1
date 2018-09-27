# Assumes Module is in same folder as your GAM scripts
Import-Module "$PSScriptRoot\GAMFunctions" -Force

# Source your config variables
. "$PSScriptRoot\config.ps1"

# Make your SQL query and output it into a CSV file named gamclassinfo.csv
$sql_response = Invoke-Sqlcmd -ConnectionString $ConnectionString -Query $sqlquery
$sql_response | Export-Csv -path "$PSScriptRoot\example_gamclassinfo.csv" -NoTypeInformation -Header Term,Period,Course,Trial,SchoolID,TeacherEmail,StudentEmail,SectionID

# Create Hashtable for all returned classes and store it
$classes = Get-Classes -InputFilePath "$PSScriptRoot\example_gamclassinfo.csv"

# UPDATE with GAM and set to ARCHIVED,ACTIVE
# If you archive you will not be able to revert with this tool!
Set-GAMClasses -Classes $classes -ClassState ACTIVE -GAMAction UPDATE
