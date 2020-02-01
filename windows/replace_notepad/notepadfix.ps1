<# 
Author: Bob@BobHodges.net
Date: Aug 11th, 2015
Description: Installs NotePad++ and replaces default notepad.exe with NotePad++ executable in system folders.
Note: The Install-Package cmdlet requires WMF5, install Notepad++ manually if you don't have it and comment out line 10. 
#> 

# Installs the latest version of NotePad++ from Chocolatey repo. 
# Comment out if you already have Notepad++ installed.
# Install-Package -Name NotePadPlusPlus -Force

# Paths to various required files
$Notepads = "$($env:systemroot)\Notepad.exe","$($env:systemroot)\System32\Notepad.exe","$($env:systemroot)\SysWOW64\Notepad.exe"
$NotepadPlus = Resolve-Path "$($env:systemdrive)\Program Files*\Notepad++\notepad++.exe"
$NotepadPlusDLL = Resolve-Path "$($env:systemdrive)\Program Files*\Notepad++\SciLexer.dll"

# Function to take ownership of the notepad files.
Function Set-Ownership($file)
{
	# The takeown.exe file should already exist in Win7 - Win10 
	try { & takeown /f $file }
	catch { Write-Output "Failed to take ownership of $file" }
}

# This function gives us permission to change the notepad.exe files.
Function Set-Permissions($file)
{
	$ACL = Get-Acl $file
	$AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "Allow")
	$ACL.SetAccessRule($AccessRule)
	$ACL | Set-Acl $file
}

# Loops through each notepad path.
Foreach($Notepad in $Notepads)
{
	# Checks for the required paths before attempting changes.
	if (!$(Test-Path $Notepad) -or !$(Test-Path $NotepadPlus)){continue}
	
	# Takes ownership of the file, then changes the NTFS permissions to allow us to rename it. 
	Set-Ownership $Notepad
	Set-Permissions $Notepad
	
	Write-Output "Replacing Notepad file: $Notepad `r`n"
	Rename-Item -Path $Notepad -NewName "Notepad.exe.bak" -ErrorAction SilentlyContinue
	
	# Copies the NotePad++ file and the dependant DLL file to the current path. 
	Copy-Item -Path $NotepadPlus -Destination $Notepad
	Copy-Item -Path $NotepadPlusDLL -Destination $(Split-Path $Notepad -Parent)
}
# Run Notepad++ once to avoid XML error.
& $NotepadPlus