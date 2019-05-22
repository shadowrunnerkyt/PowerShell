$scriptPath = $inputFile = $list = $LoginID = $groups = $ADUser = $ADGroup = $Creds = $null

$scriptPath = split-path -Parent $MyInvocation.MyCommand.Definition
$inputFile = $scriptPath + "\User_termination_list.csv"

If ( Test-Path $inputFile ) {
    $list = import-csv $inputFile
    $LoginID = $list.'LOGIN_ID'
    }
Else {
    "User_termination_list.csv missing.
    You must provide the list of users."
    exit 1
    }

If ( Test-Path $scriptPath\groups.txt ) { $groups = Get-Content "$scriptPath\groups.txt" }
Else {
    "groups.txt is missing.
    You must provide the list of groups."
    exit 2
    }


Import-Module ActiveDirectory
$Creds = (Get-Credential -Message "Supply your admin credentials.")
ForEach ($ADUser in $LoginID) { 
    ForEach ($ADGroup in $groups) { 
        "Checking for $ADUser in $ADGroup"
        Try{Remove-ADGroupMember -Identity $ADGroup -Members $ADUser -Credential $Creds -Server CORP -Confirm:$false -ErrorAction Stop}
        Catch{$_.Exception.Message | Tee-Object -Append $outputFile} } }
