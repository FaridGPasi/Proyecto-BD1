BEGIN TRANSACTION TranExterna;

-- Variables para almacenar IDs
DECLARE @AdminID INT, @ConsorcioID INT;

-- Inserción en la tabla "administrador"
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
VALUES ('JAVIER FRIAS', 'N', '370816973', 'M', '1997-02-24');

-- Obtener el ID del administrador recién insertado
SET @AdminID = SCOPE_IDENTITY(); 

-- Inserción en la tabla "consorcio" con referencia al administrador
INSERT INTO consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
VALUES (1, 1, 3, 'Edificio-9999', 'Remedios Escalada 5407', 1, 1, @AdminID);

-- Simulando un error intencional
-- Cambiar el valor de idconsorcio a un valor que no existe en la tabla "consorcio"
SET @ConsorcioID = 999; -- Valor que no existe en la tabla "consorcio"


-- Intento de inserción de 3 registros en la tabla "gasto" correspondientes al nuevo consorcio
-- Esto debe fallar debido al valor inexistente de @ConsorcioID
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
VALUES
(1, 1, @ConsorcioID, 2023, GETDATE(), 1, 100.00),
(1, 1, @ConsorcioID, 2023, GETDATE(), 2, 200.00),
(1, 1, @ConsorcioID, 2023, GETDATE(), 3, 300.00);

-- Si algo sale mal en cualquier punto, revertimos la transacción
IF @@ERROR <> 0
BEGIN
    ROLLBACK TRAN TranExterna;
END
ELSE
BEGIN
    COMMIT TRAN TranExterna;
END;

-- Instruccion SELECT para ver resultados de los registros insertados
SELECT * FROM gasto WHERE periodo=2023;
go
SELECT * FROM administrador WHERE apeynom= 'JAVIER FRIAS';
go
SELECT * FROM  consorcio WHERE idconsorcio = 5;

