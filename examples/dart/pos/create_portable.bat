@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo Luxe Nails POS - Portable Package Creator
echo Version 1.0
echo ==========================================
echo.

set PORTABLE_DIR=portable_release
set RELEASE_DIR=build\windows\x64\runner\Release

echo [1/6] Checking if release build exists...
if not exist "%RELEASE_DIR%\luxe_pos.exe" (
    echo ❌ Release build not found!
    echo Please run 'build_release.bat' first to create the Windows release.
    echo Expected location: %RELEASE_DIR%\luxe_pos.exe
    pause
    exit /b 1
)

echo ✅ Release build found
echo.

echo [2/6] Creating portable directory structure...
if exist "%PORTABLE_DIR%" (
    echo Removing existing portable directory...
    rmdir /s /q "%PORTABLE_DIR%"
)

mkdir "%PORTABLE_DIR%"
mkdir "%PORTABLE_DIR%\app"
mkdir "%PORTABLE_DIR%\redist"
mkdir "%PORTABLE_DIR%\docs"

echo [3/6] Copying application files...
echo Copying main executable...
copy "%RELEASE_DIR%\luxe_pos.exe" "%PORTABLE_DIR%\app\" >nul
if errorlevel 1 goto error

echo Copying Flutter engine...
copy "%RELEASE_DIR%\flutter_windows.dll" "%PORTABLE_DIR%\app\" >nul
if errorlevel 1 goto error

echo Copying plugin DLLs...
copy "%RELEASE_DIR%\flutter_secure_storage_windows_plugin.dll" "%PORTABLE_DIR%\app\" >nul
if errorlevel 1 goto error
copy "%RELEASE_DIR%\sqlite3.dll" "%PORTABLE_DIR%\app\" >nul
if errorlevel 1 goto error
copy "%RELEASE_DIR%\sqlite3_flutter_libs_plugin.dll" "%PORTABLE_DIR%\app\" >nul
if errorlevel 1 goto error

echo Copying application data...
xcopy "%RELEASE_DIR%\data" "%PORTABLE_DIR%\app\data\" /E /I /H /Y >nul
if errorlevel 1 goto error

echo Copying database and assets...
if exist "assets\database" (
    xcopy "assets\database" "%PORTABLE_DIR%\app\assets\database\" /E /I /H /Y >nul
)
if exist "assets\icons" (
    xcopy "assets\icons" "%PORTABLE_DIR%\app\assets\icons\" /E /I /H /Y >nul
)

echo [4/6] Creating launcher script...
(
echo @echo off
echo cd /d "%%~dp0app"
echo echo Starting Luxe Nails POS...
echo echo Press Ctrl+C to exit if needed
echo echo.
echo luxe_pos.exe
echo if errorlevel 1 ^(
echo     echo.
echo     echo ❌ Failed to start application
echo     echo.
echo     echo Common solutions:
echo     echo 1. Install Visual C++ Redistributable ^(see redist folder^)
echo     echo 2. Ensure you're running on Windows 10/11
echo     echo 3. Check that all files are in the app folder
echo     echo.
echo     pause
echo ^)
) > "%PORTABLE_DIR%\Launch Luxe Nails POS.bat"

echo [5/6] Creating documentation...
(
echo # Luxe Nails POS - Portable Distribution
echo.
echo ## Installation Instructions
echo.
echo ### Step 1: Check System Requirements
echo - Windows 10 or Windows 11 ^(64-bit^)
echo - At least 4GB RAM
echo - At least 500MB free disk space
echo - Visual C++ Redistributable 2022 ^(automatically installed if needed^)
echo.
echo **No development tools or additional software required!**
echo.
echo ### Step 2: Install Prerequisites ^(if needed^)
echo If the application fails to start, you may need to install:
echo.
echo **Visual C++ Redistributable 2022 ^(x64^)**
echo - Download from Microsoft or use the installer in the `redist/` folder
echo - This is required for the Flutter engine to work
echo.
echo ### Step 3: Launch Application
echo 1. Double-click `Launch Luxe Nails POS.bat`
echo 2. The application will start in fullscreen mode
echo 3. Use F11 or Alt+Enter to toggle fullscreen
echo 4. Press Escape to exit
echo.
echo ## Files Included
echo ```
echo portable_release/
echo ├── Launch Luxe Nails POS.bat    # Launcher script
echo ├── app/                         # Application files
echo │   ├── luxe_pos.exe            # Main executable
echo │   ├── flutter_windows.dll     # Flutter engine
echo │   ├── flutter_secure_storage_windows_plugin.dll  # Security plugin
echo │   ├── sqlite3.dll             # SQLite database
echo │   ├── sqlite3_flutter_libs_plugin.dll           # SQLite plugin
echo │   ├── data/                   # App bundle
echo │   └── assets/                 # Database and icons
echo ├── redist/                     # Redistributables
echo └── docs/                       # Documentation
echo ```
echo.
echo ## Kiosk Mode Setup
echo For automatic startup on boot:
echo 1. Copy `Launch Luxe Nails POS.bat` to Windows Startup folder
echo 2. Windows Key + R, type `shell:startup`, press Enter
echo 3. Paste the launcher script there
echo.
echo ## Troubleshooting
echo.
echo ### Application won't start
echo - Install Visual C++ Redistributable from redist/ folder
echo - Ensure all files are in the app/ folder
echo - Check Windows Event Viewer for detailed errors
echo.
echo ### Performance issues
echo - Close other applications
echo - Ensure adequate free disk space
echo - Check that antivirus isn't blocking the app
echo.
echo ### Database issues
echo - Ensure app/ folder has write permissions
echo - Check that database files aren't corrupted
echo - Try running as administrator
echo.
echo ## Support
echo For technical support, contact: support@luxenails.com
echo.
echo Version: 1.0.0
echo Build Date: %DATE%
) > "%PORTABLE_DIR%\docs\README.md"

echo [6/6] Creating system info script...
(
echo @echo off
echo echo ==========================================
echo echo System Information for Luxe Nails POS
echo echo ==========================================
echo echo.
echo echo Windows Version:
echo ver
echo echo.
echo echo Processor Architecture:
echo echo %%PROCESSOR_ARCHITECTURE%%
echo echo.
echo echo Available Memory:
echo wmic computersystem get TotalPhysicalMemory /value
echo echo.
echo echo .NET Framework versions:
echo dir "%%windir%%\Microsoft.NET\Framework" /b
echo echo.
echo echo Visual C++ Redistributables installed:
echo reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Microsoft Visual C++" 2^>nul ^| find "DisplayName"
echo echo.
echo echo Press any key to close...
echo pause ^>nul
) > "%PORTABLE_DIR%\System Check.bat"

echo.
echo ✅ Portable package created successfully!
echo.
echo 📦 Location: %CD%\%PORTABLE_DIR%
echo 📦 Size: 
dir "%PORTABLE_DIR%" /s /-c | find "bytes"
echo.
echo 📋 Package contents:
dir "%PORTABLE_DIR%" /b
echo.
echo 🚀 To test: Double-click "%PORTABLE_DIR%\Launch Luxe Nails POS.bat"
echo.
echo 💾 To distribute: 
echo    1. Zip the entire "%PORTABLE_DIR%" folder
echo    2. Share the zip file
echo    3. Recipients extract and run "Launch Luxe Nails POS.bat"
echo.
pause
goto end

:error
echo.
echo ❌ Error creating portable package!
echo Check that the release build completed successfully.
echo.
pause

:end