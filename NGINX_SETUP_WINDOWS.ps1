# Nginx Setup Script for Windows VPS
# Run as Administrator: .\NGINX_SETUP_WINDOWS.ps1

Write-Host "=========================================" -ForegroundColor Green
Write-Host "🔧 Nginx Setup for Windows VPS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

$NGINX_DIR = "C:\nginx"
$CONFIG_FILE = "$NGINX_DIR\conf\nginx.conf"

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "❌ Please run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell → Run as Administrator" -ForegroundColor Yellow
    exit 1
}

# Check if Nginx is installed
if (-not (Test-Path $NGINX_DIR)) {
    Write-Host "❌ Nginx not found at: $NGINX_DIR" -ForegroundColor Red
    Write-Host ""
    Write-Host "📥 Please download Nginx:" -ForegroundColor Yellow
    Write-Host "   1. Go to: http://nginx.org/en/download.html" -ForegroundColor White
    Write-Host "   2. Download: nginx/Windows-x.x.x" -ForegroundColor White
    Write-Host "   3. Extract to: C:\nginx" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "✅ Nginx found at: $NGINX_DIR" -ForegroundColor Green
Write-Host ""

# Backup original config
if (Test-Path $CONFIG_FILE) {
    $backupFile = "$CONFIG_FILE.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $CONFIG_FILE -Destination $backupFile
    Write-Host "✅ Backup created: $backupFile" -ForegroundColor Green
}

Write-Host "📝 Creating Nginx configuration..." -ForegroundColor Cyan

# Create nginx config
$nginxConfig = @"
server {
    listen 80;
    server_name paing.xyz www.paing.xyz;

    # Redirect www to non-www
    if (`$host = 'www.paing.xyz') {
        return 301 http://paing.xyz`$request_uri;
    }

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host `$host;
        proxy_set_header X-Real-IP `$remote_addr;
        proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto `$scheme;
        proxy_read_timeout 90;
    }
}
"@

# Write config to file (append to existing nginx.conf or create new)
# Note: This is a simplified config - you may need to edit nginx.conf manually
Write-Host ""
Write-Host "⚠️  Manual Configuration Required:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Open: $CONFIG_FILE" -ForegroundColor White
Write-Host "2. Add the server block inside http { } section" -ForegroundColor White
Write-Host "3. Or replace the entire file with the config from NGINX_CONFIG_WINDOWS.conf" -ForegroundColor White
Write-Host ""

# Check if Flask is running
$flaskRunning = Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue
if ($flaskRunning) {
    Write-Host "✅ Flask app is running on port 5000" -ForegroundColor Green
} else {
    Write-Host "⚠️  Flask app is NOT running on port 5000" -ForegroundColor Yellow
    Write-Host "   Start Flask first: python web_app.py" -ForegroundColor White
}

Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host "   1. Edit: $CONFIG_FILE" -ForegroundColor White
Write-Host "   2. Add server block (see NGINX_CONFIG_WINDOWS.conf)" -ForegroundColor White
Write-Host "   3. Test config: cd $NGINX_DIR; .\nginx.exe -t" -ForegroundColor White
Write-Host "   4. Start Nginx: cd $NGINX_DIR; start nginx" -ForegroundColor White
Write-Host "   5. Open firewall: New-NetFirewallRule -DisplayName 'Nginx HTTP' -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow" -ForegroundColor White
Write-Host ""

