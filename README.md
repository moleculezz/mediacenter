# Media Center

This app installs and configures various media center applications.

# Setup instructions

```bash
sudo apt-get update
sudo apt-get install -y git curl
curl -L https://omnitruck.chef.io/install.sh | sudo bash
git clone https://github.com/moleculezz/mediacenter.git
cd mediacenter
sudo chef-client -z -j dna.json
```

# Kodi installation instructions

http://forum.kodi.tv/showthread.php?tid=231955

# CouchPotato
CouchPotato requires NzbToMedia, which needs to be configured manually.
