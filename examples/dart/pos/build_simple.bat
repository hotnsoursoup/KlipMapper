@echo off

echo =====================================
echo Simple Flutter Windows Build Script
echo =====================================
echo.

echo [1/4] Cleaning previous builds...
call flutter clean
if errorlevel 1 goto error

echo.
echo [2/4] Getting dependencies...
call flutter pub get
if errorlevel 1 goto error

echo.
echo [3/4] Building Windows release...
echo This may take several minutes...
call flutter build windows --release
if errorlevel 1 goto error

echo.
echo [4/4] Build completed successfully! ✅
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
echo 📦 Main files created:
if exist "build\windows\x64\runner\Release\luxe_pos.exe" (
    echo ✅ luxe_pos.exe
) else (
    echo ❌ luxe_pos.exe - NOT FOUND
)

if exist "build\windows\x64\runner\Release\flutter_windows.dll" (
    echo ✅ flutter_windows.dll  
) else (
    echo ❌ flutter_windows.dll - NOT FOUND
)

if exist "build\windows\x64\runner\Release\data" (
    echo ✅ data folder
) else (
    echo ❌ data folder - NOT FOUND
)

echo.
echo To test the build:
echo cd build\windows\x64\runner\Release
echo luxe_pos.exe
echo.
echo To create portable package:
echo create_portable.bat
echo.
echo To create installer:
echo "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer_script.iss
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
echo 5. Try deleting build folder manually and retry
echo.
pause

:end