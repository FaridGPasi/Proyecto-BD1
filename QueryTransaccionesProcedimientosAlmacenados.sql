use base_consorcio_proyecto;
GO
--Procedimiento almacenado para realizar insercion en consorcio con transacciones
CREATE PROCEDURE InsertarConsorcio
    @idprovincia INT,
    @idlocalidad INT,
    @idconsorcio INT,
    @nombre VARCHAR(50),
    @direccion VARCHAR(250),
    @idzona INT,
    @idconserje INT,
    @idadmin INT
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacción
        BEGIN TRAN;

        -- Insertar un nuevo consorcio
        INSERT INTO consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
        VALUES (@idprovincia, @idlocalidad, @idconsorcio, @nombre, @direccion, @idzona, @idconserje, @idadmin);

        -- Confirmar la transacción
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRAN;

        -- Manejar el error (puedes registrar o lanzar una excepción, según sea necesario)
        PRINT 'Error al insertar el consorcio. Se ha revertido.';
    END CATCH;
END;
GO
--Procedimiento almacenado para realizar insercion en inmueble
CREATE PROCEDURE InsertarInmueble
    @idinmueble INT,
    @nro_piso INT,
    @dpto VARCHAR(1),
    @sup_Cubierta DECIMAL(6,2),
    @frente BIT,
    @balcon BIT,
    @idprovincia INT,
    @idlocalidad INT,
    @idconsorcio INT
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacción
        BEGIN TRAN;

        -- Insertar un nuevo inmueble
        INSERT INTO inmueble (idinmueble, nro_piso, dpto, sup_Cubierta, frente, balcon, idprovincia, idlocalidad, idconsorcio)
        VALUES (@idinmueble, @nro_piso, @dpto, @sup_Cubierta, @frente, @balcon, @idprovincia, @idlocalidad, @idconsorcio);

        -- Confirmar la transacción
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRAN;

        -- Manejar el error (puedes registrar o lanzar una excepción, según sea necesario)
        PRINT 'Error al insertar el inmueble. Se ha revertido.';
    END CATCH;
END;
GO
-- Iniciar la transacción principal
BEGIN TRAN;

-- Llamar al procedimiento para insertar el consorcio
EXEC InsertarConsorcio 1, 1, 101, 'Consorcio Principal', 'Dirección Principal', 1, 1, 1;

-- Llamar al procedimiento para insertar el inmueble
EXEC InsertarInmueble 1, 1, 'A', 100.00, 1, 0, 1, 1, 101;

-- Confirmar la transacción principal
COMMIT TRAN;

SELECT * FROM consorcio