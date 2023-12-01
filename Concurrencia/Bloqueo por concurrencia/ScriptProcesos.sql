/*
Abrir los tres scripts de esta carpeta, cada uno en una ventana distinta del DBMS (SQL Server Management 
Studio en nuestro caso), los pasos a seguir para el ejemplo estan comentados en cada uno.

Ejemplo de bloqueo por concurrencia incorporando permisos a nivel de usuario.
En este ejemplo, Usuario1 inicia una transacción, actualiza un registro y mantiene la transacción activa. 
Mientras tanto, Usuario2 intenta actualizar el mismo registro, lo que genera un bloqueo hasta que 
Usuario1 completa o revierte la transacción.
*/

-- PASO 1: EJECUTAR ESTE SCRIPT, luego ir a ScriptUsuario1

USE base_consorcio_expo;

--Se crean dos usuarios de base de datos
CREATE LOGIN Usuario1 WITH PASSWORD = '1234';
CREATE LOGIN Usuario2 WITH PASSWORD = '1234';

--Se les asignan permisos de administrador a los usuarios
CREATE USER UsuarioP1 FOR LOGIN UsuarioP1;
ALTER ROLE db_owner ADD MEMBER UsuarioP1;

CREATE USER UsuarioP2 FOR LOGIN UsuarioP2;
ALTER ROLE db_owner ADD MEMBER UsuarioP2;
GO

-- Procedimiento almacenado para Usuario1
CREATE PROCEDURE Usuario1ActualizarRegistro
AS
BEGIN
   
   --Iniciar Transaccion
    BEGIN TRAN;

    -- Actualizar el registro
    UPDATE inmueble SET sup_Cubierta = 100 WHERE idinmueble = 1;
	
    -- NO hace COMMIT ni ROLLBACK
END;
GO

-- Procedimiento almacenado para Usuario2
CREATE PROCEDURE Usuario2ActualizarRegistro
AS
BEGIN
    
	--Iniciar Transaccion
    BEGIN TRAN;

    -- Actualiza el registro
    UPDATE inmueble SET sup_Cubierta = 200 WHERE idinmueble = 1;

    -- NO hace COMMIT ni ROLLBACK
END;
GO






/*Crear usuario con permisos de lectura*/
CREATE LOGIN UsuarioLectura WITH PASSWORD = '1234';
CREATE USER UsuarioLectura FOR LOGIN UsuarioLectura;
/*Conceden el permiso de lectura (SELECT) en el esquema 
por defecto (dbo) de la base de datos*/
GRANT SELECT ON SCHEMA::dbo TO UsuarioLectura;

/*Conceder permisos para que ejecute un procedimiento*/
GRANT EXECUTE ON dbo.Usuario1ActualizarRegistro TO UsuarioLectura;


