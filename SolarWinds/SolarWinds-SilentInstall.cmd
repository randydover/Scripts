@echo off
REM This script installs the SolarWinds agent and connects it to Monitoring.Airnetgroup.com

Echo.
Echo        Installing SolarWinds agent...
msiexec /I C:\Installs\SolarWinds\Solarwinds-Agent.msi /qn TRANSFORMS=C:\Installs\SolarWinds\SolarWinds-Agent.mst





===================================================================================
REM This script was written by Randy Dover, rdover@airnetgroup.com.
REM This script may be modified for use, but these lines giving credit should remain in place.