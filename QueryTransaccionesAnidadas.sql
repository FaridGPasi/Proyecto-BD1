--Transacciones anidadas
USE base_consorcio_proyecto;
/*
En ocaciones necesitamos llamar a un procedimiento dentro de una transaccion y 
que �ste a su vez tenga otra transacci�n, con lo cual tendr�amos una transacci�n
dentro de otra.
La variable de sql server @@TRANCOUNT indica el numero de transacciones pendientes
de finalizar. Por ejemplo: 
*/

--Iniciamos una transaccion
BEGIN TRAN 
SELECT @@TRANCOUNT	AS 'TRANSACCIONES PENDIENTES';
--Iniciamos otras 2 transacciones
BEGIN TRAN 
BEGIN TRAN 
--Observaremos que se han iniciado 3 transacciones
SELECT @@TRANCOUNT	AS 'TRANSACCIONES PENDIENTES (2)';

--ROOLBACK deshace TODOS los cambios hasta el primer BEGIN TRAN y establece @@TRANCOUNT a 0
ROLLBACK TRAN 
SELECT @@TRANCOUNT AS 'ROLLBACK';

/*
Si hacemos una transaccion dentro de otra obtendriamos un error.
Por Ejemplo:
*/

-- Iniciamos una transaccion "T1"  
BEGIN TRAN  
-- Insertar en tabla  
INSERT INTO conserje (ApeyNom,tel,fechnac,estciv) VALUES ('MARCIELLO WALTER', '374443444', '19630910', 'S')
  
    -- Iniciamos otra transaccion "T2"
	BEGIN TRAN  
  
    -- Insertar en tabla  
	INSERT INTO conserje (ApeyNom,tel,fechnac,estciv) VALUES ('OLIVOS CAMILA', '3794113322', '19760521', 'S') 
       
    -- ROLLBACK de inserci�n de tabla (supuestamente de la "T2")  
	ROLLBACK TRAN  
  
-- Hacemos un supuesto commit de "T1" que dara error
COMMIT TRAN

/*
Lo que quisimos hacer es iniciar una transaccion(T1) para insertar un registro
en conserje, luego iniciar otra transaccion(T2) para insertar otro registro,
y de esta segunda transaccion hacer un ROLLBACK para deshacer la insercion de ella,
pero al hacer ROLLBACK hemos deshecho las dos inserciones, por eso el COMMIT da error
ya que no hay ninguna transaccion pendiente.
*/


/*
Uso de Transacciones anidadas.
Para lograr el cometido anterior, que ser�a hacer un ROLLBACK sin deshacer todos 
los cambios, usaremos la instruccion SAVE TRAN para crear un punto de guardado.
Sobre el ejemplo anterior, llegado el punto donde queremos iniciar "T2", crearemos 
un punto de guardado llamado "TransaccionAnidada". De esta forma al hacer ROLLBACK
TRAN de TransaccionAnidada, se desharan los cambios solo hasta el punto de guardado.
*/

-- Iniciamos una transaccion "T1"   
BEGIN TRAN T1  
-- Insertar en tabla (1)
INSERT INTO conserje (ApeyNom,tel,fechnac,estciv) VALUES ('MARCIELLO WALTER', '374443444', '19630910', 'S')
  
    -- Guardar Transaccion  
	SAVE TRAN TransaccionAnidada  
  
    -- Insertar en tabla (2)
	INSERT INTO conserje (ApeyNom,tel,fechnac,estciv) VALUES ('OLIVOS CAMILA', '3794113322', '19760521', 'S') 
  
	-- ROLLBACK de inserci�n de tabla (2)  
	ROLLBACK TRAN TransaccionAnidada  
  
-- Commit de T1  
COMMIT TRAN T1;

/*
El resultado es el esperado, si hacemos un SELECT de la tabla conserje veremos que 
s�lo se ha insertado (1), el registro ('MARCIELLO WALTER', '374443444', '19630910', 'S') ,
ya que el otro(2) se ha deshecho.
*/

