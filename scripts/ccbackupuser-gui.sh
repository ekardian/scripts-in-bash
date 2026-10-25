#!/usr/bin/sh
#
#  - ccbackupuser-gui.sh - Back up and synchronize with rsync
#  
#  Copyright @ 2026, BIOS Tech <blkid@protonmail.com>
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
#          FILE: ccbackupuser-gui.sh
#
#         USAGE: 
#                example. for the local user
#
#                git clone <repository> or download ccbackupuser-gui.sh 
#                cd repository
#                chmod 755 ccbackupuser-gui.sh
#                ./ccbackupuser-gui.sh
#                
#                example. if you need available for all the system
#
#                chmod 755 ccbackupuser-gui.sh
#                sudo cp -v ccbackupuser-gui.sh /usr/local/bin
#
#                The config files are created at the initial script
#
#                /home/user/.ccbackupuser-gui/ccbackupuser_conf
#                /home/user/.ccbackupuser-gui/backup_user_dir.txt
#
#
#   DESCRIPTION: Advance backup for user home with rsync command 
#
#       OPTIONS: in /home/user/.ccbackupuser-gui/
#  REQUIREMENTS: rsync, sudo, dialog
#                sudo privileges for sytem files backup
#          BUGS: None
#         NOTES: Tested in debian 12(bookworm), debian 13(trixie)
#                maybe work in windows with cygwin
#                Could run and all GNU and BSD system changing the
#                variable command paths in ~/.ccbackupuser-gui/ccbackupuser_conf
#                RSYNC SUDO
#        AUTHOR: Erwin Castedo <blkid@protonmail.com>
#  ORGANIZATION: BIOS Tech <bioswork@gmail.com>
#       CREATED: 2025/06/28 21:00
#      REVISION: 1.0 (2026/10/25 00:51)
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
  whichdialog=$(command -v dialog); dialogcheck=$?
  whichrsync=$(command -v rsync); rsynccheck=$?
  whichsudo=$(command -v sudo); sudocheck=$?
  if [ ! "$dialogcheck" = 0 ] || [ ! "$rsynccheck" = 0 ] || [ ! "$sudocheck" = 0 ]; then
    printf "\n"
    printf "%s\n" "  ccbackupuser-gui.sh - Script para Respaldos con rsync"
    printf "%s\n" "-----------------------------------------------------------------"
    printf "\n"
    printf "  %s\n\n" "* (FALLO) Se requiere paquetes rsync, sudo, dialog"
    printf "%16s %s\n" "Debian:" "apt install rsync sudo dialog"
    printf "%16s %s\n" "RedHat/Fedora:" "dnf install rsync sudo dialog"
    printf "%16s %s\n" "Arch:" "pacman -S rsync sudo dialog"
    printf "%16s %s\n" "Gentoo:" "emerge -a rsync sudo dialog"
    printf "%16s %s\n" "Alpine:" "apk rsync sudo dialog"
    printf "%16s %s\n\n" "Suse:" "zypper isntall rsync sudo dialog"
    printf "  %s\n" "Instale los paquetes y configure las rutas si lo requiere en"
    printf "  %s\n\n" "~/.ccbackupuser-gui/ccbackupuser_conf y ejecute de nuevo."
    exit 
  fi
}

# Verificando si existe usuario

