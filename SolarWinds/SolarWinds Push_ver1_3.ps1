<#
This script installs SolarWinds agent to remote computers
Ver 1.3 20200602 Changing variable names to make it easier to read
Ver 1.2 20200602 Change to "Copy-Item" and not using "Send-File.ps1"
Ver 1.1 20191231
Written by Randy Dover, Airnet Group, Inc., professionalservices@airnetgroup.com or support@airnetgroup.com
Script may be modified, by credit may not be removed

.NOTATIONS 
A list of servers the agents are to be installed on needs to be saved in C:\Installs\SolarWinds, with the name of "Computers.txt"
    Each server must be on its own line with no comma or other punctuation
The script will install the SolarWinds and connect them to the Monitoring portal

#>

#This section gives instruction to copy the required files to the Installation folder
Clear-Host
Write-Host " "
Write-Host "Before proceeding..." -ForegroundColor Yellow
Write-Host "Copy the SolarWinds-Agent.msi file into the C:\Installs\SolarWinds folder" -ForegroundColor Yellow
Write-Host "Copy the SolarWinds-Agent.mst file into the C:\Installs\SolarWinds folder" -ForegroundColor Yellow
Write-Host "Save the list of computers to be installed on in a file named computers.txt into the C:\Installs\SolarWinds folder" -ForegroundColor Yellow
[void](Read-Host 'Press Enter to continue…')

$cred = Get-Credential 

#This section sets the variables
$Computers = Get-Content -Path C:\Installs\SolarWinds\Computers.txt
$InstallsFolder = "\Installs"
$SolarWindsFolder = "SolarWinds"
$SolarWindsFileName = "SolarWinds-Agent.msi"
$SolarWindsFileAndPath = $InstallsFolder + "\" + $SolarWindsFolder + "\" + $SolarWindsFileName
$SolarWindsMSTFileName = "SolarWinds-Agent.mst"
$SolarWindsMSTFileAndPath = $InstallsFolder + "\" + $SolarWindsFolder + "\" + $SolarWindsMSTFileName
$SolarWindsinstallstring = 'C:\Installs\SolarWinds\Solarwinds-Agent.msi /qn TRANSFORMS=C:\Installs\SolarWinds\SolarWinds-Agent.mst'

#This section does the actual install of the agents#This section does the actual install of the agents 
foreach ($computer in $computers){
    $pssession = New-PSSession -ComputerName $computer -Credential $cred
  
    New-Item -path FileSystem::\\$computer\c$\$InstallsFolder -type directory -Force
    New-Item -path FileSystem::\\$computer\c$\$InstallsFolder\$SolarWindsFolder -type directory -Force
    Copy-Item "$InstallsFolder\$SolarWindsFolder\$SolarWindsFileName" -Destination "\\$Computer\$InstallsFolder\$SolarWindsFolder"
    Copy-Item "$InstallsFolder\$SolarWindsFolder\$SolarWindsMSTFileName" -Destination "\\$Computer\$InstallsFolder\$SolarWindsFolder" 
    Invoke-Command -Session $pssession -ScriptBlock {
 
        CMD.exe /C $using:SolarWindsinstallstring
    }
    Remove-PSSession -Session $pssession
 }

 Write-Host "Agents have been installed" -ForegroundColor Yellow
[void](Read-Host 'Press Enter to continue…')