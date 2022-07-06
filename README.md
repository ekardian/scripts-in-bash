# scripts-in-bash
#### Scripts - alias varios y automatizaciones

##IMPORTANTE!!!
Las instrucciones de como usar los scripts/alias se encuentran comentados dentro de los scripts.

### Agregando los scripts al directorio /bin

Para que los scripts se ejecuten como comandos en el bash, copie el script al directorio /bin y cambio los atributos como ejecutables
```
$ sudo cp -v <script> /bin
$ sudo chmod a+rx /bin/<script>
```
### Agregando los alias al .bash_aliases de tu /home/<uusario>

Descomente las siguientes líneas del archivo .bashrc y cree el archivo .bash_aliases

```
$ vim .bashrc
```
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
## LISTA DE SCRIPTS
- backupsystem - script en bash con rsync para crear respaldos. El script sincroniza solo los archivos modificados después de la primera copia.
