param (
    [string]$Compiler = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe",
    [string]$File = $null,
    [string]$Icon = "Ghosty"
)
$defaultScript = "ahkAutorun.ahk" # name AND extension of the script if no param.

# Set File Path to default if not passed (default Script in script DIR)
if (-not $File) {
    Write-Host "No script specified. Using default: $defaultScript"
    $myDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $File = Join-Path $myDir $defaultScript
}


if ((Split-Path -Leaf $File) -eq "ahkAutorun.ahk") {
    $ScriptDir = Split-Path -Parent $File
    $PreComp = Join-Path $ScriptDir "PreComp.ahk"
    Start-Process -FilePath $PreComp -Wait
}

# Get Path for Output and Icon
$ahkOutput = [System.IO.Path]::ChangeExtension($File, ".exe")
$ahkIcon = Join-Path (Split-Path $File -Parent) "$Icon.ico"


# Kill and remove previous ver (Compiler get's mad if old file exists)
$scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ahkOutput)
Get-Process -Name $scriptName | Stop-Process -Force
Start-Sleep -Milliseconds 500
Remove-Item $ahkOutput -Force

# Compile
& $Compiler /in $File /out $ahkOutput /icon $ahkIcon

# Wait for compiled file to be created, then run it
$timeout = 5000     # Max total wait time
$sleepTime = 200    # How often to retry
$totalTime = 0
while (-not (Test-Path $ahkOutput) -and $totalTime -lt $timeout) {
    Start-Sleep -Milliseconds $sleepTime
    $totalTime += $sleepTime
}

# RUN
Start-Process $ahkOutput