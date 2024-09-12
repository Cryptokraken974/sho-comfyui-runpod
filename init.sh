#!/bin/bash

# Install required pip packages
PIP_PACKAGES=(
    "insightface"
    "addict"
    "mediapipe"
)

for package in "${PIP_PACKAGES[@]}"; do
    if pip show "$package" > /dev/null 2>&1; then
        echo "$package is already installed, skipping."
    else
        echo "Installing $package..."
        pip install "$package"
    fi
done

echo "Package installation completed successfully!"
