# Restores notepad.exe.bak files to notepad.exe
# Make sure to run this as a local administrator

# System Paths
$nPaths = "$($env:systemroot)","$($env:systemroot)\System32","$($env:systemroot)\SysWOW64"

Foreach($Path in $nPaths)
{
	# Checks for the required paths before attempting changes.
	if (!$(Test-Path "$Path\Notepad.exe.bak")){continue}
	Write-Output "Notepad backup found, removing Notepad++ from $Path"
	Remove-Item "$Path\Notepad.exe" -Force
	
	Start-Sleep -Seconds 1
	Write-Output "Restoring $Path\Notepad.exe.bak to Notepad.exe  `r`n"
	Copy-Item -Path "$Path\Notepad.exe.bak" -destination "$Path\Notepad.exe" -Force

}