check_user () {
  returntext=$(dialog --title "Usuario para respaldo" \
    --backtitle "ccbackupuser-gui.sh" \
    --stdout \
    --form "Nombre de Usuario" 8 27 1 \
    "Usuario:" 1 1 "" 1 10 10 0 \
  )
  exitcode=$?

  case $exitcode in
    0)
      command -v sudo > /dev/null; cmdsudo=$?
      if [ ! "$cmdsudo" = 0 ]; then
        dialog --title "Usuario para respaldo" \
          --backtitle "ccbackupuser-gui.sh" \
          --stdout \
          --msgbox "(FALLO) El paquete sudo no está instalado" 0 0
        exit_script
      fi

      usertmp="$(printf "%s\n" "$returntext")"
      id -u "$usertmp" > /dev/null
      exit_code=$?

      if [ "$exit_code" = 0 ]; then
        myhome=$(sudo -u "$usertmp" -H sh -c 'printf "$HOME\n"')
      else
        dialog --title "Usuario para respaldo" \
          --backtitle "ccbackupuser-gui.sh" \
          --stdout \
          --msgbox "(FALLO) Usuario no existe" 0 0
        clear
        exit_script
      fi
      ;;
    1|255)
      clear
      exit_script
      ;;
  esac
}

# Verificando si existe archivos de configuración

check_config () {
  CONFIG_FILE="${myhome}/.ccbackupuser-gui/ccbackupuser_conf"
  
  if [ ! -f "$CONFIG_FILE" ];then
    printf "\n  %s\n\n" "* (FALLO) ARCHIVO DE CONFIGURACIÓN"
    divider="=============================="
    divider=$divider$divider$divider
    
    printf " %-18s %-37s %-10s \n" "Tipo de Archivo" "Archivos de Configuración" "Estado"
    printf "%67.67s\n" "$divider"
    printf " %-18s %-36s %-10s \n" \
    "Directorio" "/.ccbackupuser-gui/" "NO EXISTE" \
    "Archivo" "/.ccbackupuser-gui/ccbackupuser_conf" "NO EXISTE" \
    "Archivo" "/.ccbacupuser-gui/backup_user_dir.txt" "NO EXISTE"
    printf "%s\n" "-------------------------------------------------------------------"
    printf "%s\n> " "- Crear archivos de configuración? (s/n): "; read -r me
  
    if [ "$me" = s ]; then
      mkdir "${myhome}"/.ccbackupuser-gui
      cd "${myhome}"/.ccbackupuser-gui
      cat << 'EOF' >> ccbackupuser_conf
#!/usr/bin/sh

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
FILES="${myhome}/.ccbackupuser-gui/backup_user_dir.txt"

# Ejemplo edite ~/.ccbackupuser-gui/backup_user_dir.txt para respaldar la carpeta
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
EOF

      touch "${myhome}"/.ccbackupuser-gui/backup_user_dir.txt
      . "${myhome}"/.ccbackupuser-gui/ccbackupuser_conf 
      "$SUDO" chown -R "$usertmp":"$usertmp" "${myhome}"/.ccbackupuser-gui/
  
      printf "\n%s\n %s\n %s\n %s\n" " - Directorio y archivos creados:" "  ${myhome}/.ccbackupuser-gui/" "  ${myhome}/.ccbackupuser-gui/ccbackupuser_conf" "  ${myhome}/.ccbackupuser-gui/backup_user_dir.txt"
      printf "\n%s\n %s\n\n" " - Ejecute de nuevo el script, configure desde opciones del menú" "o manualmente ~/.ccbackupuser-gui/ccbackupuser_conf y ~/.ccbackupuser-gui/backup_user_dir.txt"
      exit
    else
      printf "\n%s\n" "-------------------------------------------------------------------"
      printf " %s\n" "Script Cancelado, se requiere generar el archivo de configuración\n"
      printf "%s\n\n" "-------------------------------------------------------------------"
      exit 
    fi
  else
  . "${myhome}"/.ccbackupuser-gui/ccbackupuser_conf 
  fi
}

# Tamaño del backup