------------------------------------------------------------------------------------------

/*
Ejemplo de un caso de uso COMPLETO de transacciones anidadas.
*/

-- Iniciar la transacci�n principal
BEGIN TRAN;

-- Insertar un nuevo consorcio (operaci�n en la transacci�n principal)
INSERT INTO consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
VALUES (1, 1, 101, 'Consorcio Principal', 'Direcci�n Principal', 1, 1, 1);

-- Iniciar una transacci�n anidada
SAVE TRAN TransaccionAnidada;

-- Intentar insertar un nuevo inmueble (operaci�n en la transacci�n anidada)
BEGIN TRY
    INSERT INTO inmueble (idinmueble, nro_piso, dpto, sup_Cubierta, frente, balcon, idprovincia, idlocalidad, idconsorcio)
    VALUES (1, 1, 'A', 100.00, 1, 0, 1, 1, 101);

    -- Confirmar la transacci�n anidada
    COMMIT TRAN TransaccionAnidada;

-- Capturar cualquier error en la transacci�n anidada
END TRY
BEGIN CATCH
    -- Revertir la transacci�n anidada en caso de error
    ROLLBACK TRAN TransaccionAnidada;

    -- Manejar el error (puedes registrar o lanzar una excepci�n, seg�n sea necesario)
    PRINT 'Error al insertar en la transacci�n anidada';
END CATCH;

-- Confirmar la transacci�n principal
COMMIT TRAN;

------------------------------------------------------------------------------------------

/*
Otro Ejemplo de un caso de uso COMPLETO de transacciones anidadas.
*/

-- Iniciar la transacci�n principal
BEGIN TRY
    BEGIN TRAN;

    DECLARE @AdminID INT, @ConserjeID INT, @ConsorcioID INT;

    -- Insertar nuevo conserje
    INSERT INTO conserje (apeynom, tel, fechnac, estciv)
    VALUES ('LOPEZ MICAELA', '379444434', '19730101', 'S');
    SET @ConserjeID = SCOPE_IDENTITY(); 

    -- Insertar nuevo administrador
    INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
    VALUES ('BASABE MARTIN', 'N', '3794111222', 'M', '19760521');
    SET @AdminID = SCOPE_IDENTITY(); 

    -- Insertar nuevo consorcio
    INSERT INTO consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
    VALUES (1, 1, 101, 'Consorcio Principal', 'Direcci�n Principal', 1, @ConserjeID, @AdminID);
    SET @ConsorcioID = SCOPE_IDENTITY(); 
 
    -- Iniciar una transacci�n anidada para insertar un nuevo inmueble
    SAVE TRAN TransaccionAnidada;

    BEGIN TRY
        -- Insertar nuevo inmueble
        INSERT INTO inmueble (idinmueble, nro_piso, dpto, sup_Cubierta, frente, balcon, idprovincia, idlocalidad, idconsorcio)
        VALUES (583, 1, 'A', 100.00, 1, 0, 1, 1, @ConsorcioID);

        -- Confirmar la transacci�n anidada
        COMMIT TRAN TransaccionAnidada;

    -- Capturar cualquier error en la transacci�n anidada
    END TRY
    BEGIN CATCH
        -- Revertir la transacci�n anidada en caso de error
        ROLLBACK TRAN TransaccionAnidada;

        -- Manejar el error (puedes registrar o lanzar una excepci�n, seg�n sea necesario)
        PRINT 'Error al insertar en la transacci�n anidada';
        THROW; -- Propagar el error para que sea capturado por el bloque CATCH exterior
    END CATCH;

    -- Confirmar la transacci�n principal
    COMMIT TRAN;
END TRY
BEGIN CATCH
    -- Revertir la transacci�n principal en caso de error 
    ROLLBACK TRAN;

    -- Manejar el error (puedes registrar o lanzar una excepci�n, seg�n sea necesario)
    PRINT 'Error al insertar en la transacci�n principal';
END CATCH;

