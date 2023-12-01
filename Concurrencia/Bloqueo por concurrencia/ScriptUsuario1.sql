-- ScriptUsuario1
/*
Abrir cada uno de los tres scripts de esta carpeta, cada uno en una ventana distinta de DBMS (SQL Server 
Management Studio en nuestro caso), los pasos a seguir para el ejemplo estan comentados en cada uno
*/

-- PASO 2: EJECUTAR ESTE SCRIPT

USE base_consorcio_proyecto;
-- Se conecta como Usuario1 y ejecuta el procedimiento
EXECUTE AS LOGIN = 'Usuario1';

EXEC Usuario1ActualizarRegistro;

-- Desconecta Usuario1
REVERT;

/*
SQL Server mostrara un error de que la transaccion en curso no fue confirmada ni cancelada,
pero lo ignoraremos con el fin de observar el ejemplo practico, ahora ir a ScriptUsuario2
*/

/*
PASO 5: ejecutar COMMIT para confirmar la transaccion y liberar el bloqueo, 
luego Volver a la ScriptUsuario2
*/
COMMIT TRAN