$classes = Import-Csv -Path .\gamclassinfo.csv -Header Term,Period,Course,Trial,SchooldID,TeacherEmail,StudentEmail
$rosters = @{}


foreach($student in $classes) {
    $course_name = $student.Course -replace '\s',''
    $course_name = $course_name -replace '/','.'
    $class_name = $course_name + "." + $student.Period + "." + $student.Term

    #If the key exists add the email address else create the key and object
    if ($rosters.ContainsKey($class_name)){
        $new_class = $rosters[$class_name]
        $new_roster = $rosters[$class_name].Roster
        $new_roster += $student.StudentEmail
        $new_class.Roster = $new_roster
        $rosters[$class_name] = $new_class
    } else {
        $course = New-Object PSObject -Property @{
            CourseName      = $class_name
            TeacherEmail    = $student.TeacherEmail
            Roster          = @($student.StudentEmail)
        }
        $rosters.Add($class_name, $course)
    }
}

foreach($value in $rosters.Values){
    $fname = $value.CourseName
    $value.Roster | Out-File .\classes\$fname.txt 
    #gam command to sync command
}