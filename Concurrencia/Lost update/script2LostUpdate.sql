--TRANSACCION 2
BEGIN TRAN T2
	UPDATE provincia 
	SET poblacion = '2'
	WHERE idprovincia = '25'
	SELECT * FROM provincia WHERE idprovincia = '25'
COMMIT TRAN T2