----------------------------------------------------------------------------
--Ejemplo 1: Registrar nuevo conserje, administrador, consorcio e inmueble
----------------------------------------------------------------------------
BEGIN TRY
    BEGIN TRAN;

    DECLARE @ConserjeID INT, @AdminID INT, @ConsorcioID INT;

    -- Insertar nuevo conserje
    INSERT INTO conserje (apeynom, tel, fechnac, estciv)
    VALUES ('GARNACHO RAMIRO', '379444434', '19730101', 'S');
    SET @ConserjeID = SCOPE_IDENTITY(); 

    -- Insertar nuevo administrador
    INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
    VALUES ('GAUNA GONZALO', 'N', '3794111222', 'M', '19760521');
    SET @AdminID = SCOPE_IDENTITY(); 

    -- Insertar nuevo consorcio
    INSERT INTO consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
    VALUES (1, 1, 102, 'Nuevo Consorcio', 'Nueva Direccion', 1, @ConserjeID, @AdminID);
    SET @ConsorcioID = SCOPE_IDENTITY(); 
 
    -- Insertar nuevo inmueble asociado al consorcio
    INSERT INTO inmueble (idinmueble, nro_piso, dpto, sup_Cubierta, frente, balcon, idprovincia, idlocalidad, idconsorcio)
    VALUES (584, 1, 'B', 120.00, 1, 1, 1, 1, @ConsorcioID);

    -- Confirmar la transaccion
    COMMIT TRAN;
END TRY
BEGIN CATCH
    -- Revertir la transaccion en caso de error 
    ROLLBACK TRAN;
    PRINT 'Error en la transaccion';
END CATCH;
----------------------------------------------------------------------------
--Ejemplo 2: Registrar un nuevo tipo de gasto y un gasto asociado a ese tipo
----------------------------------------------------------------------------
BEGIN TRY
    BEGIN TRAN;

    -- Insertar nuevo tipo de gasto
    INSERT INTO tipogasto (idtipogasto, descripcion)
    VALUES (6, 'Servicios Comunes');

    -- Insertar nuevo gasto asociado al tipo de gasto
    INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    VALUES (1, 1, 1, 1, GETDATE(), 6, 800.00);

    -- Confirmar la transaccion
    COMMIT TRAN;
END TRY
BEGIN CATCH
    -- Deshacerr la transaccion en caso de error 
    ROLLBACK TRAN;
    PRINT 'Error en la transaccion';
END CATCH;

-------------------------------------------
--Ejemplo 3: Registrar una nueva localidad
-------------------------------------------
BEGIN TRY
    BEGIN TRAN;

    -- Insertar nueva localidad
    INSERT INTO localidad (idprovincia, idlocalidad, descripcion)
    VALUES (2, 130, 'Nueva Localidad');

    -- Confirmar la transaccion
    COMMIT TRAN;
END TRY
BEGIN CATCH
    -- Revertir la transaccion en caso de error 
    ROLLBACK TRAN;

    -- Manejar el error (puedes registrar o lanzar una excepcion, segon sea necesario)
    PRINT 'Error en la transaccion';
END CATCH;

select * from localidad