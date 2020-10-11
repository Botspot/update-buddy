# update-buddy
Automatically check for updates on boot. If there are any, asks permission to upgrade.
# To install:
```
sudo apt install yad
git clone https://github.com/Botspot/update-buddy
mkdir ~/.config/autostart
echo "[Desktop Entry]
Name=Update Buddy
Exec=$HOME/update-buddy/onstartup.sh
Type=Application
X-GNOME-Autostart-enabled=true
Hidden=false
NoDisplay=false" > ~/.config/autostart/update-buddy.desktop
```
