
echo ������룬�ڹ���ԱȨ��cmd�����У��ڹ���ԱȨ��powershell�����о��ɡ�
echo ���ʹ��powershell remotingԶ�̡�������Զ�̻�����Ҫ�ù���ԱȨ������һ�顣
echo ��������Ȩ�޵Ľű�����win7��win8��win10��win2008��win2012��win2016��win2019ͨ�á�
"C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe" -command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"
"C:\WINDOWS\syswow64\windowspowershell\v1.0\powershell.exe" -command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"
& "C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe" -command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"
& "C:\WINDOWS\syswow64\windowspowershell\v1.0\powershell.exe" -command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"
powershell.exe -c "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"
pause




