function Get-ClassRosters {
    param (
        [Parameter(Mandatory=$true)][String]$InputFilePath,
        [Parameter(Mandatory=$false)][String]$Term,
        [Parameter(Mandatory=$false)][String]$SchoolID
    )
    if (($Term) -and ($SchoolID)){
        $classes = Import-Csv -Path $InputFilePath | Where-Object {($_.Term -eq $Term) -and ($_.SchoolID -eq $SchoolID) }
    } elseif (($Term) -and (-Not($SchoolID))) {
        $classes = Import-Csv -Path $InputFilePath | Where-Object {($_.Term -eq $Term) -and ($_.SchoolID -ne $SchoolID) }
    } elseif ((-Not($Term)) -and ($SchoolID)){
        $classes = Import-Csv -Path $InputFilePath | Where-Object {($_.Term -ne $Term) -and ($_.SchoolID -eq $SchoolID) }
    } else {
        $classes = Import-Csv -Path $InputFilePath
    }
    $rosters = @{}

    #Fills the hash table $rosters with ClassName,Course object to be used later
    foreach($student in $classes) {
        $course_name = $student.Course -replace '\s',''
        $course_name = $course_name -replace '/','.'
        $class_name = $course_name + "." + $student.Period + "." + $student.Term + "." + $student.SectionID
    
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
    return $rosters
}

function Get-Classes {
    param (
        [Parameter(Mandatory=$true)][String]$InputFilePath,
        [Parameter(Mandatory=$false)][String]$Term,
        [Parameter(Mandatory=$false)][String]$SchoolId
    )
    if (($Term) -and ($SchoolID)){
        $classes = Import-Csv -Path $InputFilePath | Where-Object {($_.Term -eq $Term) -and ($_.SchoolID -eq $SchoolID) }
    } elseif (($Term) -and (-Not($SchoolID))) {
        $classes = Import-Csv -Path $InputFilePath | Where-Object {($_.Term -eq $Term) -and ($_.SchoolID -ne $SchoolID) }
    } elseif ((-Not($Term)) -and ($SchoolID)){
        $classes = Import-Csv -Path $InputFilePath | Where-Object {($_.Term -ne $Term) -and ($_.SchoolID -eq $SchoolID) }
    } else {
        $classes = Import-Csv -Path $InputFilePath
    }
    $courses = @{}

    #Fills the hash table $courses with Alias,Course object to be used later
    foreach($student in $classes) {
        $course_name = $student.Course -replace '\s',''
        $course_name = $course_name -replace '/','.'
        $alias = $course_name + "." + $student.Period + "." + $student.Term + "." + $student.SectionID

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
    return $courses
}

function Set-GAMClasses {
    param (
        [Parameter(Mandatory=$true)][Hashtable]$Classes,
        [Parameter(Mandatory=$true)][ValidateSet("ACTIVE","PROVISIONED","ARCHIVED","DECLINED")][String]$ClassState,
        [Parameter(Mandatory=$true)][ValidateSet("CREATE","UPDATE")][String]$GAMAction
    )
    If(-Not(Get-Command "gam" -ErrorAction "Ignore")){
        Write-Error "GAM could not be found."
        Exit
    }
    foreach($value in $Classes.Values){
        if($GAMAction -eq "CREATE"){
            gam create course alias $value.Alias name $value.CourseName section $value.Section teacher $value.TeacherEmail status $ClassState
        } else{
            gam update course $value.Alias status $ClassState
        }
    }
}

function Sync-GAMClassRosters {
    param (
        [Parameter(Mandatory=$true)][Hashtable]$Rosters,
        [Parameter(Mandatory=$true)][String]$RosterOutputFolder
    )
    If(-Not(Get-Command "gam" -ErrorAction "Ignore")){
        Write-Error "GAM could not be found."
        Exit
    }
    foreach($value in $Rosters.Values){
        $fname = $value.CourseName
        $value.Roster | Out-File "$RosterOutputFolder\$fname.txt" -Encoding ascii
        gam course $value.CourseName sync students file "$RosterOutputFolder\$fname.txt"
    }
}
