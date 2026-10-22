#!/usr/bin/sh
#  - ccbackupuser.sh - Back up and synchronize with rsync
#  
#  Copyright @ 2023-2024, BIOS Tech <blkid@protonmail.com>
#
# --------------------------------------------------------------------
#
#   GNU GENERAL PUBLIC LICENSE
#   Version 3, 29 June 2007
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  https://www.gnu.org/licenses/gpl-3.0.en.html
#
#===============================================================================
#
#      What is this:
#
#          FILE: ccbackupuser.sh
#
#         USAGE: 
#                example. for the local user
#
#                git clone <repository> or download ccbackupuser.sh 
#                cd repository
#                chmod 755 ccbackupuser.sh
#                ./ccbackupuser.sh
#                
#                example. if you need available for all the system
#
#                chmod 755 ccbackupuser.sh
#                sudo cp -v ccbackupuser.sh /usr/local/bin
#
#                The config files are created at the initial script
#
#                /home/user/.ccbackupuser/ccbackupuser_conf
#                /home/user/.ccbackupuser/backup_user_dir.txt
#
#
#   DESCRIPTION: Advance backup for user home with rsync command 
#
#       OPTIONS: in /home/user/.ccbackupuser/
#  REQUIREMENTS: rsync, nano, sudo
#                sudo privileges for sytem files backup
#          BUGS: None
#         NOTES: Tested in debian 12(bookworm), debian 13(trixie)
#                maybe work in windows with cygwin
#                Could run and all GNU and BSD system changing the
#                variable command paths in ~/.ccbackupuser/ccbackupuser_conf
#                RSYNC NANO SUDO
#        AUTHOR: Erwin Castedo <blkid@protonmail.com>
#  ORGANIZATION: BIOS Tech <bioswork@gmail.com>
#       CREATED: 2025/06/28 21:00
#      REVISION: 2.7 (2026/10/20 18:55)
#                fixed comments and reload variables with source (.) 
#
#      DONATION: https://github.com/ekardian/dryncsnsx#donation
#
#===============================================================================

# Lines
li="---------------------------------------------------------"

# Capture the key combo exit INT -> CTRL+C

trap "aborted" INT

aborted () {
  clear
  printf "\n"
  printf "%s\n" "$li"
  printf "Script Abortado\n\n"
  printf "Donar\n"
  printf "https://github.com/ekardian/dryncsnsx#dontaino\n"
  printf "%s\n" "$li"
  printf "\n"
  exit 0
}

exit_script () {
  printf "\n"
  printf "%s\n" "--------------------------------------------------"
  printf "  %s\n\n" "Script Terminado"
  printf "  %s\n" "Donar"
  printf "  %s\n" "https://github.com/ekardian/dryncsnsx#dontaino"
  printf "%s\n" "--------------------------------------------------"
  printf "\n"
  exit 
}

exit_success () {
  printf "\n"
  printf "%s\n" "--------------------------------------------------"
  printf "  %s\n\n" "Script ejecutado satisfactoriamente"
  printf "  %s\n" "Donar"
  printf "  %s\n" "https://github.com/ekardian/dryncsnsx#dontaino"
  printf "%s\n" "--------------------------------------------------"
  printf "\n"
  exit 0
}

# Verificando si requerimientos de paquetes están instalados

check_packages () {
  if [ ! -f "$RSYNC" ] || [ ! -f "$NANO" ] || [ ! -f "$SUDO" ]; then
    printf "\n"
    printf "%s\n" "  ccbackupuser.sh - Script para Respaldos con rsync"
    printf "%s\n" "-----------------------------------------------------------------"
    printf "\n"
    printf "  %s\n\n" "* (FALLO) Se requiere paquetes rsync, sudo, nano"
    printf "%16s %s\n" "Debian:" "apt install rsync sudo nano"
    printf "%16s %s\n" "RedHat/Fedora:" "dnf install rsync sudo nano"
    printf "%16s %s\n" "Arch:" "pacman -S rsync sudo nano"
    printf "%16s %s\n" "Gentoo:" "emerge -a rsync sudo nano"
    printf "%16s %s\n" "Alpine:" "apk rsync sudo nano"
    printf "%16s %s\n\n" "Suse:" "zypper isntall rsync sudo nano"
    printf "  %s\n" "Instale los paquetes y configure las rutas si lo requiere en"
    printf "  %s\n\n" "~/.ccbackupuser/ccbackupuser_conf y ejectue de nuevo."
    exit 
  fi
}

