$ComputerManufacturer = (Get-WmiObject -Class "Win32_ComputerSystem" | Select-Object -ExpandProperty Manufacturer).Trim()
switch -Wildcard ($ComputerManufacturer)
{
    "*HP*"
    {
        $IsPasswordSet = (Get-WmiObject -Namespace root/hp/InstrumentedBIOS -Class HP_BIOSSetting | Where-Object Name -eq "Setup Password").IsSet
    }
    "*Hewlett-Packard*"
    {
        $IsPasswordSet = (Get-WmiObject -Namespace root/hp/InstrumentedBIOS -Class HP_BIOSSetting | Where-Object Name -eq "Setup Password").IsSet
    }
    "*Lenovo*"
    {
        $IsPasswordSet = (Get-WmiObject -Namespace root/wmi -Class Lenovo_BiosPasswordSettings).PasswordState
    }
    "*Dell*"
    {
        $CurrentExecutionPolicy = Get-ExecutionPolicy
        Set-ExecutionPolicy Unrestricted
        $RequiredModules = @("NuGet","DellBIOSProvider")
        $RequiredModules | ForEach-Object {
            If (Get-Module -ListAvailable -Name $PSItem)
            {
                Import-Module $PSItem -Force
            }
            Else
            {
                Install-Module -Name $PSItem -Force -Confirm
            }
            Start-Sleep -Seconds 5
        }
		
		$IsPasswordSet = (Get-Item -Path DellSmbios:\Security\IsAdminPasswordSet).currentvalue
        Set-ExecutionPolicy $CurrentExecutionPolicy
    }
}


switch ($IsPasswordSet)
{
    "1"
    {
        Write-Output "Your BIOS is password protected"	
		Exit 0
    }
    "2"
    {
        Write-Output "Your BIOS is password protected"	
		Exit 0
    }
    "True"
    {
        Write-Output "Your BIOS is password protected"	
		Exit 0
    }
    default
    {
        Write-Output "Your BIOS is not password protected"	
		Exit 1
    }
}
