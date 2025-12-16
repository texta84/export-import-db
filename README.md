 # Script para exportar e importar bases de datos en MySQL

## Información de uso

* **Usuario** - Solicitará el nombre de usuario para el servidor MySQL
* **Password** - Solicitará el password de usuario para el servidor MySQL
* **Host** - Solicitará el nombre del host para el servidor MySQL, si no se coloca nada usará el predeterminado que es `127.0.0.1`
* **Puerto** - Solicitará el nombre del puerto para el servidor MySQL, si no se coloca nada usará el predeterminado que es `3306`
* **Ruta** - Solicitará la ruta de donde se va a importar o hacía donde se van a exportar los archivos `.sql`
* **Comando** - Solicitará ingresar la letra `i`  (Minúscula) para importar o la letra `e` (Minúscula) para exportar

***NOTA:** `Importará todos los archivos con extensión .sql que esten dentro de la carpeta de la ruta especificada o exportará todas las bases de datos que estén en el servidor MySQL y las guardará en la ruta especificada con extensión .sql posteriormente creará un archivo .tar.gz con estos archivos`
