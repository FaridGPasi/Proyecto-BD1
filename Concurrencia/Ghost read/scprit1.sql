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
supongamos que dos transacciones se ejecutan simult�neamente 
con el nivel de aislamiento READ COMMITTED

En este escenario, si la Transacci�n A ejecuta sus dos lecturas 
en un intervalo de tiempo en el que la Transacci�n B realiza una 
inserci�n, es posible que la segunda lectura de la Transacci�n A 
incluya la nueva fila insertada por la Transacci�n B. Esto es un 
ejemplo de lectura fantasma, ya que la transacci�n A "ve" una fila 
que no estaba presente en la primera lectura.

Para evitar la lectura fantasma, podr�amos utilizar un nivel de 
aislamiento m�s alto, como REPEATABLE READ o SERIALIZABLE, al iniciar 
la transacci�n A:

Esto ayudar�a a prevenir la lectura fantasma al bloquear las filas 
seleccionadas durante toda la transacci�n A. Sin embargo, hay que 
tener en cuenta que niveles de aislamiento m�s altos tambi�n pueden 
llevar a problemas de rendimiento y bloqueo, por lo que su uso debe 
ser cuidadosamente considerado.
*/