#!/usr/bin/env bash

# This script runs as root during container initialization.
# We will use it to set up the environment and spawn a background task 
# as the kasm_user to handle the Dude installation once the X server is ready.

DUDE_VERSION=${DUDE_VERSION:-"7.15"}
KASM_USER="kasm_user"
WINE_TASK="/tmp/install-dude.sh"

# Create the installation task for the non-root user
cat <<EOF > "$WINE_TASK"
#!/usr/bin/env bash
export WINEPREFIX="/config/.wine"
export DISPLAY=:1
DUDE_EXE="\$WINEPREFIX/drive_c/Program Files/Dude/dude.exe"
DUDE_EXE_X86="\$WINEPREFIX/drive_c/Program Files (x86)/Dude/dude.exe"

# Wait for X server to be ready
echo "Waiting for X server on \$DISPLAY..."
until xdpyinfo -display "\$DISPLAY" >/dev/null 2>&1; do
    sleep 2
done

if [ ! -f "\$DUDE_EXE" ] && [ ! -f "\$DUDE_EXE_X86" ]; then
    echo "The Dude Client not found. Starting installation..."
    
    # Initialize Wine prefix
    wineboot -u
    
    # Install dotnet45 using winetricks
    echo "Installing dotnet45 via winetricks..."
    winetricks -q dotnet45
    
    # Download The Dude Client
    echo "Downloading The Dude Client v$DUDE_VERSION..."
    wget -q "https://download.mikrotik.com/routeros/$DUDE_VERSION/dude-install-$DUDE_VERSION.exe" -O /tmp/dude-setup.exe
    
    # Run installer
    wine /tmp/dude-setup.exe &
    
    # Wait for installer window
    echo "Waiting for installer window..."
    while : ; do
        WINDOW_ID=\$(xdotool search --name "The Dude Setup" 2>/dev/null)
        [[ -z \$WINDOW_ID ]] || break
        sleep 2
    done
    
    # Automate installer steps
    echo "Automating installer..."
    xdotool windowfocus \$WINDOW_ID
    sleep 5
    xdotool key KP_Enter KP_Enter KP_Enter 
    sleep 1
    xdotool key KP_Enter
    sleep 5
    
    rm /tmp/dude-setup.exe
    echo "Installation complete."
fi

# Determine installed path
TARGET_EXE="\$DUDE_EXE"
TARGET_PATH="\$WINEPREFIX/drive_c/Program Files/Dude"
if [ ! -f "\$TARGET_EXE" ] && [ -f "\$DUDE_EXE_X86" ]; then
    TARGET_EXE="\$DUDE_EXE_X86"
    TARGET_PATH="\$WINEPREFIX/drive_c/Program Files (x86)/Dude"
fi

# Create desktop shortcut
mkdir -p /home/\$USER/Desktop
cat <<EOT > /home/\$USER/Desktop/TheDude.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=The Dude
Comment=Mikrotik The Dude Client
Exec=wine "\$TARGET_EXE"
Icon=wine
Path=\$TARGET_PATH
Terminal=false
StartupNotify=false
EOT
chmod +x /home/\$USER/Desktop/TheDude.desktop
EOF

chmod +x "$WINE_TASK"

# Spawn the task in the background as the kasm_user so we don't block root init
echo "Scheduling background installation task for $KASM_USER..."
su - "$KASM_USER" -c "$WINE_TASK" > /config/install-dude.log 2>&1 &

echo "Root initialization complete. Handing over to background task."
