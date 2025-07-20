FROM homebridge/homebridge:ubuntu

USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget curl && \
    rm -rf /var/lib/apt/lists/*

# Download and install the latest Jellyfin FFmpeg with detailed debugging
RUN echo "Downloading Jellyfin FFmpeg..." && \
    LATEST_DEB=$(curl -s https://repo.jellyfin.org/files/ffmpeg/ubuntu/latest-7.x/amd64/ | \
    grep -oP 'jellyfin-ffmpeg7_[^"]*\.deb' | \
    sort -V | tail -1) && \
    echo "Found package: $LATEST_DEB" && \
    wget -O /tmp/jellyfin-ffmpeg.deb "https://repo.jellyfin.org/files/ffmpeg/ubuntu/latest-7.x/amd64/$LATEST_DEB" && \
    echo "Downloaded package, installing..." && \
    dpkg -i /tmp/jellyfin-ffmpeg.deb 2>&1 || (echo "Installation failed, installing dependencies..." && apt-get update && apt-get install -f -y && dpkg -i /tmp/jellyfin-ffmpeg.deb) && \
    echo "Package installed successfully" && \
    rm /tmp/jellyfin-ffmpeg.deb

# Verify installation (no symlink needed - it's already installed correctly)
RUN echo "Verifying FFmpeg installation..." && \
    dpkg -l | grep jellyfin && \
    ls -la /usr/lib/jellyfin-ffmpeg/ffmpeg && \
    /usr/lib/jellyfin-ffmpeg/ffmpeg -version

# Fix homebridge directory permissions
RUN chown -R homebridge:homebridge /homebridge && \
    chmod -R 755 /homebridge && \
    chown homebridge:homebridge /var/lib && \
    chmod 755 /var/lib && \
    rm -rf /var/lib/homebridge && \
    ln -sf /homebridge /var/lib/homebridge && \
    chown -h homebridge:homebridge /var/lib/homebridge

EXPOSE 8581
