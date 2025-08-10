# POS Flutter Application Deployment Script v0.01
# Run this in PowerShell as Administrator

param(
    [Parameter()]
    [string]$TargetPath = "C:\Program Files\POS Flutter",
    
    [Parameter()]
    [switch]$CreateShortcuts = $true,
    
    [Parameter()]
    [switch]$Portable = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "POS Flutter Application Deployment v0.01" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if build exists
$BuildPath = "build\windows\x64\runner\Release"
if (-not (Test-Path $BuildPath)) {
    Write-Host "❌ Build not found! Please run 'flutter build windows --release' first." -ForegroundColor Red
    Write-Host "Expected path: $BuildPath" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Build found at: $BuildPath" -ForegroundColor Green

if ($Portable) {
    # Portable deployment
    $TargetPath = Read-Host "Enter portable installation path (e.g., D:\PortableApps\POS)"
    Write-Host "📦 Creating portable installation at: $TargetPath" -ForegroundColor Yellow
} else {
    # Standard installation
    Write-Host "📦 Installing to: $TargetPath" -ForegroundColor Yellow
    
    # Check admin rights for system installation
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "⚠️  Administrator rights required for system installation." -ForegroundColor Yellow
        Write-Host "Please run PowerShell as Administrator or use -Portable flag." -ForegroundColor Yellow
        exit 1
    }
}

try {
    # Create target directory
    if (-not (Test-Path $TargetPath)) {
        New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
        Write-Host "📁 Created directory: $TargetPath" -ForegroundColor Green
    }

    # Copy application files
    Write-Host "📋 Copying application files..." -ForegroundColor Yellow
    Copy-Item -Path "$BuildPath\*" -Destination $TargetPath -Recurse -Force
    Write-Host "✅ Application files copied successfully" -ForegroundColor Green

    # Copy database files if they exist
    if (Test-Path "assets\database") {
        $DbPath = Join-Path $TargetPath "assets\database"
        if (-not (Test-Path $DbPath)) {
            New-Item -ItemType Directory -Path $DbPath -Force | Out-Null
        }
        Copy-Item -Path "assets\database\*" -Destination $DbPath -Force
        Write-Host "✅ Database files copied" -ForegroundColor Green
    }

    # Create shortcuts
    if ($CreateShortcuts -and -not $Portable) {
        Write-Host "🔗 Creating shortcuts..." -ForegroundColor Yellow
        
        # Desktop shortcut
        $WshShell = New-Object -ComObject WScript.Shell
        $DesktopPath = [Environment]::GetFolderPath("Desktop")
        $Shortcut = $WshShell.CreateShortcut("$DesktopPath\POS Flutter.lnk")
        $Shortcut.TargetPath = Join-Path $TargetPath "pos.exe"
        $Shortcut.WorkingDirectory = $TargetPath
        $Shortcut.Description = "POS Flutter Application v0.01"
        $Shortcut.Save()
        
        # Start Menu shortcut
        $StartMenuPath = Join-Path ([Environment]::GetFolderPath("CommonPrograms")) "POS Flutter"
        if (-not (Test-Path $StartMenuPath)) {
            New-Item -ItemType Directory -Path $StartMenuPath -Force | Out-Null
        }
        $Shortcut = $WshShell.CreateShortcut("$StartMenuPath\POS Flutter.lnk")
        $Shortcut.TargetPath = Join-Path $TargetPath "pos.exe"
        $Shortcut.WorkingDirectory = $TargetPath
        $Shortcut.Description = "POS Flutter Application v0.01"
        $Shortcut.Save()
        
        Write-Host "✅ Shortcuts created" -ForegroundColor Green
    }

    # Set permissions
    Write-Host "🔐 Setting permissions..." -ForegroundColor Yellow
    $Acl = Get-Acl $TargetPath
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $Acl.SetAccessRule($AccessRule)
    Set-Acl -Path $TargetPath -AclObject $Acl
    Write-Host "✅ Permissions set" -ForegroundColor Green

    Write-Host ""
    Write-Host "🎉 Deployment completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 Installation location: $TargetPath" -ForegroundColor Cyan
    Write-Host "🚀 Executable: $(Join-Path $TargetPath 'pos.exe')" -ForegroundColor Cyan
    
    if ($CreateShortcuts -and -not $Portable) {
        Write-Host "🔗 Desktop shortcut: Created" -ForegroundColor Cyan
        Write-Host "📋 Start Menu: Created" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "▶️  To launch the application:" -ForegroundColor Yellow
    if ($Portable) {
        Write-Host "   Navigate to $TargetPath and run pos.exe" -ForegroundColor White
    } else {
        Write-Host "   Use desktop shortcut or Start Menu" -ForegroundColor White
    }

} catch {
    Write-Host ""
    Write-Host "❌ Deployment failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")