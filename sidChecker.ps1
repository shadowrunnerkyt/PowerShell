Import-Module ActiveDirectory
$msRO = ""
$msES = ""
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$TheDude = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a SAMAccountName", "Who's your user?", "")
#if (!$TheDude) {exit}
$msRO = Get-ADUser $TheDude -Server domain.com -Properties * | Select-Object -ExpandProperty msRTCSIP-OriginatorSid | Select-Object -ExpandProperty value
if (!$msRO) {$msRO = "Not found"}
"msRTCSIP-OriginatorSid = $msRO"

$msES = Get-ADUser $TheDude -Server domain.com -Properties * | Select-Object -ExpandProperty msExchMasterAccountSid | Select-Object -ExpandProperty value
if (!$msES) {$msES = "Not Found"}
"msExchMasterAccountSid = $msES"



[Microsoft.VisualBasic.Interaction]::MsgBox("RTCSIP-OriginatorSid = $msRO`nExchMasterAccountSid = $msES",0,"Results")

#$wshell = New-Object -ComObject Wscript.Shell -ErrorAction Stop
#$wshell.Popup("msRTCSIP-OriginatorSid = $msRO`nmsExchMasterAccountSid = $msES",0,"Current Values",64)