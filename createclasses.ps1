$classes = Import-Csv -Path .\gamclassinfo.csv -Header Term,Period,Course,Trial,SchooldID,TeacherEmail,StudentEmail
$rosters = @{}

#Fills the hash table $rosters with ClassName,Course object to be used later
foreach($student in $classes) {
    $course_name = $student.Course -replace '\s',''
    $course_name = $course_name -replace '/','.'
    $alias = $course_name + "." + $student.Period + "." + $student.Term

    #If the key exists add the email address else create the key and object
    if (-Not $rosters.ContainsKey($alias)){
        $course = New-Object PSObject -Property @{
            Alias           = $alias   
            CourseName      = $course_name
            TeacherEmail    = $student.TeacherEmail
            Section         = $student.Term + " Period " + $student.Period 
        }
        $rosters.Add($alias, $course)
    }
}

foreach($value in $rosters.Values){
    $output = "Alias: {0}     CourseName: {1}       TeacherEmail: {2}       Section: {3}" -f $value.Alias,$value.CourseName,$value.TeacherEmail,$value.Section
    Write-Host $output
    #gam command to sync command
}