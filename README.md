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
Agregado los alias/funciones al `.bash_aliases`, actualice el bash ejecutando:
```
$ source ~/.bashrc
```
LISTA DE SCRIPTS
----------------

- [backupsystem](scripts/backupsystem) - script en bash con rsync para crear respaldos. Copia/Sincroniza archivos modificados.(Por obviedad la primera sincronización copia todos los archivos).
