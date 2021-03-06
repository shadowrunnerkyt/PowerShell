$scriptRoot = split-path -Parent $MyInvocation.MyCommand.Definition

If ( Test-Path $scriptRoot\emea.txt ) { Remove-Item $scriptRoot\emea.txt }
If ( Test-Path $scriptRoot\nasa.txt ) { Remove-Item $scriptRoot\nasa.txt }

If ( Test-Path $scriptRoot\*_newMailboxesCreated.txt ) {add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin
    $LOGIN = $null
    $LOGIN = Get-Content $scriptRoot\*_newMailboxesCreated.txt | select-string -Pattern "^\d+:\sTEXT\\\w*" | %{$_ -replace "^\d+:\sTEXT\\",""} | sort
    ForEach($_ in $LOGIN) {IF ((Get-Mailbox $_).ServerName -match ".*gb.*") {"$_" >> $scriptRoot\emea.txt}}
    ForEach($_ in $LOGIN) {IF ((Get-Mailbox $_).ServerName -match ".*us.*|.*au.*") {"$_" >> $scriptRoot\nasa.txt}}}
Else{ echo "You have to give me the CMP Mailbox Creation Log File attachment in order to process it!"; exit 1}

If ( Test-Path $scriptRoot\*_newMailboxesCreated.txt ) { Remove-Item $scriptRoot\*_newMailboxesCreated.txt }
If ( Test-Path $scriptRoot\LyncUsers.txt ) { Remove-Item $scriptRoot\LyncUsers.txt }