sizefrombackup () {
  sed -i "/^[[:space:]]*$/d" "$FILES"
  sed -e "s#^#${BACKUPDIR}#" "$FILES" > "$FILES.tmp"
  sizefiles=$(tr '\n' '\0' <"$FILES.tmp" | "$SUDO" du -sch --files0-from=-)
  printf "%s\n" "$sizefiles" > "$FILES-dsize.tmp"
  "$MYDIALOG" --title "Tamaño de Archivos" \
    --backtitle "ccbackupuser-gui.sh - Configuración" \
    --stdout \
    --textbox "${myhome}/.ccbackupuser-gui/backup_user_dir.txt-dsize.tmp" 19 65
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

  "$MYDIALOG" --title "Respaldo de Archivos" \
    --backtitle "ccbackupuser-gui.sh - Respaldo" \
    --stdout \
    --yestno "Iniciar Respaldo?" 0 0
}

# Ayuda

ayuda () {
  cat <<EOF > "${myhome}"/.ccbackupuser-gui/ayuda.txt
                  AYUDA
==============================================

 ccbackupuser-gui.sh copia o sincroniza copias en
 Local o a PC/Remoto usando elcomando rsync
 tanto del root como el de un usuario.

 El script creará dos archivos que necesita
 configurar:
 
 Archivo de configuración
 ~/.ccbackupuser-gui/ccbackupuser_conf

 Lista de archivos/directorios que respaldará
 ~/.ccbackupuser-gui/backup_user_dir.txt

 Si necesita regenerar los archivos de configuración
 por algún motivo, borre el direcotiro
 rm -fr ~/.ccbackupuser-gui
 Al ejecutar el script, volverá a generar
 la configuración por defecto.


 El script requiere de los paquetes:
 rsync sudo

 Puede cambiar la ruta a estos programas si lo
 requiere en ~/.ccbackupuser-gui/.ccbackupuser_conf

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

 Edite ./ccbackupuser-gui/backup_user_dir.txt
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
 
 Edite ./ccbackupuser-gui/backup_user_dir.txt
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
 
 Edite ./ccbackupuser-gui/backup_user_dir.txt
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
 
 Edite ./ccbackupuser-gui/backup_user_dir.txt
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
  "$myzip" "${myhome}/ccbackupuser-gui-$TIMESTAMP.zip" -rq "${myhome}/.ccbackupuser-gui"
}

# Menu

#menu_header () {
#  printf "\n" 
#  printf "%s\n" "-----------------------------------------"
#  printf "%s\n" "  ccbackupuser-gui.sh - Respaldos con rsync"
#  printf "%s\n" "   Respalda/Sincroniza en Local/Remoto"
#  printf "%s\n\n" "-----------------------------------------"
#}

#menu_header
check_packages
check_user
check_config

if [ ! -f "${myhome}"/.ccbackupuser-gui/ayuda.txt ]; then
  ayuda
fi

MYDIALOG=$(command -v dialog)
if [ ! -f "$MYDIALOG" ]; then
  printf "\n %s\n" "* Comando rsync no está instalado"
fi

: "${DIALOG_HELP=2}"

# menu

