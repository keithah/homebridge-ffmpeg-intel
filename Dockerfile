FROM homebridge/homebridge:ubuntu

USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget curl && \
    rm -rf /var/lib/apt/lists/*

# Download and install the latest Jellyfin FFmpeg
RUN LATEST_DEB=$(curl -s https://repo.jellyfin.org/files/ffmpeg/ubuntu/latest-7.x/amd64/ | \
    grep -oP 'jellyfin-ffmpeg7_[^"]*\.deb' | \
    sort -V | tail -1) && \
    echo "Installing $LATEST_DEB" && \
    wget -O /tmp/jellyfin-ffmpeg.deb "https://repo.jellyfin.org/files/ffmpeg/ubuntu/latest-7.x/amd64/$LATEST_DEB" && \
    dpkg -i /tmp/jellyfin-ffmpeg.deb || apt-get install -f -y && \
    rm /tmp/jellyfin-ffmpeg.deb && \
    echo "Jellyfin FFmpeg installation complete"

# Fix ALL permission issues comprehensively
RUN chown -R homebridge:homebridge /homebridge && \
    chmod -R 755 /homebridge && \
    rm -rf /var/lib/homebridge && \
    ln -sf /homebridge /var/lib/homebridge && \
    chown -h homebridge:homebridge /var/lib/homebridge && \
    echo "Fixed permissions and symlink" && \
    ls -la /var/lib/homebridge && \
    ls -la /homebridge

EXPOSE 8581
