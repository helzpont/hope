# 🎮 HOPE Input Calibration Guide

This guide helps you calibrate the input system for your specific controller to ensure optimal gameplay feel.

## Why Calibrate?

Different controllers produce different maximum input values:

- Some controllers max out at exactly 1.0
- Others may max out at 0.95, 0.85, or other values
- Calibration ensures consistent behavior across different controllers

## Current Thresholds

The input system uses these zones:

- **Deadzone**: 0.01 (filters tiny inputs)
- **Inner Circle**: 0.1 entry / 0.01 exit (walking)
- **Outer Circle**: 0.95 entry / 0.85 exit (dashing)

## Calibration Process

### Step 1: Run Calibration

```bash
# macOS/Linux
./calibrate_input.sh

# Windows
calibrate_input.bat
```

### Step 2: Follow On-Screen Instructions

1. Move the left stick in ALL directions (up, down, left, right, diagonals)
2. Push the stick to maximum strength in each direction
3. Press **SPACE** to record maximum values
4. Press **ENTER** to save calibration data

### Step 3: Apply Calibration

```bash
# macOS/Linux
./apply_calibration.sh

# Windows
# Manually update values from calibration.json
```

## What Gets Calibrated

The calibration adjusts these thresholds proportionally:

- **Deadzone**: 1% of your controller's max
- **Inner Entry**: 15% of your controller's max
- **Inner Exit**: 2% of your controller's max
- **Outer Entry**: 90% of your controller's max
- **Outer Exit**: 80% of your controller's max

## Files Created

- `calibration.json` - Your calibration data
- `scripts/input_handler.gd.backup` - Backup of original settings

## Testing Calibration

After applying calibration, run the tests:

```bash
./run_tests.sh
```

## Troubleshooting

### No Input Detected

- Make sure your controller is connected
- Try different USB ports
- Check controller battery

### Values Seem Wrong

- Ensure you moved the stick to maximum in all directions
- Try calibrating multiple times and use the highest values

### Tests Fail After Calibration

- Check that thresholds are reasonable (not too high/low)
- You can manually adjust values in `input_handler.gd`

## Manual Calibration

If automated scripts don't work, manually update these constants in `scripts/input_handler.gd`:

```gdscript
const DEADZONE = 0.005  # Your calibrated deadzone
const INNER_ENTRY_THRESHOLD = 0.125  # Your calibrated inner entry
const INNER_EXIT_THRESHOLD = 0.015  # Your calibrated inner exit
const OUTER_THRESHOLD = 0.85  # Your calibrated outer entry
const INNER_THRESHOLD = 0.75  # Your calibrated outer exit
```
