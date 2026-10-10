#!/usr/bin/env bash
# Verification script for The Dude Dockerized Workflow

echo "Verifying file existence..."
FILES=("Dockerfile" "docker-compose.yml" "init-dude.sh" "custom-tools/open-axis-cam.sh" "README.md")

for FILE in "${FILES[@]}"; do
    if [ -f "$FILE" ]; then
        echo "[OK] $FILE exists."
    else
        echo "[FAIL] $FILE missing!"
        exit 1
    fi
done

echo "Verifying Dockerfile content..."
if grep -q "winehq-devel" Dockerfile && grep -q "winetricks" Dockerfile && grep -q "xdotool" Dockerfile; then
    echo "[OK] Dockerfile contains required dependencies."
else
    echo "[FAIL] Dockerfile is missing dependencies!"
    exit 1
fi

echo "Verifying startup script content..."
if grep -q "dotnet45" init-dude.sh && grep -q "KP_Enter" init-dude.sh; then
    echo "[OK] init-dude.sh contains confirmed automation logic."
else
    echo "[FAIL] init-dude.sh is missing logic!"
    exit 1
fi

echo "All static verifications passed."
