-- ScriptUsuario2
/*
Abrir cada uno de los tres scripts de esta carpeta, cada uno en una ventana distinta de DBMS (SQL Server 
Management Studio en nuestro caso), los pasos a seguir para el ejemplo estan comentados en cada uno
*/

-- PASO 3: EJECUTAR ESTE SCRIPT

USE base_consorcio_proyecto;
-- Se conecta como Usuario2 y ejecuta el procedimiento
EXECUTE AS LOGIN = 'Usuario2';

EXEC Usuario2ActualizarRegistro;

-- Desconecta Usuario2
REVERT;

/*
Al intentar actualizar el mismo registro, deberia haber un bloqueo por la transaccion de Usuario1 por lo que 
esta consulta quedara en espera hasta que Usuario1 confirme o deshaga la transaccion
*/

-- PASO 4: Volver a ScriptUsuario1, ejecutar COMMIT para liberar el bloqueo

/* 
PASO 6: Ejecutar SELECT @@TRANCOUNT y veremos que hay una transaccion pendiente, la cual inciamos con
este Usuario2 y quedo bloqueada por la transaccion de Usuario1
*/

SELECT @@TRANCOUNT

/* 
PASO 7: Por ultimo podemos hacer COMMIT O ROLLBACK de esta transaccion, ya que el bloqueo fue liberado
*/

COMMIT TRAN
-- o
--ROLLBACK TRAN


