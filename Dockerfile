FROM lscr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# Set environment variables
ENV WINEPREFIX=/config/.wine
ENV WINEDEBUG=-all
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies confirmed from dude-install.sh
RUN \
  apt-get update && \
  apt-get install -y \
    wget \
    gnupg2 \
    software-properties-common \
    xdotool \
    unzip \
    cabextract \
    firefox \
    xvfb && \
  dpkg --add-architecture i386 && \
  mkdir -pm755 /etc/apt/keyrings && \
  wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
  wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && \
  apt-get update && \
  apt-get install --install-recommends -y winehq-devel && \
  wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
  chmod +x /usr/local/bin/winetricks && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Copy startup and installation scripts
COPY init-dude.sh /custom-cont-init.d/init-dude.sh
RUN chmod +x /custom-cont-init.d/init-dude.sh

# Expose KasmVNC port
EXPOSE 6901

# Volumes
VOLUME /config
VOLUME /custom-tools
