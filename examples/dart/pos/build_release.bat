@echo off
setlocal enabledelayedexpansion

echo =====================================
echo POS Flutter Application Build Script  
echo Pre-production v0.03
echo =====================================
echo.

echo [0/5] Checking build environment...
echo Checking Flutter installation...
where flutter >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter not found in PATH
    goto error
)
echo ✅ Flutter found

echo.
echo Checking Visual Studio Build Tools...
where msbuild >nul 2>&1
if errorlevel 1 (
    echo ❌ MSBuild not found. Please install Visual Studio Build Tools
    echo Download from: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
    goto error
)
echo ✅ MSBuild found

echo.
echo Flutter version:
flutter --version

echo.
echo [1/5] Cleaning previous builds...
flutter clean
if errorlevel 1 goto error

echo.
echo [2/5] Getting dependencies...
flutter pub get
if errorlevel 1 goto error

echo.
echo [3/5] Generating build files...
flutter pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo ⚠️  Build runner failed, continuing anyway...
)

echo.
echo [4/5] Building Windows release...
echo This may take several minutes...
flutter build windows --release --verbose
if errorlevel 1 goto error

echo.
echo [5/5] Build completed successfully! ✅
echo.
echo Release files located at:
echo %CD%\build\windows\x64\runner\Release\
echo.
dir "build\windows\x64\runner\Release\" 2>nul
if errorlevel 1 (
    echo ❌ Release directory not found!
    goto error
)

echo.
echo 📦 Main executable: luxe_pos.exe
echo 📦 Required files: flutter_windows.dll, data folder
echo.
echo To create installer, run:
echo "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer_script.iss
echo.
echo To test the build:
echo cd build\windows\x64\runner\Release
echo luxe_pos.exe
echo.
pause
goto end

:error
echo.
echo ❌ Build failed! 
echo.
echo Common solutions:
echo 1. Install Visual Studio 2022 Build Tools
echo 2. Install Windows 10/11 SDK
echo 3. Install CMake
echo 4. Run 'flutter doctor' to check for issues
echo.
pause

:end