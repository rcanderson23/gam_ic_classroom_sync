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
    #$output = "Alias: {0}     CourseName: {1}       TeacherEmail: {2}       Section: {3}" -f $value.Alias,$value.CourseName,$value.TeacherEmail,$value.Section
    #Write-Host $output
    #gam command to sync command
}