# scripts-in-bash
#### Scripts - Alias - automation

IMPORTANT!!!
-

English
The instructions there are inside scripts/aloias

Español
Las instrucciones de como usar los scripts/alias se encuentran comentados dentro de los scripts.

Adding scripts to `/bin` directory
-

```
$ sudo cp -v <script> /bin
$ sudo chmod a+rx /bin/<script>
```

Try the script in a directory
-

```
$ mkdir testing
$ cp -v script.sh testing/
$ cd testing/
$ chmod 755 script.sh
$ ./script.sh
```

Adding alias to `.bash_aliases` to your `/home/usuario`
-

```
$ vim .bashrc
```

Uncomment the lines from `.bashrc` and create the `.bash_aliases` file
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
Once added the alias/functions to `.bash_aliases`, update executing

```
$ source ~/.bashrc
```
DONATION
--------
Works for you? grate!!!! You can give me a donation via Wester Union, thanks XD

- Name: Erwin Marcell Alayn
- Last Name: Castedo Plantarrosa
- City/Country: Yacuiba, Departamento de Tarija, Bolivia
- Notify me by email : blkid@protonmail.com

Te sirvió algún script? genial!!!  Sin compromisos me podrías invitar un tecito enviándome una donación (5$ dólares americanos) por Western Union.
LISTA DE SCRIPTS
----------------

- [backupsystem](scripts/backupsystem) - script en bash con rsync para crear respaldos. Copia/Sincroniza archivos modificados.(Por obviedad la primera sincronización copia todos los archivos y desde la segunda sincronización solos los archivos modificados). Testeado en Linux Mint 21.2 y Debian 12
- [add-numbers-before-filename.sh](https://github.com/ekardian/scripts-in-bash/blob/main/scripts/add-numbers-before-filename.sh) - Add Letter and numbers before the file name for serialized files
- [add-numbers-before-extension.sh](https://github.com/ekardian/scripts-in-bash/blob/main/scripts/add-numbers-before-extension.sh) - Add Letter and numbers before the extension for serialized files
- [search-add-strings-before-extension-filename.sh.sh](https://github.com/ekardian/scripts-in-bash/blob/main/scripts/search-add-strings-before-extension-filename.sh) - Search in directories and add Letter and numbers before the extension for serialized file
  
LISTA DE ALIAS
----------------
- [rsync-sshpass](alias/rsync-sshpass) - Copia/Respalda/Sincroniza a otro equipo en la red de forma diferencial(respalda modificados manteniendo los no modificados en la fuente y destino.
