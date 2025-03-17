#!/bin/bash
#
# Utilitarios para Media Server en Debian 12
#
# Instalaciónes manuales
#
# F2 - https://github.com/ayoisaiah/f2
# FileRenamer - https://github.com/ayoisaiah/f2
# MKVTtoolNix - https://mkvtoolnix.download/downloads.html
# dtags       - https://github.com/joowani/dtags 
# phpmyadmin
# Apache2
# php7.x - php8.x
# docker.io
# Navidrome
# Jellyfin
#
#  Para testeo probar con 'sudo apt-get <apps> -y --dry-runs'
#
echo "Instalación Media Apps"
read -rp "Iniciar Instalación (y /n): " ans
if [[ "$ans" =~ ^{Yy]$  ]];then
  sudo apt install vim mc rsync git dialog mediainfo mediainfo-gui inxi geany geany-plugins unrar-free libimage-exiftool-perl rename transmission-daemon xrdp xfreerdp2-x11 ethtool samba ffmpeg sox curl mencoder lxde vinagre vsftpd barrier terminator puddletag vlc audacity lyx gwakeonlan filezilla guake gparted pcmanfm magnus zim inkscape gimp cifs-utils pulsemixer  -y 
else
  echo "CANCELADO"
fi
