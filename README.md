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
               
LISTA DE ALIAS
----------------
- [rsync-sshpass](alias/rsync-sshpass) - Copia/Respalda/Sincroniza a otro equipo en la red de forma diferencial(respalda modificados manteniendo los no modificados en la fuente y destino.
