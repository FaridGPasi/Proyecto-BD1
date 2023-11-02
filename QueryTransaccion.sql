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
VALUES (1, 1, 5, 'Edificio-9999', 'Remedios Escalada 5407', 1, 1, @AdminID);

-- Obtener el ID del consorcio recién insertado
SET @ConsorcioID = 5; 

-- Inserción de 3 registros en la tabla "gasto" correspondientes al nuevo consorcio
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
VALUES
(1, 1, @ConsorcioID, 2023, GETDATE(), 1, 100.00),
(1, 1, @ConsorcioID, 2023, GETDATE(), 2, 200.00),
(1, 1, @ConsorcioID, 2023, GETDATE(), 3, 300.00);

-- # # # Comentar COMMIT o ROLLBACK segun lo que se quiera hacer con la transaccion # # #
-- Si todo se ha completado con éxito, confirmamos la transacción externa
COMMIT TRANSACTION TranExterna;

-- Si algo sale mal en cualquier punto, revertimos la transacción
--ROLLBACK TRANSACTION TranExterna;

-- Instruccion SELECT para ver resultados de los registros insertados
SELECT * FROM gasto WHERE periodo=2023;
go
SELECT * FROM administrador WHERE apeynom= 'JAVIER FRIAS';
go
SELECT * FROM  consorcio WHERE idconsorcio = 5;