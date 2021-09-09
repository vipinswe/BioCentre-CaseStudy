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
# This script shows you to import a CSV into a SQL database using the PowerShell SQL Module
##############################################
# Requirements:
# - A SQL server, instance, credentials, and the DB already created from the Create script
# - A CSV file
################################################
# Configure variables below for connecting to the SQL database
################################################
$CSVFileName = "/Users/mac/Downloads/BioCentreCaseStudy/Outputs/Top3SoldProductsForQuarter.csv"
$SQLInstance = "localhost"
$SQLDatabase = "AdventureWorks2019"
$SQLTable = "Sales.MostSoldProductsForQuarterReport"
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
# Importing CSV and processing data
##############################################
$CSVImport = Import-CSV $CSVFileName
$CSVRowCount = $CSVImport.Count
##############################################
# ForEach CSV Line Inserting a row into the SQL table
##############################################
Write-Verbose "Inserting $CSVRowCount rows from CSV into SQL Table"
Try
{
	ForEach ($CSVLine in $CSVImport)
	{
		Write-Verbose "Import started"
		# Setting variables for the CSV line, ADD ALL possible CSV columns here
		$CSVQuarter = $CSVLine.Quarter
		$CSVProduct1Name = $CSVLine.Product1Name -replace "'","''"
		$CSVProduct1TotalQty = $CSVLine.Product1TotalQty
		$CSVProduct2Name = $CSVLine.Product2Name -replace "'","''"
		$CSVProduct2TotalQty = $CSVLine.Product2TotalQty
		$CSVProduct3Name = $CSVLine.Product3Name -replace "'","''"
		$CSVProduct3TotalQty = $CSVLine.Product3TotalQty
		$CSVProductsTotalInQuarter = $CSVLine.{Total Number of All Products In Quarter}
		# Translating Date to SQL compatible format
		##############################################
		# SQL INSERT of CSV Line
		##############################################
		$SQLInsert = "USE $SQLDatabase
		INSERT INTO $SQLTable (Quarter, Product1Name, Total1Quantity, Product2Name, Total2Quantity, Product3Name, Total3Quantity, ProductsTotalInQuarter)
VALUES('$CSVQuarter','$CSVProduct1Name',$CSVProduct1TotalQty,'$CSVProduct2Name',$CSVProduct2TotalQty,'$CSVProduct3Name', $CSVProduct3TotalQty,$CSVProductsTotalInQuarter);"		
		# Running the INSERT Query
		Write-Verbose $SQLInsert
		Invoke-SQLCmd -Query $SQLInsert -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
		# End of ForEach CSV line below
	}
	# End of ForEach CSV line above
	##############################################
	Write-Verbose "Import end"
	##############################################
	# End of time taken benchmark
	##############################################
	$End = Get-Date
	$TimeTaken = New-Timespan -Start $Start -End $End | Select -ExpandProperty 	TotalSeconds
	$TimeTaken = [Math]::Round($TimeTaken, 0)
	Write-Verbose "Data Export Finished In $TimeTaken Seconds"
	Write-Host "Inserted $CSVRowCount rows from CSV into SQL Table in $TimeTaken Seconds"
	LogWrite "Data Export Finished in $TimeTaken Seconds"
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
