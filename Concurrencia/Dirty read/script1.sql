/*
Lecturas sucias, una transacci�n ve datos intermedios de otra transacci�n.
*/
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN T1
	UPDATE conserje
	SET apeynom = 'NICOLAS VARELA'
	WHERE idconserje = 1
	WAITFOR DELAY '00:00:10'
ROLLBACK TRAN T1