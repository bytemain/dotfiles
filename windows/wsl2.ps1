# [Config]
$wsl_hosts = "wsl.local"
$win_hosts = "win.local"
$HOSTS_PATH = "$env:windir\System32\drivers\etc\hosts"

# [Start]
$winip = (bash.exe -c "ip route | grep default | awk '{print \`$3}'")
$wslip = (bash.exe -c "hostname -I | awk '{print \`$1}'")
$found1 = $winip -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
$found2 = $wslip -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if( !($found1 -and $found2) ){
  echo "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

# [Ports]
# control whether forward port from windows to wsl
$redirect_port = $FALSE

if ($redirect_port) {
  # All the ports you want to forward separated by coma
  $ports=@(80,443,8080);

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
}

# [Hosts]
# Get hosts file Content
$HOSTS_CONTENT = (Get-Content -Path $HOSTS_PATH) | ? {$_.trim() -ne "" } | Select-String -Pattern '# w(sl)|(in)_hosts' -NotMatch
# add custom hosts into hosts content
$HOSTS_CONTENT = $HOSTS_CONTENT + "`n$wslip $wsl_hosts # wsl_hosts`n$winip $win_hosts # win_hosts"
# write file
Out-File -FilePath $HOSTS_PATH -InputObject $HOSTS_CONTENT -Encoding ASCII

ipconfig /flushdns | Out-Null
