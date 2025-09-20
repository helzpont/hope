@echo off

REM Apply Calibration Script (Windows)
REM Reads calibration.json and updates InputHandler thresholds

set CALIBRATION_FILE=calibration.json
set INPUT_HANDLER_FILE=scripts\input_handler.gd

if not exist "%CALIBRATION_FILE%" (
    echo ❌ Error: %CALIBRATION_FILE% not found!
    echo Run calibration first with: calibrate_input.bat
    goto :eof
)

echo 📖 Reading calibration data...

REM This is a simplified version - you might need to manually update the values
echo.
echo 📋 Please manually update these values in scripts\input_handler.gd:
echo.

REM Display the calibration values
type %CALIBRATION_FILE%

echo.
echo 🎮 After updating the InputHandler, run tests with:
echo run_tests.bat

pause