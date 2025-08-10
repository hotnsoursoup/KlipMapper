# Luxe Nails POS - Advanced Portable Package Creator
# PowerShell version with automatic dependency download

param(
    [switch]$IncludeRedist = $false,
    [switch]$CreateZip = $false,
    [string]$OutputDir = "portable_release"
)

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Luxe Nails POS - Portable Package Creator" -ForegroundColor Cyan
Write-Host "PowerShell Advanced Version 1.0" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

$ReleaseDir = "build\windows\x64\runner\Release"
$VcRedistUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"

# Check if release build exists
Write-Host "[1/8] Checking release build..." -ForegroundColor Yellow
if (-not (Test-Path "$ReleaseDir\luxe_pos.exe")) {
    Write-Host "❌ Release build not found!" -ForegroundColor Red
    Write-Host "Please run 'build_release.bat' first to create the Windows release." -ForegroundColor Red
    Write-Host "Expected location: $ReleaseDir\luxe_pos.exe" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "✅ Release build found" -ForegroundColor Green

# Create directory structure
Write-Host "[2/8] Creating portable directory structure..." -ForegroundColor Yellow
if (Test-Path $OutputDir) {
    Remove-Item $OutputDir -Recurse -Force
}

New-Item -ItemType Directory -Path $OutputDir | Out-Null
New-Item -ItemType Directory -Path "$OutputDir\app" | Out-Null
New-Item -ItemType Directory -Path "$OutputDir\redist" | Out-Null
New-Item -ItemType Directory -Path "$OutputDir\docs" | Out-Null

# Copy application files
Write-Host "[3/8] Copying application files..." -ForegroundColor Yellow
Copy-Item "$ReleaseDir\luxe_pos.exe" "$OutputDir\app\"
Copy-Item "$ReleaseDir\flutter_windows.dll" "$OutputDir\app\"
Copy-Item "$ReleaseDir\flutter_secure_storage_windows_plugin.dll" "$OutputDir\app\"
Copy-Item "$ReleaseDir\sqlite3.dll" "$OutputDir\app\"
Copy-Item "$ReleaseDir\sqlite3_flutter_libs_plugin.dll" "$OutputDir\app\"
Copy-Item "$ReleaseDir\data" "$OutputDir\app\data" -Recurse

# Copy assets if they exist
if (Test-Path "assets\database") {
    Copy-Item "assets\database" "$OutputDir\app\assets\database" -Recurse
}
if (Test-Path "assets\icons") {
    Copy-Item "assets\icons" "$OutputDir\app\assets\icons" -Recurse
}

# Download VC++ Redistributable if requested
if ($IncludeRedist) {
    Write-Host "[4/8] Downloading Visual C++ Redistributable..." -ForegroundColor Yellow
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $VcRedistUrl -OutFile "$OutputDir\redist\VC_redist.x64.exe"
        Write-Host "✅ VC++ Redistributable downloaded" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️ Failed to download VC++ Redistributable: $_" -ForegroundColor Yellow
        Write-Host "You can manually download it from: $VcRedistUrl" -ForegroundColor Yellow
    }
} else {
    Write-Host "[4/8] Skipping VC++ Redistributable download (use -IncludeRedist to include)" -ForegroundColor Yellow
}

# Create enhanced launcher
Write-Host "[5/8] Creating launcher script..." -ForegroundColor Yellow
$LauncherContent = @'
@echo off
setlocal

echo ==========================================
echo Luxe Nails POS - Portable Launcher
echo ==========================================
echo.

cd /d "%~dp0app"

echo Checking system requirements...

REM Check if we're on 64-bit Windows
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    if not "%PROCESSOR_ARCHITEW6432%"=="AMD64" (
        echo ❌ This application requires 64-bit Windows
        pause
        exit /b 1
    )
)

REM Check if Visual C++ Redistributable is available
echo Checking Visual C++ Redistributable...
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Microsoft Visual C++ 2022" >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Visual C++ Redistributable 2022 not found
    echo.
    if exist "..\redist\VC_redist.x64.exe" (
        echo Would you like to install it now? (Y/N)
        set /p choice=
        if /i "!choice!"=="Y" (
            echo Installing Visual C++ Redistributable...
            "..\redist\VC_redist.x64.exe" /quiet
            echo Installation completed. Please restart this launcher.
            pause
            exit /b 0
        )
    ) else (
        echo Please download and install Visual C++ Redistributable 2022 x64
        echo Download from: https://aka.ms/vs/17/release/vc_redist.x64.exe
        echo.
    )
)

echo Starting Luxe Nails POS...
echo.
echo 🎯 Fullscreen Mode: Press F11 or Alt+Enter to toggle
echo 🚪 Exit Application: Press Escape
echo.

luxe_pos.exe
set EXIT_CODE=%ERRORLEVEL%

if not %EXIT_CODE%==0 (
    echo.
    echo ❌ Application exited with error code: %EXIT_CODE%
    echo.
    echo Troubleshooting steps:
    echo 1. Ensure Visual C++ Redistributable 2022 is installed
    echo 2. Check that all files are present in the app folder
    echo 3. Run "System Check.bat" for detailed system information
    echo 4. Try running as Administrator
    echo.
    pause
)
'@

$LauncherContent | Out-File -FilePath "$OutputDir\Launch Luxe Nails POS.bat" -Encoding ASCII

