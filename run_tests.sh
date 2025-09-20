#!/bin/bash

# HOPE CI Test Runner
# Runs unit tests in headless mode for CI/CD pipelines

set -e

echo "🏃 Starting HOPE unit tests..."

# Check if Godot executable exists
if ! command -v godot &> /dev/null; then
    echo "❌ Godot executable not found. Please ensure Godot is installed and in PATH."
    exit 1
fi

# Set the project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "📁 Project directory: $PROJECT_DIR"

# Clean up old test results
rm -f test_results.json test_results.xml

# Run tests in headless mode
echo "🧪 Running unit tests..."
godot --headless --path "$PROJECT_DIR" --scene "res://test_runner.tscn" --quit

# Copy test results from user directory to project directory
if [ -f "$HOME/.local/share/godot/app_userdata/HOPE/test_results.json" ]; then
    cp "$HOME/.local/share/godot/app_userdata/HOPE/test_results.json" "$PROJECT_DIR/"
fi
if [ -f "$HOME/.local/share/godot/app_userdata/HOPE/test_results.xml" ]; then
    cp "$HOME/.local/share/godot/app_userdata/HOPE/test_results.xml" "$PROJECT_DIR/"
fi

# Check the exit code
EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "❌ Some tests failed!"
    exit $EXIT_CODE
fi