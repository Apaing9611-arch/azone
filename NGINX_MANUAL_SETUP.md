# Nginx Manual Setup Guide (Windows)

PowerShell error ရှိရင် manual setup လုပ်ပါ

---

## ⚠️ Important: Nginx Config ≠ PowerShell Script

Nginx configuration files က PowerShell scripts မဟုတ်ပါ။ Text editor နဲ့ edit လုပ်ရမယ်။

---

## 📋 Step-by-Step Setup

### Step 1: Download Nginx

1. Go to: http://nginx.org/en/download.html
2. Download: **nginx/Windows-x.x.x** (latest stable)
3. Extract to: `C:\nginx`

### Step 2: Edit Nginx Config File

**File Location:** `C:\nginx\conf\nginx.conf`

**Method 1: Notepad**
```powershell
notepad C:\nginx\conf\nginx.conf
```

**Method 2: VS Code**
```powershell
code C:\nginx\conf\nginx.conf
```

### Step 3: Add Server Block

`nginx.conf` file ထဲမှာ `http { }` section ထဲကို ဒီ code ကို ထည့်ပါ:

```nginx
server {
    listen 80;
    server_name paing.xyz www.paing.xyz;

    # Redirect www to non-www
    if ($host = 'www.paing.xyz') {
        return 301 http://paing.xyz$request_uri;
    }

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 90;
    }
}
```

**Example full nginx.conf:**
```nginx
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    server {
        listen 80;
        server_name paing.xyz www.paing.xyz;

        if ($host = 'www.paing.xyz') {
            return 301 http://paing.xyz$request_uri;
        }

        location / {
            proxy_pass http://127.0.0.1:5000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 90;
        }
    }
}
```

### Step 4: Test Nginx Config

```powershell
cd C:\nginx
.\nginx.exe -t
```

**Expected output:**
```
nginx: the configuration file C:\nginx/conf/nginx.conf syntax is ok
nginx: configuration file C:\nginx/conf/nginx.conf test is successful
```

### Step 5: Start Nginx

```powershell
cd C:\nginx
start nginx
```

### Step 6: Open Firewall Port 80

```powershell
New-NetFirewallRule -DisplayName "Nginx HTTP" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
```

### Step 7: Verify

1. **Check Nginx process:**
   ```powershell
   Get-Process nginx
   ```

2. **Test in browser:**
   - `http://paing.xyz`
   - `http://18.138.169.114`

---

## 🔄 Restart Nginx

```powershell
cd C:\nginx
nginx -s reload
```

---

## 🆘 Troubleshooting

### Config Syntax Error

```powershell
cd C:\nginx
.\nginx.exe -t
```

Error message ကို check လုပ်ပြီး config file edit လုပ်ပါ။

### Port 80 Already in Use

```powershell
# Find process using port 80
netstat -ano | findstr :80

# Kill process (replace PID)
taskkill /PID <PID> /F
```

### Nginx Won't Start

1. Check error log: `C:\nginx\logs\error.log`
2. Check if port 80 is available
3. Check if config syntax is correct

---

## ✅ Quick Reference

**Config File:** `C:\nginx\conf\nginx.conf`  
**Test Config:** `cd C:\nginx; .\nginx.exe -t`  
**Start:** `cd C:\nginx; start nginx`  
**Reload:** `cd C:\nginx; nginx -s reload`  
**Stop:** `cd C:\nginx; nginx -s stop`

---

**Remember:** Nginx config files က text files ဖြစ်တယ်။ PowerShell မှာ run လုပ်လို့မရဘူး။ Text editor နဲ့ edit လုပ်ပြီး nginx ကို configure လုပ်ရမယ်။

