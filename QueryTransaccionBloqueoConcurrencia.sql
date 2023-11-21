/*
Situacion de bloqueo por concurrencia 
Dos transacciones intentan modificar los mismos datos al mismo tiempo.
Veamos que tenemos dos usuarios que ejecutan consultas y actualizan registros en una tabla al mismo
tiempo.
*/

Supongamos que tienes la siguiente tabla inmueble:

CREATE TABLE inmueble (
    idinmueble INT PRIMARY KEY,
    nro_piso INT,
    dpto VARCHAR(1),
    sup_Cubierta DECIMAL(6, 2),
    frente BIT,
    balcon BIT,
    idprovincia INT NULL,
    idlocalidad INT NULL,
    idconsorcio INT NULL
);

-- Insertar algunos datos de ejemplo
INSERT INTO inmueble (idinmueble, nro_piso, dpto, sup_Cubierta, frente, balcon, idprovincia, idlocalidad, idconsorcio)
VALUES
    (1, 1, 'A', 100.00, 1, 0, 1, 1, 101),
    (2, 2, 'B', 120.00, 0, 1, 1, 1, 102);

Ahora, supongamos que dos usuarios est�n ejecutando transacciones simult�neas:

Usuario 1 (Transacci�n 1):

-- Usuario 1 intenta actualizar el inmueble con idinmueble = 1
BEGIN TRANSACTION;

UPDATE inmueble
SET nro_piso = 3
WHERE idinmueble = 1;

-- Aqu�, el usuario 1 no ha confirmado o revertido la transacci�n a�n

Usuario 2 (Transacci�n 2):

-- Usuario 2 intenta actualizar el mismo inmueble con idinmueble = 1
BEGIN TRANSACTION;

UPDATE inmueble
SET sup_Cubierta = 150.00
WHERE idinmueble = 1;

-- Aqu�, el usuario 2 no ha confirmado o revertido la transacci�n a�n

En este punto, ambos usuarios han iniciado transacciones y est�n intentando actualizar el mismo 
registro (idinmueble = 1). Ahora, si uno de los usuarios intenta confirmar la transacci�n, 
se producir� un bloqueo hasta que la transacci�n del otro usuario se complete. Este bloqueo 
es necesario para garantizar la consistencia de los datos y evitar situaciones donde dos 
transacciones intentan modificar los mismos datos simult�neamente.

Si uno de los usuarios intenta confirmar la transacci�n (COMMIT), la transacci�n quedar� 
bloqueada hasta que la transacci�n del otro usuario tambi�n se complete o se revierta. 
El bloqueo garantiza la integridad de los datos y evita que dos transacciones modifiquen los 
mismos datos al mismo tiempo, lo que podr�a conducir a resultados incoherentes o p�rdida de datos.