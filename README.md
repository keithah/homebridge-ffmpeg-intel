# Homebridge with FFmpeg Intel hardware transcoding support

A custom Docker image that combines the official [Homebridge](https://homebridge.io/) Ubuntu container with [Jellyfin's optimized FFmpeg build](https://jellyfin.org/docs/general/administration/hardware-acceleration/) for enhanced video processing capabilities.

This is based off the ubuntu base of the official container, so before you switch to this, you might want to make sure you're using homebridge/homebridge:ubuntu.

## 🚀 Features

- **Latest Homebridge**: Always builds from the latest official Homebridge Docker image - Ubuntu version
- **Jellyfin FFmpeg**: Includes Jellyfin's hardware-accelerated FFmpeg build with Intel Quick Sync support
- **Automatic Updates**: GitHub Actions automatically checks for and builds new versions daily
- **Multi-Architecture**: Supports both AMD64 and ARM64 platforms
- **Zero Maintenance**: Set it and forget it - updates happen automatically

## Usage

After switching to this docker

Since we dont replace the stock ffmpeg, you will need to update the ffmpeg path youre using to the new one: 

/usr/lib/jellyfin-ffmpeg/ffmpeg

In this example, I have to change 'Video Processor' option in your Homebridge UI for the Unifi-Video plugin to reflect the new path.
<img width="292" height="622" alt="image" src="https://github.com/user-attachments/assets/0b6558e6-97f2-4f31-9627-d4b7f5a290d5" />


## 🔧 FFmpeg Verification

To verify Jellyfin FFmpeg is properly installed:

docker exec homebridge-ffmpeg-intel /usr/lib/jellyfin-ffmpeg/ffmpeg -version

**Section 8: Environment Variables**

## 📋 Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PGID` | `1000` | Group ID for file permissions |
| `PUID` | `1000` | User ID for file permissions |
| `HOMEBRIDGE_CONFIG_UI` | `1` | Enable the web-based config UI |
| `HOMEBRIDGE_CONFIG_UI_PORT` | `8581` | Port for the web UI |

## 🔄 Automatic Updates

This image is automatically updated when:

- **New Homebridge releases** are published
- **New Jellyfin FFmpeg builds** are available
- **Daily checks** run at 2 AM UTC via GitHub Actions

### Update Schedule

- **GitHub Actions**: Checks daily at 2:00 AM UTC
- **Watchtower**: Checks daily at 4:00 AM local time (if enabled)
- **Manual**: Trigger builds via GitHub Actions tab

## 📁 Volume Mounts

| Host Path | Container Path | Description |
|-----------|---------------|-------------|
| `./homebridge` | `/homebridge` | Homebridge configuration and data |

## 🏗️ Building Locally

git clone https://github.com/keithah/homebridge-ffmpeg-intel.git
cd homebridge-ffmpeg-intel
docker build -t homebridge-ffmpeg-intel .

## 🐛 Troubleshooting

### Container Won't Start

# Check logs
docker logs homebridge-ffmpeg-intel

# Verify permissions
sudo chown -R 1000:1000 ./homebridge

### FFmpeg Not Found

# Verify installation
docker exec homebridge-ffmpeg-intel which /usr/lib/jellyfin-ffmpeg/ffmpeg

# Check version
docker exec homebridge-ffmpeg-intel /usr/lib/jellyfin-ffmpeg/ffmpeg -version

## Port already in use

# Check what's using port 8581
sudo lsof -i :8581

# Use a different port
docker run ... -e HOMEBRIDGE_CONFIG_UI_PORT=8582 ...

## 📖 Documentation Links

- [Homebridge Documentation](https://github.com/homebridge/homebridge/wiki)
- [Homebridge Docker Image](https://github.com/homebridge/docker-homebridge)
- [Jellyfin FFmpeg Documentation](https://jellyfin.org/docs/general/administration/hardware-acceleration/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -am 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request

## 📄 License

This project builds upon the official Homebridge Docker image and Jellyfin FFmpeg. Please refer to their respective licenses:

- [Homebridge License](https://github.com/homebridge/homebridge/blob/master/LICENSE)
- [Jellyfin License](https://github.com/jellyfin/jellyfin/blob/master/LICENSE)

## 🔗 Related Projects

- [Homebridge](https://homebridge.io/) - HomeKit support for the impatient
- [Jellyfin](https://jellyfin.org/) - Free Software Media System
- [FFmpeg](https://ffmpeg.org/) - Complete, cross-platform solution for video/audio

---

**Star ⭐ this repo if it helped you!**
