# [Config]
$wsl_hosts = "artin.wsl"
$win_hosts = "artin.win"
$HOSTS_PATH = "$env:windir\System32\drivers\etc\hosts"

# [Start]
$winip = bash.exe -c "ip route | grep default | awk '{print \`$3}'"
$wslip = bash.exe -c "hostname -I | awk '{print \`$1}'"
$found1 = $winip -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
$found2 = $wslip -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if( !($found1 -and $found2) ){
  echo "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

# [Ports]
# All the ports you want to forward separated by coma
$ports=@(80,443,10000,3000,5000,27701,8080);

# [Static ip]
# You can change the addr to your ip config to listen to a specific address
$addr='0.0.0.0';
$ports_a = $ports -join ",";

# Remove Firewall Exception Rules
iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' " | Out-Null

# Adding Exception Rules for inbound and outbound Rules
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP"  | Out-Null
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP"  | Out-Null

for( $i = 0; $i -lt $ports.length; $i++ ){
  $port = $ports[$i];
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr"  | Out-Null
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$wslip"  | Out-Null
}

(Get-Content -Path $HOSTS_PATH | Select-String -Pattern '# w(sl)|(in)_hosts' -NotMatch) + "$wslip $wsl_hosts # wsl_hosts`n$winip $win_hosts # win_hosts" | Out-File -FilePath $HOSTS_PATH -encoding ascii;

ipconfig /flushdns | Out-Null
