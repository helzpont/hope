#!/bin/bash

# Apply Calibration Script
# Reads calibration.json and updates InputHandler thresholds

CALIBRATION_FILE="calibration.json"
INPUT_HANDLER_FILE="scripts/input_handler.gd"

if [ ! -f "$CALIBRATION_FILE" ]; then
    echo "❌ Error: $CALIBRATION_FILE not found!"
    echo "Run calibration first with: ./calibrate_input.sh"
    exit 1
fi

echo "📖 Reading calibration data..."

# Read calibration values using a simple approach
MAX_MAG=$(grep '"max_magnitude"' $CALIBRATION_FILE | sed 's/.*: *//' | sed 's/,.*//')
DEADZONE=$(grep '"deadzone"' $CALIBRATION_FILE | sed 's/.*: *//' | sed 's/,.*//')
INNER_ENTRY=$(grep '"inner_entry_threshold"' $CALIBRATION_FILE | sed 's/.*: *//' | sed 's/,.*//')
INNER_EXIT=$(grep '"inner_exit_threshold"' $CALIBRATION_FILE | sed 's/.*: *//' | sed 's/,.*//')
OUTER_ENTRY=$(grep '"outer_entry_threshold"' $CALIBRATION_FILE | sed 's/.*: *//' | sed 's/,.*//')
OUTER_EXIT=$(grep '"outer_exit_threshold"' $CALIBRATION_FILE | sed 's/.*: *//' | sed 's/,.*//')

echo "📊 Applying calibrated values:"
echo "Max Magnitude: $MAX_MAG"
echo "Deadzone: $DEADZONE"
echo "Inner Entry: $INNER_ENTRY"
echo "Inner Exit: $INNER_EXIT"
echo "Outer Entry: $OUTER_ENTRY"
echo "Outer Exit: $OUTER_EXIT"

# Backup original file
cp $INPUT_HANDLER_FILE "${INPUT_HANDLER_FILE}.backup"

# Update the constants in the InputHandler
sed -i.bak "s/const DEADZONE = .*/const DEADZONE = $DEADZONE # Calibrated/" $INPUT_HANDLER_FILE
sed -i.bak "s/const INNER_ENTRY_THRESHOLD = .*/const INNER_ENTRY_THRESHOLD = $INNER_ENTRY # Calibrated/" $INPUT_HANDLER_FILE
sed -i.bak "s/const INNER_EXIT_THRESHOLD = .*/const INNER_EXIT_THRESHOLD = $INNER_EXIT # Calibrated/" $INPUT_HANDLER_FILE
sed -i.bak "s/const OUTER_THRESHOLD = .*/const OUTER_THRESHOLD = $OUTER_ENTRY # Calibrated entry/" $INPUT_HANDLER_FILE
sed -i.bak "s/const INNER_THRESHOLD = .*/const INNER_THRESHOLD = $OUTER_EXIT # Calibrated exit/" $INPUT_HANDLER_FILE

echo "✅ Calibration applied to $INPUT_HANDLER_FILE"
echo "📁 Backup saved as ${INPUT_HANDLER_FILE}.backup"
echo ""
echo "🎮 Run tests to verify calibration:"
echo "./run_tests.sh"