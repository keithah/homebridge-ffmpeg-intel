FROM homebridge/homebridge:latest

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
    echo "Jellyfin FFmpeg installed successfully"

# Verify installation with correct path
RUN find /usr -name "ffmpeg" -type f 2>/dev/null | head -1 | xargs -I {} {} -version || \
    (echo "FFmpeg not found, checking installation..." && \
     dpkg -L jellyfin-ffmpeg7 | grep ffmpeg$ | head -1 | xargs -I {} {} -version)

USER homebridge
EXPOSE 8581
