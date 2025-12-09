# Create ZIP file for VPS (Handles Burmese characters)
# Run from local PC: .\CREATE_ZIP_FOR_VPS.ps1

Write-Host "=========================================" -ForegroundColor Green
Write-Host "📦 Creating ZIP for VPS Transfer" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

$SOURCE_DIR = Get-Location
$ZIP_FILE = "$SOURCE_DIR\Azone_For_VPS.zip"

Write-Host "📁 Source Directory: $SOURCE_DIR" -ForegroundColor Cyan
Write-Host "📦 ZIP File: $ZIP_FILE" -ForegroundColor Cyan
Write-Host ""

# Remove existing ZIP if exists
if (Test-Path $ZIP_FILE) {
    Write-Host "🗑️  Removing existing ZIP file..." -ForegroundColor Yellow
    Remove-Item $ZIP_FILE -Force
}

Write-Host "📋 Creating ZIP file (this may take a moment)..." -ForegroundColor Cyan

# Use .NET Compression to handle Unicode/Burmese characters
Add-Type -AssemblyName System.IO.Compression.FileSystem

try {
    # Create ZIP file
    [System.IO.Compression.ZipFile]::CreateFromDirectory($SOURCE_DIR, $ZIP_FILE, [System.IO.Compression.CompressionLevel]::Optimal, $true)
    
    $zipSize = (Get-Item $ZIP_FILE).Length / 1MB
    Write-Host ""
    Write-Host "✅ ZIP file created successfully!" -ForegroundColor Green
    Write-Host "   File: $ZIP_FILE" -ForegroundColor White
    Write-Host "   Size: $([math]::Round($zipSize, 2)) MB" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Copy this ZIP file to VPS via RDP" -ForegroundColor White
    Write-Host "   2. On VPS, extract to C:\Azone" -ForegroundColor White
    Write-Host "   3. Run: .\WINDOWS_VPS_SETUP.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "🌐 Or use Git sync method (no ZIP needed):" -ForegroundColor Cyan
    Write-Host "   Local: .\SYNC_TO_VPS.ps1" -ForegroundColor Yellow
    Write-Host "   VPS:   .\VPS_PULL_UPDATE.ps1" -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "❌ Error creating ZIP: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Alternative: Use Git sync method instead" -ForegroundColor Yellow
    Write-Host '   Run: .\SYNC_TO_VPS.ps1' -ForegroundColor White
    Write-Host ""
    exit 1
}
