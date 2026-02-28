$buildDir = $PSScriptRoot
$lovePath = "$buildDir\game.love"
$loveExe = "C:\Program Files\LOVE\love.exe"
$exeDir = "$buildDir\exe"
$outExe = "$exeDir\game.exe"

if (-not (Test-Path $lovePath)) {
    Write-Host "game.love not found, run build_love.ps1 first!"
    exit 1
}

New-Item -ItemType Directory -Force -Path $exeDir | Out-Null
if (Test-Path $outExe) { Remove-Item $outExe }

$loveBytes = [System.IO.File]::ReadAllBytes($loveExe)
$loveFileBytes = [System.IO.File]::ReadAllBytes($lovePath)
$merged = New-Object byte[] ($loveBytes.Length + $loveFileBytes.Length)
[System.Buffer]::BlockCopy($loveBytes, 0, $merged, 0, $loveBytes.Length)
[System.Buffer]::BlockCopy($loveFileBytes, 0, $merged, $loveBytes.Length, $loveFileBytes.Length)
[System.IO.File]::WriteAllBytes($outExe, $merged)
Write-Host "Fused: $outExe"

$loveDir = Split-Path $loveExe
@("love.dll","SDL2.dll","OpenAL32.dll","lua51.dll","mpg123.dll","msvcp120.dll","msvcr120.dll","license.txt") | ForEach-Object {
    $f = "$loveDir\$_"
    if (Test-Path $f) { Copy-Item $f -Destination $exeDir -Force; Write-Host "Copied $_" }
}