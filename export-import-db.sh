#!/bin/bash
#@texta84

echo -n "Usuario: "
read DB_USER
echo -n "Password: "
read -s DB_PASSWORD
echo -e -n "\nHost(127.0.0.1): "
read DB_HOST
if [ -z "$DB_HOST" ]; then
  DB_HOST="${DB_HOST:-"127.0.0.1"}"
fi
echo -n "Puerto(3306): "
read DB_PORT
if [ -z "$DB_PORT" ]; then
  DB_PORT="${DB_PORT:-"3306"}"
fi
echo -n "Ruta: "
read SQL_DIR
echo -n "Comando (i = Importar o e = Exportar): "
read DB_COMMAND
if [ "$DB_COMMAND" == "i" ]
then
    for sql_file in "$SQL_DIR"/*.sql; do
        if [ -f "$sql_file" ]; then
            file_name=$(basename "$sql_file")
            database=${file_name%%.*}
            echo -e "\nImportando: $database"
            mysqladmin -u "$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" -f drop "$database" 2>/dev/null || true
            mysqladmin -u "$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" create "$database"
            mysql -u "$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" -f "$database" < "$sql_file"
            if [ $? -eq 0 ]; then
                echo "Se importó: $database"
            else
                echo "Error al importar: $database"
            fi
        fi
    done
    echo -e "\nTerminó el proceso importar"
elif [ "$DB_COMMAND" == "e" ]
then
    for database in $(mysql -u"$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" -e "SHOW DATABASES"); do
        if [[
            "$database" != "schema_name"
            && "$database" != "Database"
            && "$database" != "information_schema"
            && "$database" != "mysql"
            && "$database" != "performance_schema"
            && "$database" != "sys"
           ]]; then
           echo -e "\nExportando: $database"
           mysqldump -u"$DB_USER" -p"$DB_PASSWORD" -P"$DB_PORT" -h"$DB_HOST" -f "$database" > "$SQL_DIR/$database.sql"
           if [ $? -eq 0 ]; then
               echo "Se exportó: $database"
           else
               echo "Error al exportar: $database"
           fi
        fi
    done
    echo -e "\nComprimiendo. . ."
    cd "$SQL_DIR" && tar -czvf $(date "+%Y%m%d_%H%M")_"$DB_HOST".tar.gz -C "$SQL_DIR" *.sql --remove-files
    echo -e "\nTerminó el proceso exportar"
else
	echo -e "\n\n****** ERROR: No ingresaste el comando correcto, ingresa una letra 'i' para importar o una letra 'e' para exportar ******"
fi
