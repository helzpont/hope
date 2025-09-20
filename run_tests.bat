@echo off
REM HOPE CI Test Runner (Windows)
REM Runs unit tests in headless mode for CI/CD pipelines

echo Starting HOPE unit tests...

REM Check if Godot executable exists
where godot >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Godot executable not found. Please ensure Godot is installed and in PATH.
    exit /b 1
)

REM Set the project directory
set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%"

echo Project directory: %PROJECT_DIR%

REM Clean up old test results
del /q test_results.json test_results.xml 2>nul

REM Run tests in headless mode
echo Running unit tests...
godot --headless --path "%PROJECT_DIR%" --scene "res://test_runner.tscn" --quit

REM Copy test results from user directory to project directory
if exist "%APPDATA%\Godot\app_userdata\HOPE\test_results.json" (
    copy "%APPDATA%\Godot\app_userdata\HOPE\test_results.json" "%PROJECT_DIR%\" >nul
)
if exist "%APPDATA%\Godot\app_userdata\HOPE\test_results.xml" (
    copy "%APPDATA%\Godot\app_userdata\HOPE\test_results.xml" "%PROJECT_DIR%\" >nul
)

REM Check the exit code
if %ERRORLEVEL% equ 0 (
    echo All tests passed!
) else (
    echo Some tests failed!
    exit /b %ERRORLEVEL%
)