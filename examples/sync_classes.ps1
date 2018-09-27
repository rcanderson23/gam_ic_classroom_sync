# Assumes Module is in same folder as your GAM scripts
Import-Module "$PSScriptRoot\GAMFunctions" -Force

# Source your config variables
. "$PSScriptRoot\config.ps1"

# Make your SQL query and output it into a CSV file named gamclassinfo.csv
$sql_response = Invoke-Sqlcmd -ConnectionString $ConnectionString -Query $sqlquery
$sql_response | Export-Csv -path "$PSScriptRoot\example_gamclassinfo.csv" -NoTypeInformation -Header Term,Period,Course,Trial,SchoolID,TeacherEmail,StudentEmail,SectionID

# Creates a hashtable of class rosters and stores it
# You can modify this with the Term or SchoolID parameter
$rosters = Get-ClassRosters -InputFilePath "$PSScriptRoot\example_gamclassinfo.csv"

# Sync the class rosters. This requires outputting the rosters to a file and then syncing
# individual CSV files with GAM. Requires the hashtable of rosters and the output folder
Sync-GAMClassRosters -Rosters $rosters -RosterOutputFolder "$PSScriptRoot\rosters"
