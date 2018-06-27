#MSSQL Connection and Query examples
. .\config.ps1
$sqlcommand = "SELECT DISTINCT t.name as Term, p.Name as Period, c.name as Course, r.trialid as Trial, sch.schoolid as SchoolID, con.email as TeacherEmail, scon.email as StudentEmail
               FROM Section s
               JOIN SectionPlacement sp ON s.sectionid = sp.sectionID
               JOIN Term t ON sp.termid = t.termid
               JOIN Period p ON sp.periodid = p.periodid
               JOIN Course c ON s.courseid = c.courseid
               JOIN Roster r ON s.sectionid = r.sectionid
               JOIN Person teacher ON s.teacherpersonid = teacher.personid
               JOIN Contact con ON teacher.personid = con.personid
               JOIN Person student ON r.personid = student.personid
               JOIN Contact scon ON student.personid = scon.personid
               JOIN Calendar cal ON c.calendarid = cal.calendarid
               JOIN School sch ON cal.schoolid = sch.schoolid
               JOIN Trial tr ON r.trialid = tr.trialid
               WHERE tr.active = 1"


$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
$command = New-Object System.Data.SqlClient.SqlCommand($sqlcommand,$connection)
$connection.Open()

$adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
$dataset = New-Object System.Data.DataSet
$adapter.Fill($dataset) | Out-Null

$connection.Close()
$dataset.Tables[0] | Export-Csv -Path .\gamclassinfo.csv -NoTypeInformation