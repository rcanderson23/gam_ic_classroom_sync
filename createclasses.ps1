# Creates classes in G Suite from CSV generated from getclasses.ps1

$classes = Import-Csv -Path .\gamclassinfo.csv -Header Term,Period,Course,Trial,SchooldID,TeacherEmail,StudentEmail
$courses = @{}

#Fills the hash table $courses with Alias,Course object to be used later
foreach($student in $classes) {
    $course_name = $student.Course -replace '\s',''
    $course_name = $course_name -replace '/','.'
    $alias = $course_name + "." + $student.Period + "." + $student.Term

    #If the key doesn't exist create a course object and insert into the hash table
    if (-Not $courses.ContainsKey($alias)){
        $course = New-Object PSObject -Property @{
            Alias           = $alias   
            CourseName      = $course_name
            TeacherEmail    = $student.TeacherEmail
            Section         = $student.Term + " Period " + $student.Period 
        }
        $courses.Add($alias, $course)
    }
}

foreach($value in $courses.Values){
    C:\GAM\gam.exe create course alias $value.Alias name $value.CourseName section $value.Section teacher $value.TeacherEmail status ACTIVE
}