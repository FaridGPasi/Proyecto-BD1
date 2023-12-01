/*
Una actualizaci�n perdida es un escenario en el que dos o m�s transacciones actualizan 
la misma fila, pero ninguna de ellas tiene conocimiento de la modificaci�n realizada 
por la otra y el segundo cambio sobrescribe la primera modificaci�n.
*/

INSERT provincia(idprovincia, descripcion, km2, cantdptos, poblacion, nomcabe)
VALUES (25, 'NUEVA PROV', 100000, 15, 120000, 'NUEVA PROV')
SELECT * FROM provincia

--TRANSACCION 1
BEGIN TRAN T1
	WAITFOR DELAY '00:00:10'
	UPDATE provincia 
	SET poblacion = '1'
	WHERE idprovincia = '25'
	SELECT * FROM provincia WHERE idprovincia = '25'
COMMIT TRAN T1


DELETE FROM provincia WHERE idprovincia = '25'
--SELECT * FROM provincia