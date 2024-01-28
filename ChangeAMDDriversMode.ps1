#Requires -RunAsAdministrator
function Get-AMDDriversMode {
    $D3DVendorName = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name "D3DVendorName").D3DVendorName
    $D3DVendorName_dlls = ($D3DVendorName | ForEach-Object {Split-Path $_ -Leaf} | group).Name
    if ($D3DVendorName_dlls.Count -ne 2) {
        "Something wrong with registry settings"
        Return
    }
    $rdx_dlls = "atiumd64.dll", "atidxx64.dll"
    $rdx9dx11navi_dlls = "atiumd64.dll", "amdxx64.dll"
    $dx9navirdx11_dlls = "amdxn64.dll", "atidxx64.dll"
    $fullnavi_dlls = "amdxn64.dll", "amdxx64.dll"

    if ($null -eq (Compare-Object -ReferenceObject $D3DVendorName_dlls -DifferenceObject $rdx_dlls)) {
        $drivers_mode = "rdx"
    }

    if ($null -eq (Compare-Object -ReferenceObject $D3DVendorName_dlls -DifferenceObject $rdx9dx11navi_dlls)) {
        $drivers_mode = "rdx9dx11navi"
    }

    if ($null -eq (Compare-Object -ReferenceObject $D3DVendorName_dlls -DifferenceObject $dx9navirdx11_dlls)) {
        $drivers_mode = "dx9navirdx11"
    }

    if ($null -eq (Compare-Object -ReferenceObject $D3DVendorName_dlls -DifferenceObject $fullnavi_dlls)) {
        $drivers_mode = "fullnavi_dlls"
    }

    if ($drivers_mode) {
        return $drivers_mode
    } else {
        "Something wrong with registry settings"
    }
}

function Set-AMDDriversMode {
    #function parameters list
    param ([String]$mode)
    
    #getting current value from the Windows registry
    $D3DVendorName = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name "D3DVendorName").D3DVendorName
    $D3DVendorNameWoW = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name "D3DVendorNameWoW").D3DVendorNameWoW

    #check if values is set to the registry
    if (($D3DVendorNameWoW -eq $null) -or ($D3DVendorNameWoW -eq $null)) {
        "Something wrong with registry settings"
        Return
    }

    #extract dlls paths from the reqistry value
    $D3DVendorName_dlls = ($D3DVendorName | ForEach-Object {Split-Path $_ -Leaf} | group).Name
    $D3DVendorNameWoW_dlls = ($D3DVendorNameWoW | ForEach-Object {Split-Path $_ -Leaf} | group).Name

    #only two different dlls names must be setted for each values
    if (($D3DVendorName_dlls.Count -ne 2) -or ($D3DVendorNameWoW_dlls.Count -ne 2)) {
        "Something wrong with registry settings"
        Return
    }

    #search for dll names related to the function input
    Switch ($mode) {
        "rdx"           {$D3DVendorName_dlls = "atiumd64.dll", "atidxx64.dll"; $D3DVendorNameWoW_dlls = "atiumdag.dll", "atidxx32.dll"}
        "rdx9dx11navi"  {$D3DVendorName_dlls = "atiumd64.dll", "amdxx64.dll"; $D3DVendorNameWoW_dlls = "atiumdag.dll", "amdxx32.dll"}
        "dx9navirdx11"  {$D3DVendorName_dlls = "amdxn64.dll", "atidxx64.dll"; $D3DVendorNameWoW_dlls = "amdxn32.dll", "atidxx32.dll"}
        "fullnavi"      {$D3DVendorName_dlls = "amdxn64.dll", "amdxx64.dll"; $D3DVendorNameWoW_dlls = "amdxn32.dll", "amdxx32.dll"}
    }

    #check if dll found according to the function input
    if ($D3DVendorName_dlls -eq $null) {
        "Wrong function input"
        Return
    }

    #convert reference dll's names to the dll's list
    $D3DVendorName_dlls = @($D3DVendorName_dlls[0]) , @($D3DVendorName_dlls[0]) , @($D3DVendorName_dlls[1]), @($D3DVendorName_dlls[1])
    $D3DVendorNameWoW_dlls = @($D3DVendorNameWoW_dlls[0]) , @($D3DVendorNameWoW_dlls[0]) , @($D3DVendorNameWoW_dlls[1]), @($D3DVendorNameWoW_dlls[1])

    #creating new values for the Windows reqistry
    $D3DVendorName_paths = $($i=0; $D3DVendorName | ForEach-Object {Join-Path (Split-Path $_ -Parent) $D3DVendorName_dlls[$i].item(0);$i++})
    $D3DVendorNameWoW_paths = $($i=0; $D3DVendorNameWoW | ForEach-Object {Join-Path (Split-Path $_ -Parent) $D3DVendorNameWoW_dlls[$i].item(0);$i++})

    #setting new values to the Windows registry
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name "D3DVendorName" -Value $D3DVendorName_paths
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name "D3DVendorNameWoW" -Value $D3DVendorNameWoW_paths
    
}

$CurrentDriversMode = Get-AMDDriversMode

$Title = "Change AMD DirectX Driver Mode"
$Info = "Your current AMD drivers mode is: " + $CurrentDriversMode + [Environment]::NewLine
$Info = $Info + "Select new AMD Drivers Mode"
$rdx = New-Object System.Management.Automation.Host.ChoiceDescription ("&1`b`bRegular DX", "Factory AMD Default For Polaris, Vega, and Ryzen Vega APU")
$rdx9dx11navi = New-Object System.Management.Automation.Host.ChoiceDescription ("&2`b`bRegular DX9 with DX11 NAVI", "")
$dx9navirdx11 = New-Object System.Management.Automation.Host.ChoiceDescription ("&3`b`bDX9 NAVI with Regular DX11", "Factory AMD Default for RDNA 1")
$fullnavi = New-Object System.Management.Automation.Host.ChoiceDescription ("&4`b`bFull DXNAVI", "Factory AMD Default for RDNA 2")
$options = [System.Management.Automation.Host.ChoiceDescription[]]($rdx, $rdx9dx11navi, $dx9navirdx11, $fullnavi)
$defaultchoice = 0
$selected =  $host.UI.PromptForChoice($Title , $Info , $Options, $defaultchoice)
$options[$selected]

Set-AMDDriversMode "fullnavi"