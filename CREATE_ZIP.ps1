# Create ZIP file for VPS (Handles Burmese characters)
$source = Get-Location
$zip = "$source\Azone_For_VPS.zip"

if (Test-Path $zip) {
    Remove-Item $zip -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($source, $zip, [System.IO.Compression.CompressionLevel]::Optimal, $true)

$size = [math]::Round((Get-Item $zip).Length / 1MB, 2)
Write-Host "ZIP created: $zip ($size MB)"

