$VerbosePreference = "SilentlyContinue"
$Logfile = "/Users/mac/Downloads/BioCentreCaseStudy/Outputs/log.txt"
Function LogWrite{
	Param ([string]$logstring)
	Add-content $Logfile -value $logstring
}
########################################################################################################################
# Start of the script - Description
########################################################################################################################
# Written by: Vipin Vijayan vipinswe@gmail.com
################################################
# Description:
# This script shows you to export a SQL procedure output to CSV
##############################################
# Requirements:
# - A SQL server, instance, credentials, and the DB already created from backup
# - A stored procedure
################################################
# Configure variables below for connecting to the SQL database
################################################
$CSVFileName = "/Users/mac/Downloads/BioCentreCaseStudy/Outputs/Top5SuccessfullSalesPerson.csv"
$SQLInstance = "localhost"
$SQLDatabase = "AdventureWorks2019"
############################################################################################
# Prompting for SQL credentials
##############################################
$SQLCredentials = Get-Credential -Message "Enter your SQL username & password"
$SQLUsername = $SQLCredentials.UserName
$SQLPassword = $SQLCredentials.GetNetworkCredential().Password
##############################################
# Start of time taken benchmark
##############################################
$Start = Get-Date
##############################################
# Checking if SqlServer module is already installed, if not installing it
##############################################
Write-Verbose "start checking modules"
$SQLModuleCheck = Get-Module -ListAvailable SqlServer
if ($SQLModuleCheck -eq $null)
{
write-host "SqlServer Module Not Found - Installing"
# Not installed, trusting PS Gallery to remove prompt on install
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# Installing module
Install-Module -Name SqlServer –Scope CurrentUser -Confirm:$false -AllowClobber
Write-Verbose "SQL server modules installed"
}
Write-Verbose "end checking modules"
##############################################
# Importing SqlServer module
##############################################
Import-Module SqlServer
##############################################
# Exporting stored procedure output to CSV
##############################################
Try
{
	Write-Verbose "Writing csv file"
	##############################################
	Write-Verbose "Export started"
	Invoke-Sqlcmd -ServerInstance $SQLInstance -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query "EXEC dbo.uspGetTop5SuccessfullSalesPerson" | Export-Csv $CSVFileName -NoTypeInformation
	Write-Verbose "Export end"
	##############################################
	$End = Get-Date
	$TimeTaken = New-Timespan -Start $Start -End $End | Select -ExpandProperty TotalSeconds
$TimeTaken = [Math]::Round($TimeTaken, 0)
	Write-Verbose "Data Export Finished In $TimeTaken Seconds"
	LogWrite "Data Export Finished In $TimeTaken Seconds"
}
Catch
{
	$ErrorMessage = $_.Exception.Message	
	Write-Output "An error occurred during the export"
	LogWrite "An error occurred during the export - $ErrorMessage"
}
##############################################
# End of script
##############################################
