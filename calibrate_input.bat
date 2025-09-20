@echo off

REM Input Calibration Runner (Windows)
REM Runs the calibration scene to determine controller input ranges

echo 🎮 Starting HOPE Input Calibration...
echo Make sure your controller is connected
echo.
echo Instructions:
echo - Move the left stick in all directions and to maximum strength
echo - Press SPACE to record maximum values
echo - Press ENTER to save calibration and exit
echo - Press ESC to exit without saving
echo.

REM Run the calibration scene
godot.exe --scene scenes/calibration_scene.tscn

echo.
echo Calibration complete! Check calibration.json for results.
pause