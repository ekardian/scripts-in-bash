# scripts-in-bash
#### Scripts - Alias varios y automatizaciones

IMPORTANTE!!!
----------

Las instrucciones de como usar los scripts/alias se encuentran comentados dentro de los scripts.

Agregando los scripts al directorio `/bin`
---------

```
$ sudo cp -v <script> /bin
$ sudo chmod a+rx /bin/<script>
```
Agregando los alias al `.bash_aliases` de tu `/home/usuario`
---------

```
$ vim .bashrc
```

Descomente las siguientes líneas del archivo `.bashrc` y cree el archivo .bash_aliases

```
 if [ -f "${HOME}/.bash_aliases" ]; then
   source "${HOME}/.bash_aliases"
 fi
```

```
:wq <ENTER>
```

```
$ touch .bash_aliases
```
Una vez agregado los alias/funciones al `.bash_aliases`, actualice el bash ejecutando:
```
$ source ~/.bashrc
```
DONACIÒN
--------
Te sirvió algún script? genial!!!  Sin compromisos me podrías invitar un tecito enviándome una donación (5$ dólares americanos) por Western Union a:

- Nombre: Erwin Marcell Alayn
- Apellidos: Castedo Plantarrosa
- Destino/Ciudad: Yacuiba, Departamento de Tarija, Bolivia
- Notifìcame al Correo electrónico: blkid@protonmail.com

LISTA DE SCRIPTS
----------------

- [backupsystem](scripts/backupsystem) - script en bash con rsync para crear respaldos. Copia/Sincroniza archivos modificados.(Por obviedad la primera sincronización copia todos los archivos y desde la segunda sincronización solos los archivos modificados). Testeado en Linux Mint 21.2 y Debian 12
- [dryncs](scripts/dryncs.src) - script en bash con rsync y dialog para copiar carpetas con nombres con espacio que coincidan con los listados en un archivo.txt. Testeado con Linux Mint 21.2 y Debian 12. Corre en Linux y Windows con cygwin. Instalación, solo clonar el repositorio y dar permisos de ejecutable a los archivos: `chmod a+rx dryncs.src`. Ejecute en consola con `./dryncs.src`.

  Requerimientos:
  - [rsync](https://rsync.samba.org/)(linux/windows cygwin), [dialog](https://linux.die.net/man/1/dialog)(linux/windows cygwin, [lsblk](https://www.geeksforgeeks.org/lsblk-command-in-linux-with-examples/)(linux), [sed](https://www.gnu.org/software/sed/manual/sed.html)
    ````
    $ sudo apt install rsync
    $ sudo apt install dialog
    ````
  - dryncs.scr
  Ejemplo: Copiaré solo las carpetas que contengan A123 y A12345, estas dos cadenas que buscaré estarán contenidas en un archivo.txt.
  Contenido del archivo.txt
    folder-A123
    folder-A12345
  El script copiará solo las carpetas que coinciden con estos dos cadenas de texto, como se vé abajo
  
````  
     source
           |-- folder1
                      |-- folder2  
                                 |--- folder-A123
                                                 |--- file1
                                                 |--- file....
                                 |--- folder-A12345
                                                   |--- file2
                                                   |--- file....
                                 |---- folder-Annnn
                                                   |--- file3
                                                   |--- file....
      Folder-Destino
                   |--- folder-A123
                                   |--- file1
                                   |--- file....
                   |--- folder-A12345
                                   |--- file2
                                   |--- file....
````                 
               
LISTA DE ALIAS
----------------
- [rsync-sshpass](alias/rsync-sshpass) - Copia/Respalda/Sincroniza a otro equipo en la red de forma diferencial(respalda modificados manteniendo los no modificados en la fuente y destino.
