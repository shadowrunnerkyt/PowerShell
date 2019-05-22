Import-Module ActiveDirectory

$scriptRoot = split-path -Parent $MyInvocation.MyCommand.Definition

If ( Test-Path $scriptRoot\emea.txt ) { Remove-Item $scriptRoot\emea.txt }
If ( Test-Path $scriptRoot\nasa.txt ) { Remove-Item $scriptRoot\nasa.txt }
If ( Test-Path $scriptRoot\*_newMailboxesCreated.txt ) {
$LOGIN = Get-Content $scriptRoot\*_newMailboxesCreated.txt | select-string -Pattern '(?<=Mercer user: )([^;|,]*)' | select -ExpandProperty matches | select -ExpandProperty value
foreach($_ in $LOGIN) {$ID = $_ -replace "mercer\\", ""
$USERS = $ID | Foreach{Get-ADUser $_ -Server TEXT.com -Properties * | Select SAMAccountName, msExchHomeServerName }
ForEach($_ in $USERS) {if ($_.msExchHomeServerName -match ".*gb.*") {echo $_.SAMAccountName >> $scriptRoot\emea.txt}}
ForEach($_ in $USERS) {if ($_.msExchHomeServerName -match ".*us.*|.*au.*") {echo $_.SAMAccountName >> $scriptRoot\nasa.txt}}}}
Else{ echo "You have to give me the CMP Mailbox Creation Log File attachment in order to process it!"; exit 1}

If ( Test-Path $scriptRoot\*_newMailboxesCreated.txt ) { Remove-Item $scriptRoot\*_newMailboxesCreated.txt }
If ( Test-Path $scriptRoot\LyncUsers.txt ) { Remove-Item $scriptRoot\LyncUsers.txt }