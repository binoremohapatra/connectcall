@echo off
REM Build script for ConnectCall with Agora App ID
REM Usage: build.bat <agora_app_id> [debug|release]

set AGORA_APP_ID=%1
set BUILD_TYPE=%2

if "%AGORA_APP_ID%"=="" (
    echo Error: Agora App ID is required
    echo Usage: build.bat ^<agora_app_id^> [debug^|release]
    exit /b 1
)

if "%BUILD_TYPE%"=="" set BUILD_TYPE=debug

echo Building ConnectCall...
echo Agora App ID: %AGORA_APP_ID%
echo Build Type: %BUILD_TYPE%

if "%BUILD_TYPE%"=="release" (
    flutter build apk --dart-define=AGORA_APP_ID=%AGORA_APP_ID% --release
) else (
    flutter build apk --dart-define=AGORA_APP_ID=%AGORA_APP_ID% --debug
)
