$Get_Manufacturer_Info = (gwmi win32_computersystem).Manufacturer
If($Get_Manufacturer_Info -like "*HP*")
	{
		$IsPasswordSet = (Get-WmiObject -Namespace root/hp/instrumentedBIOS -Class HP_BIOSSetting | Where-Object Name -eq "Setup password").IsSet
	} 
ElseIf($Get_Manufacturer_Info -like "*Lenovo*")
	{
		$IsPasswordSet = (gwmi -Class Lenovo_BiosPasswordSettings -Namespace root\wmi).PasswordState
	} 
ElseIf($Get_Manufacturer_Info -like "*Dell*")
	{
		$module_name = "DellBIOSProvider"
		If (Get-Module -ListAvailable -Name $module_name){import-module $module_name -Force} 
		Else{Install-Module -Name DellBIOSProvider -Force}	
		$IsPasswordSet = (Get-Item -Path DellSmbios:\Security\IsAdminPasswordSet).currentvalue 	
	} 

If(($IsPasswordSet -eq 1) -or ($IsPasswordSet -eq "true") -or ($IsPasswordSet -eq $true) -or ($IsPasswordSet -eq 2))
	{
		write-output "Your BIOS is password protected"	
		Exit 0
	}
Else
	{
		write-output "Your BIOS isnot  password protected"	
		Exit 1
	}
