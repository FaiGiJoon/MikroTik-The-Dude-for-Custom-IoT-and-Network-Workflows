# Mikrotik The Dude Client - Dockerized Workflow

This project provides a Dockerized version of **Mikrotik's The Dude Client** for Linux desktop environments, specifically designed to preserve your network monitoring workflow and extend it with "Future Tools" for managing NVRs, Axis cameras, and IoT devices.

## Overview

The container runs The Dude Client inside a Wine environment on an Ubuntu base, exposed via a web browser using KasmVNC/noVNC. Automated initialization ensures fast container startup while dependencies install seamlessly in the background.

## Key Features

* **The Dude Client**: Pre-configured inside Wine on Ubuntu 22.04 LTS (Jammy Jellyfish).
* **Web-based VNC Desktop**: Access your desktop environment via any modern browser with KasmVNC.
* **Future Tools Integration**: Easily execute custom Bash scripts (e.g., camera/NVR viewers) directly from The Dude's context menu.
* **Mikrotik Container Support**: Optimized for deployment on x86_64 Mikrotik routers running RouterOS Container feature or standalone Linux hosts.
* **Automated Background Setup**: Automated winetricks/dotnet and Dude installer automation via `xdotool`.
* **Persistent Configuration**: Store network maps, monitoring logs, and Wine configurations securely across container updates.

---

## Prerequisites

* **Docker**: v20.10+
* **Docker Compose**: v1.29+ or Docker CLI with `compose` plugin (`docker compose`)

---

## Quick Start

### 1. Clone & Start Container

```bash
docker-compose up -d
```

### 2. Access the Desktop Interface

Open your browser and navigate to:
`https://localhost:6901` (or `https://<YOUR_SERVER_IP>:6901`)

* **Username**: `kasm_user`
* **Password**: `password` (configurable via `docker-compose.yml`)

> **Note on SSL Certificates**: Since KasmVNC uses self-signed certificates by default, your browser may display a security warning. Click "Advanced" and proceed to the site.

---

## Adding "Future Tools"

You can extend The Dude Client with custom local scripts to manage network devices (such as launching web interfaces for Axis cameras, NVRs, or server consoles).

### Example: Axis Camera Quick Launcher

#### Step 1: Place script in `custom-tools/`

Create or edit your script in `custom-tools/open-axis-cam.sh`:

```bash
#!/usr/bin/env bash
IP_ADDRESS=$1

if [ -z "$IP_ADDRESS" ]; then
    echo "Usage: $0 <ip_address>"
    exit 1
fi

firefox "http://$IP_ADDRESS" &
```

Ensure the script is executable:

```bash
chmod +x custom-tools/open-axis-cam.sh
```

#### Step 2: Register the Tool in The Dude Client

1. Open **The Dude Client** in the web desktop.
2. Navigate to **Tools** -> **Settings**.
3. Select the **Tools** tab and click **Add** (`+`).
4. Set the parameters:
   * **Name**: `Open Axis Camera`
   * **Command**: `/custom-tools/open-axis-cam.sh [Device.FirstAddress]`
5. Click **OK**.

Right-clicking any device on your network map will now display the custom tool option!

---

## Environment Variables & Configuration

Configure container parameters in `docker-compose.yml`:

| Environment Variable | Default | Description |
| :--- | :--- | :--- |
| `DUDE_VERSION` | `7.15` | The version of Mikrotik The Dude Client installer to download |
| `VNC_PW` | `password` | Password for the KasmVNC web session |

---

## Volume Persistence

The container maps host volumes to preserve configuration across container restarts:

* `./config`: Stores Wine prefixes (`.wine`), Dude application settings, and desktop shortcuts.
* `./custom-tools`: Mounted script folder for custom tool integrations.

---

## Verification & Troubleshooting

### Static Verification

Run the verification script to confirm repository integrity:

```bash
./verify-setup.sh
```

### Monitoring Background Installation

To track the progress of Wine and The Dude Client installation after container startup:

```bash
docker-compose logs -f thedude
```

Inside the container, check the detailed background log at `/config/install-dude.log`:

```bash
docker exec -it thedude cat /config/install-dude.log
```

---

## License

Distributed under the MIT License. See `dude-install.sh` header for upstream script attribution.
