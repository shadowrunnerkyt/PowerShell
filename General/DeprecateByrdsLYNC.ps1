$scriptRoot = split-path -Parent $MyInvocation.MyCommand.Definition

If ( Test-Path $scriptRoot\*_newMailboxesCreated.txt ) {
	add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin
	import-module -Name Lync

	$LOGIN = $LYNCUser = $null
	$LOGIN = Get-Content C:\CMP\*_newMailboxesCreated.txt | select-string -Pattern "^\d+:\sFOO\\\w*" | %{$_ -replace "^\d+:\sFOO\\",""} | sort
	$LOGIN}
	ForEach($_ in $LOGIN) {
		IF ((Get-Mailbox $_).ServerName -match ".*us.*|.*au.*") {
			Enable-CsUser -Identity $_ -RegistrarPool "us.foo.bar.com" -SipAddressType FirstLastName -SipDomain ocs.bar.com}
		ELSE{Enable-CsUser -Identity $_ -RegistrarPool "eu.foo.bar.com" -SipAddressType FirstLastName -SipDomain ocs.bar.com}
		$LYNCUser = Get-CsUser -Identity $_
		IF ($LYNCUser){
			Set-CsUser -Identity $_ -AudioVideoDisabled $True -RemoteCallControlTelephonyEnabled $False -EnterpriseVoiceEnabled $False
			Grant-CsExternalAccessPolicy -Identity $_ -PolicyName $Null }}}
Else{ echo "You have to give me the CMP Mailbox Creation Log File attachment in order to process it!"; exit 1}

#If ( Test-Path $scriptRoot\*_newMailboxesCreated.txt ) { Remove-Item $scriptRoot\*_newMailboxesCreated.txt }