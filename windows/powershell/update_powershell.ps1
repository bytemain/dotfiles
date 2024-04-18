Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module powershellget -Force
Install-Module PackageManagement -Force
Install-Module PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module -Scope CurrentUser posh-git -Force
Install-Module -Scope CurrentUser oh-my-posh -Force
