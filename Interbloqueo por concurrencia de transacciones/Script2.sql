/*
Abrir este y el otro script que se encuentran en la misma carpeta, cada uno en una ventana de consulta distinta
en el DBMS (SQL Server Management Studio en nuestro caso).
La explicacion se encuentra comentada en cada script.
Para observar el interbloqueo, ejecutar *SEGUNDO* este script, ambos hacen un update pero el primero cuenta con 
un delay para dar tiempo a ejecutar este y poder simular la concurrencia de transacciones
*/
USE base_consorcio_proyecto;
GO

--TRANSACCION DOS

--PASO 2

--INICIAR TRANSACCION
BEGIN TRAN
	UPDATE administrador SET apeynom = 'Update 1 Transaccion 2'
	WHERE idadmin = 1

--PASO 4
	UPDATE conserje SET apeynom = 'Update 2 Transaccion 2'
	WHERE idconserje = 1

--CONFIRMAR TRANSACCION
COMMIT TRAN

--Por ultimo se hace una consulta para mostrar cual actualizacion fue la que se realizo
SELECT * FROM conserje
SELECT * FROM administrador

/*
Deadlock, Punto muerto o Interbloqueo.
En una ventana se actualizaran los resultados y en la otra se mostrara un error de interbloqueo ya que la
transaccion que actualizo los resultados tiene bloqueado el proceso y la transaccion de la otra ventana no 
puede acceder a el.
*/