# Verificando si existe usuario

check_user () {
  printf "\n" 
  printf "%s\n> " "- Usuario con el que desea ejecutar: "; read -r usertmp
  id -u "$usertmp" > /dev/null

  exitcode=$?
  if [ "$exitcode" = 0 ]; then
    command -v sudo > /dev/null; cmdsudo=$?
    if [ ! "$cmdsudo" = 0 ]; then printf "\n  %s\n" "* (FALLO) El paquete sudo no está instalado"; exit_script; fi
    myhome=$(sudo -u "$usertmp" -H sh -c 'printf "$HOME\n"')
  else
    printf "\n%s  \n\n" "  * Usuario ${usertmp} no existe."
    printf "Presione Enter para salir..."; read -r backtomenu
    exit_script
  fi
}

# Verificando si existe archivos de configuración

check_config () {
  CONFIG_FILE="${myhome}/.ccbackupuser/ccbackupuser_conf"
  
  if [ ! -f "$CONFIG_FILE" ];then
    printf "\n  %s\n\n" "* (FALLO) ARCHIVO DE CONFIGURACIÓN"
    divider="=============================="
    divider=$divider$divider$divider
    
    printf " %-18s %-37s %-10s \n" "Tipo de Archivo" "Archivos de Configuración" "Estado"
    printf "%67.67s\n" "$divider"
    printf " %-18s %-36s %-10s \n" \
    "Directorio" "/.ccbackupuser/" "NO EXISTE" \
    "Archivo" "/.ccbackupuser/ccbackupuser_conf" "NO EXISTE" \
    "Archivo" "/.ccbacupuser/backup_user_dir.txt" "NO EXISTE"
    printf "%s\n" "-------------------------------------------------------------------"
    printf "%s\n> " "- Crear archivos de configuración? (s/n): "; read -r me
  
    if [ "$me" = s ]; then
      mkdir "${myhome}"/.ccbackupuser
      cd "${myhome}"/.ccbackupuser 
      cat << 'EOF' >> ccbackupuser_conf
#!/bin/bash

# Directorio raiz desde dónde se empezará a hacer el backup
#
# ejemplo si quiere respaldar el directorio Documentos y el .bash_aliases
# del home del usuario johndoe. Importante incluir el slash '/' al final. 
# BACKUPUSER="/home/johndoe/"
BACKUPDIR="${myhome}/"

# Destino donde se copiará el backup, inluir slash '/' al final.
#
# LOCAL. Ejemplo respaldando al directorio local Descargas
# DEST=/home/johndoe/Descargas
#
# REMOTO. Ejemplo respaldar a un equipo remoto con ip 192.168.1.5
# con un usuario remoto llamado 'johndoe' a su directorio Descargas
# DEST="johndoe@192.168.1.5:/home/johndoe/Descargas/"
DEST="/ruta-de-destino/"

# Archivo contenedor de directorios y archivos que quiere respaldar
# esta variable 'FILES' no debe modificarse
# Si modifica 'FILES', debe editar el código fuente con la nueva variable
FILES="${myhome}/.ccbackupuser/backup_user_dir.txt"

# Ejemplo edite ~/.ccbackupuser/backup_user_dir.txt para respaldar la carpeta
# Documentos y el archivo .bashrc, los directorios sin '/' al inicio ni al final
# escribiendo cada uno por línea.
# Documentos
# .bash_aliases

# Paquetes requeridos, modifique la ruta según su versión de sistema si lo requiere

# rsync
RSYNC="/usr/bin/rsync"

# opciones rsync. Copia, sincroniza archivos nuevos y modificados, sin borrar archivos
# Lea el 'man rsync' para más detalles
OPTS="-h --progress --stats -r -tgo -p -l -D --update --delete-after --files-from=$FILES"

# sudo
SUDO="/usr/bin/sudo"

# nano
NANO="/usr/bin/nano"
EOF

      touch "${myhome}"/.ccbackupuser/backup_user_dir.txt
      . "${myhome}"/.ccbackupuser/ccbackupuser_conf 
      "$SUDO" chown -R "$usertmp":"$usertmp" "${myhome}"/.ccbackupuser/
  
      printf "\n%s\n %s\n %s\n %s\n" " - Directorio y archivos creados:" "  ${myhome}/.ccbackupuser/" "  ${myhome}/.ccbackupuser/ccbackupuser_conf" "  ${myhome}/.ccbackupuser/backup_user_dir.txt"
      printf "\n%s\n %s\n\n" " - Ejecute de nuevo el script, configure desde opciones del menú" "o manualmente ~/.ccbackupuser/ccbackupuser_conf y ~/.ccbackupuser/backup_user_dir.txt"
      exit
    else
      printf "\n%s\n" "-------------------------------------------------------------------"
      printf " %s\n" "Script Cancelado, se requiere generar el archivo de configuración\n"
      printf "%s\n\n" "-------------------------------------------------------------------"
      exit 
    fi
  else
  . "${myhome}"/.ccbackupuser/ccbackupuser_conf 
  fi
}

