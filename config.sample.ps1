#InfiniteCampus uses MSSQL and self signed certificates so we need these credentials to form a connection
$username = "dbusername"
$password = "dbpassword"
$dbserverstring = "db1.domain.tld,1234"
$database = "dbname"
$ConnectionString = "Server=$dbserverstring;Database=$database;User ID=$username;Password=$password;encrypt=true;trustServerCertificate=true"
$sqlquery = "SELECT DISTINCT t.name as Term, p.Name as Period, c.name as Course, r.trialid as Trial, sch.schoolid as SchoolID, con.email as TeacherEmail, scon.email as StudentEmail, s.sectionid as SectionID
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
