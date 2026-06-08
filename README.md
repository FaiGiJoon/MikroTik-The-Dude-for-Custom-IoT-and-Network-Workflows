# Mikrotik The Dude Client - Dockerized Workflow

This project provides a Dockerized version of **The Dude Client** for Linux, specifically designed to preserve your monitoring workflow and extend it with "Future Tools" for managing NVRs, Axis cameras, and IoT devices.

## Features

*   **The Dude Client**: Runs inside a Wine environment on an Ubuntu base.
*   **Web Interface**: Accessible via any web browser using KasmVNC/noVNC.
*   **Future Tools Framework**: Easily add custom scripts to manage IoT devices directly from The Dude's "Tools" menu.
*   **Mikrotik Container Support**: Optimized for running on x86_64 Mikrotik routers with the Container feature enabled.
*   **Automated Setup**: Background initialization ensures the container boots quickly while dependencies install in the background.

## Quick Start

### 1. Build and Run

```bash
docker-compose up -d
```

### 2. Access the Interface

Open your browser and navigate to:
`https://localhost:6901` (or the IP of your router/server)

*   **User**: `kasm_user`
*   **Password**: `password` (configurable in `docker-compose.yml`)

## Adding "Future Tools"

To add custom tools (like accessing an Axis camera or an HP server), follow these steps:

### 1. Create a script

Place your script in the `custom-tools/` directory. For example, `open-axis-cam.sh`:

```bash
#!/usr/bin/env bash
firefox "http://$1" &
```

### 2. Register the tool in The Dude

1.  Open The Dude Client via the web interface.
2.  Go to **Tools** -> **Settings**.
3.  Select the **Tools** tab and click **Add** (+).
4.  **Name**: `Open Axis Camera`
5.  **Command**: `/custom-tools/open-axis-cam.sh [Device.FirstAddress]`
6.  Click **OK**.

Now, you can right-click any device in your network map and select your custom tool!

## Configuration

*   **DUDE_VERSION**: Set the desired version (e.g., `7.15`) in `docker-compose.yml`.
*   **VNC_PW**: Change the default password for security.

## Persistence

Data and configurations are stored in the `./config` directory, ensuring your network maps and settings are preserved across container updates.
