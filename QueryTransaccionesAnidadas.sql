--Transacciones anidadas
/*
En ocaciones necesitamos llamar a un procedimiento dentro de una 
transaccion y que éste a su vez tenga otra transacción, 
con lo cual tendríamos una transacción dentro de otra.

La variable de sql server @@TRANCOUNT indica el numero de transacciones pendientes de finalizar, por ejemplo: 
*/

--Iniciamos una transaccion
BEGIN TRAN 
SELECT @@TRANCOUNT	AS 'TRANSACCIONES PENDIENTES';
--Iniciamos otras 2 transacciones, y observaremos que se han iniciado 3 transacciones
BEGIN TRAN 
BEGIN TRAN 
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
INSERT INTO conserje (ApeyNom,tel,fechnac,estciv) values ('MARCIELLO WALTER', '374443444', '19630910', 'S')
  
    -- Iniciamos otra transaccion "T2"
	BEGIN TRAN  
  
    -- Insertar en tabla  
	INSERT INTO conserje (ApeyNom,tel,fechnac,estciv) values ('OLIVOS CAMILA', '3794113322', '19760521', 'S') 
       
    -- ROLLBACK de inserción de tabla (supuestamente de la "T2")  
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
#Transaccion anidada#
Para hacer un ROLLBACK sin deshacer todos los cambios usaremos la instruccion SAVE TRANS
para crear un punto de guardado.
Sobre el ejemplo anterior, llegado el punto donde queremos iniciar "T2", crearemos un
punto de guardado llamado "TransaccionAnidada". De esta forma al hacer 
ROLLBACK TRAN de TransaccionAnidada, se desharan los cambios solo hasta el punto de guardado
*/

-- Iniciamos una transaccion "T1"   
BEGIN TRAN T1  
-- Insertar en tabla 
INSERT INTO conserje (ApeyNom,tel,fechnac,estciv) values ('MARCIELLO WALTER', '374443444', '19630910', 'S')
  
    -- Guardar Transaccion  
	SAVE TRAN TransaccionAnidada  
  
    -- Insertar en tabla  
	INSERT INTO conserje (ApeyNom,tel,fechnac,estciv) values ('OLIVOS CAMILA', '3794113322', '19760521', 'S') 
  
	-- ROLLBACK de inserción de tabla (2)  
	ROLLBACK TRAN TransaccionAnidada  
  
-- Commit de T1  
COMMIT TRAN T1;

/*
El resultado es el esperado, si hacemos una select de la tabla conserje veremos que 
sólo se ha insertado el registro ('MARCIELLO WALTER', '374443444', '19630910', 'S') 
ya que el otro se ha deshecho.
*/