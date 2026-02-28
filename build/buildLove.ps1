$src = (Resolve-Path "$PSScriptRoot\..").Path
$buildDir = $PSScriptRoot
$lovePath = "$buildDir\game.love"

if (Test-Path $lovePath) { Remove-Item $lovePath }

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::Open($lovePath, 'Create')

Get-ChildItem -Path $src -Recurse -File | Where-Object {
    $_.FullName -notlike "*\build\*" -and $_.FullName -notlike "*\.vscode\*"
} | ForEach-Object {
    $relativePath = $_.FullName.Substring($src.Length + 1)
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $relativePath) | Out-Null
}

$zip.Dispose()
Write-Host "Done! Output: $lovePath"