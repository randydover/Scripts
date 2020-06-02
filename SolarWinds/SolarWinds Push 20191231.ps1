<#
This script installs SolarWinds agent to remote computers
Ver 1.1 20191231
Written by Randy Dover, Airnet Group, Inc., professionalservices@airnetgroup.com or support@airnetgroup.com
Script may be modified, by credit may not be removed

Some code borrowed from Niklas Akerlund 2015-10-13 https://vniklas.djungeln.se/2015/10/13/playing-with-automation-of-oms-agent-deployment/

.NOTATIONS 
A list of servers the agents are to be installed on needs to be saved in C:\Installs\SolarWinds, with the name of "Computers.txt"
    Each server must be on its own line with no comma or other punctuation
The script will install the SolarWinds and connect them to the Monitoring portal

#>

#The next line calls the Send-File Powershell script which will allow the files to be pushed to the target machines 
. .\Send-File.ps1

#This section gives instruction to copy the required files to the Installation folder
Clear-Host
Write-Host " "
Write-Host "Before proceeding..." -ForegroundColor Yellow
Write-Host "Copy the SolarWinds-Agent.msi file into the C:\Installs\SolarWinds folder" -ForegroundColor Yellow
Write-Host "Copy the SolarWinds-Agent.mst file into the C:\Installs\SolarWinds folder" -ForegroundColor Yellow
Write-Host "Copy the Send-File.ps1 file into the C:\Installs\SolarWinds folder" -ForegroundColor Yellow
Write-Host "Save the list of computers to be installed on in a file named computers.txt into the C:\Installs\SolarWinds folder" -ForegroundColor Yellow
[void](Read-Host 'Press Enter to continue…')

$cred = Get-Credential 

#This section sets the variables
$Computers = Get-Content -Path C:\Installs\SolarWinds\Computers.txt 
$InstallFolder = "C:\Installs\SolarWinds"
$SolarWindsFileName = "SolarWinds-Agent.msi"
$SolarWindsFileAndPath = $InstallFolder + "\" + $SolarWindsFileName
$SolarWindsMSTFileName = "SolarWinds-Agent.mst"
$SolarWindsMSTFileAndPath = $InstallFolder + "\" + $SolarWindsMSTFileName
$targetpath = "C:\Installs\SolarWinds"
$SolarWindsinstallstring = 'C:\Installs\SolarWinds\Solarwinds-Agent.msi /qn TRANSFORMS=C:\Installs\SolarWinds\SolarWinds-Agent.mst'

#This section does the actual install of the agents#This section does the actual install of the agents 
foreach ($computer in $computers){
    $pssession = New-PSSession -ComputerName $computer -Credential $cred
  
    Send-File -Path $SolarWindsFileAndPath -Destination $targetpath -Session $pssession
    Send-File -Path $SolarWindsMSTFileAndPath -Destination $targetpath -Session $pssession
 
    Invoke-Command -Session $pssession -ScriptBlock {
 
        CMD.exe /C $using:SolarWindsinstallstring
    }
    Remove-PSSession -Session $pssession
 }

 Write-Host "Agents have been installed" -ForegroundColor Yellow
[void](Read-Host 'Press Enter to continue…')