menu () {
  
listoption=$("$MYDIALOG" --title "MENÚ" \
  --backtitle "ccbackupuser-gui.sh" \
  --ok-label "Seleccionar" \
  --cancel-label "Salir" \
  --stdout \
  --help-button \
  --menu "Escoja una opción" 13 53 10 \
  "1" "Respaldar Archivos" \
  "2" "Ver/Editar Archivo de configuración" \
  "3" "Ver/Editar Archivos que respaldará" \
  "4" "Tamaño de Archivos que se Respaldarán" \
  "5" "Respaldar configuración" \
  "6" "Salir")
exitcode=$?

case $exitcode in
  0)
    case $listoption in
      1)
        clear

        . "${myhome}"/.ccbackupuser-gui/ccbackupuser_conf

        check_packages

        "$MYDIALOG" --title "Respaldo de Archivos" \
          --backtitle "ccbackupuser-gui.sh - Respaldo" \
          --stdout \
          --yesno "Configuró para respaldo remoto?. Presione Escape para salir." 0 0
        returncode=$?

        case $returncode in
          0)
            "$MYDIALOG" --title "Respaldo de Archivos" \
              --backtitle "ccbackupuser-gui.sh - Respaldo" \
              --stdout \
              --yesno "Iniciar Respaldo?" 0 0
            returncode=$?
       
            case $returncode in
              0)
                clear
                respaldo
                ;;
              1|255)
                "$MYDIALOG" --title "Respaldo de Archivos" \
                  --backtitle "ccbackupuser-gui.sh - Respaldo" \
                  --stdout \
                  --msgbox "Respaldo Cancelado." 0 0
                
                menu
                ;;
            esac
            ;;
          1)
            clear
            if [ ! -d "$DEST" ]; then
              "$MYDIALOG" --title "Respaldo de Archivos" \
                --backtitle "ccbackupuser-gui.sh - Respaldo" \
                --stdout \
                --msgbox "(FALLO) Directorio Destino $DEST no existe" 0 0
              exit_script
            fi
            "$MYDIALOG" --title "Respaldo de Archivos" \
              --backtitle "ccbackupuser-gui.sh - Respaldo" \
              --stdout \
              --yesno "Iniciar Respaldo?" 0 0
            returncode=$?
       
            case $returncode in
              0)
                clear
                respaldo
                ;;
              1|255)
                "$MYDIALOG" --title "Respaldo de Archivos" \
                  --backtitle "ccbackupuser-gui.sh - Respaldo" \
                  --stdout \
                  --msgbox "Respaldo Cancelado." 0 0
                
                menu
                ;;
            esac
            ;;
          255)
            "$MYDIALOG" --title "Respaldo de Archivos" \
              --backtitle "ccbackupuser-gui.sh - Respaldo" \
              --stdout \
              --msgbox "El programa será cerrado" 0 0
            clear
            exit_script
            ;;
        esac
        ;;
      2)
        clear
        EDIT_CONFIG=$("$MYDIALOG" --title "Archivo de configuración" \
          --backtitle "ccbackupuser-gui.sh - Configuración" \
          --stdout \
          --editbox "${myhome}/.ccbackupuser-gui/ccbackupuser_conf" 0 0)
        returncode=$?
        
        case $returncode in
          0)
            printf "%s\n" "$EDIT_CONFIG" > "${myhome}"/.ccbackupuser-gui/ccbackupuser_conf
            sleep 1
            menu
            ;;
          1|255)
            clear
            menu
            ;;
        esac
        ;;
      3)
        clear
        EDIT_BACKUP_LIST=$("$MYDIALOG" --title "Lista de Respaldo" \
          --backtitle "ccbackupuser-gui.sh - Configuración" \
          --stdout \
          --editbox "${myhome}/.ccbackupuser-gui/backup_user_dir.txt" 0 0)
        returncode=$?
        
        case $returncode in
          0)
            printf "%s\n" "$EDIT_BACKUP_LIST" > "${myhome}"/.ccbackupuser-gui/backup_user_dir.txt
            sleep 1
            menu
            ;;
          1|255)
            clear
            menu
            ;;
        esac
        ;;
      4)
        clear

        . "${myhome}"/.ccbackupuser-gui/ccbackupuser_conf

        sizefrombackup
        menu
        ;;
      5)
        clear
        backup_config
        "$MYDIALOG" --title "Respaldo de Configuración" \
          --backtitle "ccbackupuser-gui.sh - Configuración" \
          --stdout \
          --msgbox "\nRespaldo guardado en el Home" 0 0
        menu
        ;;
      6)
        clear
        exit_script
        ;;
    esac
    ;;
  1|255)
    clear
    exit_script
    ;;
  $DIALOG_HELP)
    clear
    "$MYDIALOG" --title "Ayuda" \
      --backtitle "ccbackupuser-gui.sh - Ayuda" \
      --stdout \
      --textbox "${myhome}/.ccbackupuser-gui/ccbackupuser_conf" 0 0
    menu
    ;;
esac

}

menu

