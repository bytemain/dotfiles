
echo 下面代码，在管理员权限cmd中运行，在管理员权限powershell中运行均可。
echo 如果使用powershell remoting远程。本机，远程机，都要用管理员权限运行一遍。
echo 本【开启权限的脚本】，win7，win8，win10，win2008，win2012，win2016，win2019通用。
"C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe" -command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"
"C:\WINDOWS\syswow64\windowspowershell\v1.0\powershell.exe" -command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"
& "C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe" -command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"
& "C:\WINDOWS\syswow64\windowspowershell\v1.0\powershell.exe" -command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"
powershell.exe -c "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"
pause