# Create system check script
Write-Host "[6/8] Creating system diagnostics..." -ForegroundColor Yellow
$SystemCheckContent = @'
@echo off
echo ==========================================
echo Luxe Nails POS - System Diagnostics
echo ==========================================
echo.

echo Windows Version:
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
echo.

echo Processor:
systeminfo | findstr /B /C:"Processor"
echo.

echo Memory:
systeminfo | findstr /B /C:"Total Physical Memory"
echo.

echo .NET Framework versions:
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s /v Version 2>nul | findstr Version

echo.
echo Visual C++ Redistributables:
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Microsoft Visual C++" 2>nul | findstr DisplayName

echo.
echo Disk Space (current drive):
dir | findstr "bytes free"

echo.
echo ==========================================
echo System Check Complete
echo ==========================================
pause
'@

$SystemCheckContent | Out-File -FilePath "$OutputDir\System Check.bat" -Encoding ASCII

# Create documentation
Write-Host "[7/8] Creating documentation..." -ForegroundColor Yellow
$ReadmeContent = @"
# Luxe Nails POS - Portable Distribution

## Quick Start
1. Double-click **Launch Luxe Nails POS.bat**
2. If prompted, install Visual C++ Redistributable
3. Application will start in fullscreen mode

## System Requirements
- Windows 10 or Windows 11 (64-bit)
- 4GB RAM minimum
- 500MB free disk space
- Visual C++ Redistributable 2022 (automatically installed if needed)

**No development tools or additional software required!**

## Controls
- **F11** or **Alt+Enter**: Toggle fullscreen mode
- **Escape**: Exit application
- **Mouse/Touch**: Navigate interface

## File Structure
```
portable_release/
├── Launch Luxe Nails POS.bat    # Main launcher
├── System Check.bat             # System diagnostics
├── app/                         # Application files
│   ├── luxe_pos.exe            # Main executable
│   ├── flutter_windows.dll     # Flutter engine
│   ├── flutter_secure_storage_windows_plugin.dll  # Security plugin
│   ├── sqlite3.dll             # SQLite database
│   ├── sqlite3_flutter_libs_plugin.dll           # SQLite plugin
│   ├── data/                   # App resources
│   └── assets/                 # Database & icons
├── redist/                     # Redistributables
└── docs/                       # Documentation
```

## Kiosk Mode Setup
For automatic startup:
1. Press **Windows Key + R**
2. Type: `shell:startup`
3. Copy **Launch Luxe Nails POS.bat** to that folder

## Troubleshooting

### Application won't start
1. Run **System Check.bat** to verify system compatibility
2. Install Visual C++ Redistributable from redist/ folder
3. Try running **Launch Luxe Nails POS.bat** as Administrator

### Performance issues
- Close unnecessary applications
- Ensure adequate free disk space (500MB+)
- Check that antivirus isn't blocking the application

### Database problems
- Ensure app/ folder has write permissions
- Don't move files out of the app/ folder
- Contact support if database becomes corrupted

## Distribution
To share this application:
1. Zip the entire portable_release folder
2. Share the zip file
3. Recipients extract and run the launcher

## Support
- Technical Support: support@luxenails.com
- Documentation: See docs/ folder
- System Issues: Run System Check.bat

**Version**: 1.0.0  
**Build Date**: $(Get-Date -Format "yyyy-MM-dd HH:mm")  
**Distribution Type**: Portable
"@

$ReadmeContent | Out-File -FilePath "$OutputDir\docs\README.md" -Encoding UTF8

# Create zip if requested
if ($CreateZip) {
    Write-Host "[8/8] Creating zip archive..." -ForegroundColor Yellow
    $ZipPath = "LuxeNails_POS_Portable_v1.0.0.zip"
    if (Test-Path $ZipPath) {
        Remove-Item $ZipPath
    }
    Compress-Archive -Path $OutputDir -DestinationPath $ZipPath
    Write-Host "✅ Zip created: $ZipPath" -ForegroundColor Green
} else {
    Write-Host "[8/8] Skipping zip creation (use -CreateZip to include)" -ForegroundColor Yellow
}

# Show results
Write-Host ""
Write-Host "✅ Portable package created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📦 Location: $((Get-Location).Path)\$OutputDir" -ForegroundColor Cyan
Write-Host "📦 Total Size: $([math]::Round((Get-ChildItem $OutputDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Package contents:" -ForegroundColor Cyan
Get-ChildItem $OutputDir | ForEach-Object { Write-Host "   $($_.Name)" -ForegroundColor White }
Write-Host ""
Write-Host "🚀 To test: Double-click '$OutputDir\Launch Luxe Nails POS.bat'" -ForegroundColor Yellow
Write-Host ""
Write-Host "💾 To distribute:" -ForegroundColor Yellow
Write-Host "   1. Zip the '$OutputDir' folder" -ForegroundColor White
Write-Host "   2. Share the zip file" -ForegroundColor White
Write-Host "   3. Recipients extract and run the launcher" -ForegroundColor White

if ($CreateZip) {
    Write-Host ""
    Write-Host "📦 Ready-to-distribute zip: LuxeNails_POS_Portable_v1.0.0.zip" -ForegroundColor Green
}

Write-Host ""
Read-Host "Press Enter to continue"