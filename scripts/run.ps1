# Liga o emulador Pixel_7 (se necessario) e roda o app nele.
# Uso: powershell -ExecutionPolicy Bypass -File scripts\run.ps1
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
$env:Path = 'C:\dev\flutter\bin;' + $env:Path

$sdk = "$env:LOCALAPPDATA\Android\Sdk"
$adb = "$sdk\platform-tools\adb.exe"
$avd = 'Pixel_7'

if (-not ((& $adb devices) -match 'emulator-\d+\s+device')) {
    Write-Host "Ligando o emulador $avd..."
    Start-Process "$sdk\emulator\emulator.exe" -ArgumentList '-avd', $avd
    & $adb wait-for-device
    while ((& $adb shell getprop sys.boot_completed 2>$null) -notmatch '1') { Start-Sleep 2 }
    Write-Host 'Emulador pronto.'
}

$device = ((& $adb devices) -match 'emulator-\d+\s+device' | Select-Object -First 1).Split("`t")[0]
Write-Host "Rodando o app em $device (pressione r para recarregar, q para sair)..."
flutter run -d $device