# Tamaño del backup

sizefrombackup () {
  sed -i "/^[[:space:]]*$/d" "$FILES"
  sed -e "s#^#${BACKUPDIR}#" "$FILES" > "$FILES.tmp"
  printf "\n"
  sizefiles=$(tr '\n' '\0' <"$FILES.tmp" | "$SUDO" du -sch --files0-from=-)
  printf "\n%s\n\n %s\n" "Tamaño total que se respaldará:" "$sizefiles"
  printf "\n"
}

# Función de backup

respaldo () {

  # Opciones de respaldo
  # --------------------------------------------------------------------------
  # -h          salida numérica en formato de lectura humana
  # --progress  muestra  el progreso durante la transeferencia
  # --stats     avisa a rsync para imprimir en modo verbal de estadiśticas en
  #             la transferencia de archivos
  # -r          recursivo en los directorios
  # -t          preserva el tiempo de modificación
  # -g          preserva el grupo
  # -o          preserva el dueño (super usuario solamente)
  # -p          preserva permisos
  # -l          copia links simbólicos como links simbólicos
  # -D          preserva los archivos del dispositivo (super usuario solamente
  # --update    esto forza a rsync a saltar cualquier archivo que exist
  #             en el destino y tenga una fecha modificada que sea más nueva
  #             que el fichero fuente
  # --delete-after  el receptor elimina después de la transferencia, no durante
  # --files-from  lée una lista de nombres de archivos-fuente desde un fichero

#  OPTS="-h --progress --stats -r -tgo -p -l -D --update --delete-after --files-from=$FILES"
 
  "$SUDO" "$RSYNC" $OPTS "$BACKUPDIR" "$DEST"

  printf "\n" 
  printf " %s\n   %s\n\n" "- Respaldo en el usuario" "${usertmp}"
  printf " %s\n   %s\n\n" "- Directorio Origen" "$BACKUPDIR"
  printf " %s\n   %s\n\n" "- Directorio Destino" "$DEST"
  printf " %s\n   %s\n\n" "- Comando y opciones ejecutadas (man rsync)" "rsync -h --progress --stats -r -tgo -p -l -D --update --delete-after --files-from=<<backup_user_dir.txt> <destino>"

  exit_success
}

# Iniciando si copia a un archivo local o a un remoto

startornot () {
  printf "\n%s\n> " "- Iniciar Respaldo? Si (s) , No (n):"; read -r voyono

  if [ "$voyono" = n ]; then
    exit_script
  fi
}

# Ver / Editar archivo de configuración

print_config () {
  if [ -f "${myhome}/.ccbackupuser/ccbackupuser_conf" ]; then
    "$NANO" "${myhome}"/.ccbackupuser/ccbackupuser_conf
  else
    printf "\n  %s\n" "* (FALLO) ~/.ccbackupuser/ccbackupuser_conf no existe"
  fi
}

# Ver / Editar archivos que se respaldarán

print_backup_files () {
  if [ -f "$FILES" ]; then
    "$NANO" "$FILES"
  else
    printf "\n  %s\n" "* (FALLO) ~/.ccbackupuser/backpup_user_dir.txt"
  fi
}

# Ayuda

