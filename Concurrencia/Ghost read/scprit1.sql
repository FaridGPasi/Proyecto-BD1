SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRAN
	SELECT * FROM conserje
	WHERE idconserje > 100 
	WAITFOR DELAY '00:00:10'

	SELECT * FROM conserje
	WHERE idconserje > 100
COMMIT TRAN

/*
supongamos que dos transacciones se ejecutan simultáneamente 
con el nivel de aislamiento READ COMMITTED

En este escenario, si la Transacción A ejecuta sus dos lecturas 
en un intervalo de tiempo en el que la Transacción B realiza una 
inserción, es posible que la segunda lectura de la Transacción A 
incluya la nueva fila insertada por la Transacción B. Esto es un 
ejemplo de lectura fantasma, ya que la transacción A "ve" una fila 
que no estaba presente en la primera lectura.

Para evitar la lectura fantasma, podríamos utilizar un nivel de 
aislamiento más alto, como REPEATABLE READ o SERIALIZABLE, al iniciar 
la transacción A:

Esto ayudaría a prevenir la lectura fantasma al bloquear las filas 
seleccionadas durante toda la transacción A. Sin embargo, hay que 
tener en cuenta que niveles de aislamiento más altos también pueden 
llevar a problemas de rendimiento y bloqueo, por lo que su uso debe 
ser cuidadosamente considerado.
*/