ayuda () {
  cat <<EOF > "${myhome}"/.ccbackupuser/ayuda.txt
                  AYUDA
==============================================

 ccbackupuser.sh copia o sincroniza copias en
 Local o a PC/Remoto usando elcomando rsync
 tanto del root como el de un usuario.

 El script creará dos archivos que necesita
 configurar:
 
 Archivo de configuración
 ~/.ccbackupuser/ccbackup_conf

 Lista de archivos/directorios que respaldará
 ~/.ccbackupuser/backup_user_dir.txt

 Si necesita regenerar los archivos de configuración
 por algún motivo, borre el direcotiro
 rm -fr ~/.ccbackupuser
 Al ejecutar el script, volverá a generar
 la configuración por defecto.


 El script requiere de los paquetes:
 rsync nano sudo

 Puede cambiar la ruta a estos programas si lo
 requiere en ~/.ccbackupuser/.ccbackupuser_conf

 Para configurar un respaldo son 3 pasos

 1. Editar variable 'BACKUPDIR'
    Directorio fuente
 2. Editar variable 'DIR'
    Directorio destino
 3. Editar archivo backup_user_dir.txt
    Nombre de los Archivos y Directorios
    que quieres respaldar.
    No escribir el slash inicial.
    En los ejemplos verá diferentes tipos de
    respaldo de archivos y directorios con
    su contenido o solo su contenido.

 EJEMPLOS

 En BACKUPDIR escribir siempre slash al final

 - Ejemplo 1
 Respaldar directorios /etc, /home/user
 a un segundo disco duro en /mnt/DISK2
 
 configuración de ccbackupuser_conf
 BACKUPDIR="/"
 DEST="/mnt/DISK2"

 Edite ./ccbackupuser/backup_user_dir.txt
 etc
 home/user

 - Ejemplo 2
 Respaldar todo el home del uuario user
 a una pc remota con ip 192.168.1.3
 al directorio Descargas del usuario
 johndoe

 configuración de ccbackupuser_conf
 BACKUPDIR="/home/"
 DEST="johndoe@192.168.1.3:/~Descargas"
 
 Edite ./ccbackupuser/backup_user_dir.txt
 home

 - Ejemplo 3
 Respaldar y sincronizar algunos archivos
 y directorios.
    .bashrc - archivo
    .local/ - directorio oculto
 Dcoumentos - Directorio

 Esta función  está por
 defecto en la opciones de rsync
 en el script. Cada vez que haga el
 respaldo, este sobreescribirá solo los
 modificados manteniendo los archivos
 no modificados en destino.
 Respaldando a remoto con ip 192.168.1.3
 usuario johndoe en acceso a un disco
 secundario en /mnt/DISK3

 configuración de ccbackupuser_conf
 BACKUPDIR="/home/"
 DEST="johndoe@192.168.1.3:/mnt/DISK3/"
 
 Edite ./ccbackupuser/backup_user_dir.txt
 .bashrc
 .local
 Documentos

 - Ejemplo 4
 Respaldar solo el conenido de Imágenes
 del usuario user al directorio
 /mnt/respaldo_de_imagenes/

 configuración de ccbackupuser_conf
 BACKUPDIR="/home/user/"
 DEST="/mnt/respaldo_de_imagenes/"
 
 Edite ./ccbackupuser/backup_user_dir.txt
       Observe el slash al final,
       esto solo copiará el contenido
       y no el directorio contenedor.
 Imágenes/

 OPCIONES DE RSYNC USADAS EN EL SCRIPT

 Lea el manpage de rsync para más
 información (man rsync).

 -h          salida numérica en formato de
             lectura humana
 --progress  muestra  el progreso durante
             la transeferencia
 --stats     avisa a rsync para imprimir en
             modo verbal de estadiśticas en
             la transferencia de archivos
 -r          recursivo en los directorios
 -t          preserva el tiempo de modificación
 -g          preserva el grupo
 -o          preserva el dueño (super usuario
             solamente)
 -p          preserva permisos
 -l          copia links simbólicos como links
             simbólicos
 -D          preserva los archivos del dispositivo
             (super usuario solamente
 --update    esto forza a rsync a saltar cualquier
             archivo que exist en el destino y
             tenga una fecha modificada que sea
             más nueva que el fichero fuente
 --delete-after    el receptor elimina después de
                   la transferencia, no durante
 --files-from      lée una lista de nombres de
                   archivos-fuente desde un fichero


 LICENCIA

 Este script usa
 Licencia Pública General Affero de GNU
 https://www.gnu.org/licenses/agpl.html 

EOF

}

# Respaldar configuración

backup_config () {
  TIMESTAMP=$(date +%Y-%m-%d_%T)
  myzip=$(command -v zip)
  "$myzip" "${myhome}/ccbackupuser-$TIMESTAMP.zip" -rq "${myhome}/.ccbackupuser"

  printf "\n\n%s\n\n" "- Respaldo de configuración guardado en ${myhome}"

  printf "%s\n" "Presionar Enter para continuar ..."; read backtomenu
}

# Menu

menu_header () {
  printf "\n" 
  printf "%s\n" "-----------------------------------------"
  printf "%s\n" "  ccbackupuser.sh - Respaldos con rsync"
  printf "%s\n" "   Respalda/Sincroniza en Local/Remoto"
  printf "%s\n\n" "-----------------------------------------"
}

menu_header
check_user
check_config

if [ ! -f "${myhome}"/.ccbackupuser/ayuda.txt ]; then
  ayuda
fi

while true; do
  clear
 
  menu_header
  
  # Impresion tabla
  
  divider="-------------------------------"
  divider=$divider$divider$divider

  printf "%19s \n" "                 Menú"
  printf "%31.31s\n\n" "        $divider"

  # Opciones
  
  printf "  %s\n" "1. Respaldar Archivos"
  printf "  %s\n" "2. Ver/Editar Archivo de Configuración"
  printf "  %s\n" "3. Ver/Editar Archivos que respaldará"
  printf "  %s\n" "4. Tamaño de Archivos que se Respaldarán"
  printf "  %s\n" "5. Respaldar configuración"
  printf "  %s\n" "6. Ayuda"
  printf "  %s\n\n" "7. Salir"
  printf "  %s" "Escoje una opción: "

  read -r choice

  case $choice in
    1)
      clear
      
      . "${myhome}"/.ccbackupuser/ccbackupuser_conf
     
      menu_header
      printf "    1. Respaldar Archivos\n"
      check_packages
      printf "\n%s\n  %s\n  %s\n> " "- Configuró el archivo de configuración?" "* ${myhome}/.ccbackupuser/ccbackupuser_conf"  "Si [s] continúa, No [n] sale del script"; read -r ans
      
      if [ "$ans" = s ]; then
        printf "\n%s\n> " "- Configuró para respaldo remoto? Si (s) , No (n):"; read -r cremoto
        if [ "$cremoto" = n ]; then
          if [ ! -d "$DEST" ]; then
            printf "%s\n" "$li" 
            printf "  %s\n    %s\n\n  %s\n  %s\n  %s\n" "* (FALLO) Directorio destino no existe." "${DEST}"  "Revise la configuración:"  "/home/<user>/.ccbackupuser/ccbackupuser_conf"  "/home/<user>/.ccbackupuser/backup_user_dir.txt"
            printf "%s\n" "$li" 

            printf "  %s\n\n" "Script Terminado."
            exit 
          fi
          startornot
          respaldo
        else
          startornot
          respaldo
        fi
      else
        printf " %s\n\n" "* Configure el script y vuelva a ejecutarloi."
        exit_script
      fi
      ;;
    2)
      clear
      menu_header
      printf "    2. Ver Archivo de Configuración\n"
      check_packages
      print_config
      ;;
    3)
      clear
      menu_header
      printf "    3. Ver Archivos/Directorios que respaldará\n"
      check_packages
      print_backup_files
      ;;
    4)
      clear

      . "${myhome}"/.ccbackupuser/ccbackupuser_conf

      menu_header
      printf "    4. Tamaño de Archivos que se Respaldarán\n"
      check_packages
      sizefrombackup
      ;;
    5)
      clear
      menu_header
      printf "    5. Respaldar configuración"
      backup_config
      ;;
    6)
      clear
      menu_header
      more -d "${myhome}"/.ccbackupuser/ayuda.txt
      printf "\n%s\n" "- Presiona Enter para volver al menu."; read -r backtomenu
      ;;
    7)
      clear
      exit_script
      ;;
    *)
      printf "\n  %s\n" "* Opción inválida: Escoja entre 1 a 6"
      ;;
  esac

  printf "\n"
  printf "%s  \n" "Presionar Enter para continuar ..."; read -r backtomenu

done
