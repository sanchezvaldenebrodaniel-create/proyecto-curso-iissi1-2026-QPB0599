# Alquiler de coches.

## Miembros del grupo L8-AM-5 (sustituir)

1. Parro Muruve, Pablo
1. Fuentes Cuesta, José Joaquín
1. Sánchez Valdenebro, Daniel
1. Ridruejo Dorado, Nicolas

## 1. Introducción al problema

Modelo Tradicional del Alquiler → El alquiler tradicional de coches siempre ha sido visto como un proceso tedioso y poco eficaz. Los clientes se han visto obligados a desplazarse hacia las oficinas para todo, adaptándose a los horarios de las mismas y enfrentándose a unos trámites en mostrador que a nadie le gustan.

Complejidad de la gestión interna → Nuestra empresa se dedica al alquiler de coches de diversas gamas y para diferentes contextos. Sin embargo, ¿verdaderamente sabemos todo lo que conlleva gestionar este tipo de negocios? Más allá de la entrega de llaves, existe una compleja red de procesos: el control de disponibilidad, la asignación de vehículos según categorías, la gestión de seguros y extras, y la supervisión del estado de la flota (mantenimientos y niveles de combustible).

Nuestra visión → Antes de adentrarnos en los detalles de la plataforma, es fundamental establecer nuestra seña de identidad: que el cliente pueda recoger su coche de manera rápida y eficaz, reduciendo los trámites al mínimo indispensable. Buscamos una digitalización real del sector.

Problemas detectados en el sistema → Para lograr este objetivo, hemos detectado los siguientes problemas que nuestro sistema va a solucionar:
Falta de autonomía online: El cliente no dispone de una página web centralizada donde pueda ver la disponibilidad, comparar precios, contratar extras o gestionar su alquiler desde casa.

Horarios muy rígidos: Si un cliente necesita el coche un domingo o su vuelo llega de madrugada, no puede alquilarlo porque la oficina física está cerrada.

Lío con los rayones y golpes: Apuntar a mano en un papel los daños que tiene el coche siempre trae problemas. A veces se le echa la culpa a un cliente que no fue, o la empresa pierde dinero por no haberlo anotado bien.

Cobros y penalizaciones a mano: Si alguien devuelve el coche sin gasolina o cancela tarde, un empleado tiene que calcular la multa, buscar la reserva y cobrarla manualmente. El sistema actual no cruza los datos para aplicar esos recargos de forma automática.


## 2. Glosario de términos

Matrícula → Identificador único y público de cada vehículo dentro de la flota.

Estado → Como se encuentra el coche de cara al alquiler. 

Fecha límite → Día hasta el cual un cliente puede cancelar la reserva de un vehículo de la flota.

Tipo vehículo → Clasificación del coche según tamaño y prestaciones.

Tipo Seguro → Clasificación del seguro según los daños que cubra.

Conductor adicional → Extra que se puede contratar para que otra persona pueda conducir cuando otro realiza la reserva.

Puesto → Labor que ocupa cada trabajador, como por ejemplo, mecánico, administrador.

Fecha Carnet → Fecha en la que el cliente obtuvo el carnet de conducir, para conocer si es conductor novel.

Combustible inicial → Cantidad de combustible que el coche posee cuando lo recoge el cliente en la oficina.

Combustible final → Cantidad de combustible que el coche tiene cuando el cliente lo deja en la oficina.

## 3. Visión general del sistema

### 3.1. Requisitos generales

Requisitos generales → 

- Digitalización del servicio para el cliente (registro del cliente, reservas, coches disponibles, fechas, seguros, extras, etc).

- Facilitar la gestión de la empresa para el personal de la empresa (control y seguimiento del inventario, estado, ubicación, etc).

- Procesar las devoluciones.

- Automatizar cobros ( incluyendo posibles cargos adicionales, precio de extras, penalizaciones, etc).


### 3.2. Usuarios del sistema

Cliente: Es el usuario final que utiliza la plataforma para contratar el servicio. Además de sus credenciales, debe aportar su DNI, teléfono y la fecha de expedición de su carnet de conducir, que se tendrá en consideración a la hora de establecer las condiciones del contrato. Sus interacciones principales son la búsqueda de vehículos, la creación de reservas (asociando seguros y extras como GPS o conductor adicional) y la cancelación de las mismas.

Trabajador - Administrador: Es un empleado con rol de gestión y supervisor, identificado por su ID de trabajador, que será único debido a los privilegios que se le otorgan. Se encarga de la administración global de la plataforma, la gestión del catálogo de vehículos (altas, bajas, modificaciones de precios), el control de las reservas de los clientes y la configuración de las oficinas, así como cualquier problema en alguno de los aspectos del sistema.

Trabajador - Mecánico: Es un empleado con un rol técnico centrado en la logística de la flota. Su función en el sistema está restringida y tan solo se limita a los temas técnicos de los vehículos. Principalmente, consulta qué coches requieren asistencia y actualiza su estado en la plataforma (por ejemplo, pasándolos del estado "en mantenimiento." a "disponible" para que el sistema permita que vuelvan a ser reservados por los clientes).

## 4. Catálogo de requisitos

### 4.1. Requisitos funcionales

RF - 001 Realizar una reserva
Como: Cliente.
Quiero: seleccionar un vehículo disponible en unas fechas y oficinas determinadas para confirmar su reserva.
Para: asegurar un medio de transporte adaptado a mi viaje.

RF - 002 Cancelar una reserva
Como: Cliente.
Quiero: cancelar una reserva a través de la aplicación.
Para: anular el servicio si mis planes cambian sin tener que contactar por teléfono con la empresa.

RF - 003 Cambiar el estado de un vehículo
Como: Trabajador (Mecánico o Administrador).
Quiero: actualizar el estado de un vehículo (por ejemplo, pasarlo de mantenimiento a "disponible").
Para: que el sistema refleje la disponibilidad real del stock y los clientes puedan volver a reservarlo.

RF - 004 Inicio de sesion 
Como: Usuario
Quiero: tener acceso a la aplicación y tener mis datos guardados 
Para: poder acceder al sistema con el rol de Cliente y gestionar mis propias y/o futuras reservas.

RF - 005 Búsqueda filtrada
Como: Cliente.
Quiero: buscar vehículos filtrando por la categoría tipo Vehículo (económico, SUV, furgoneta, automático).
Para: encontrar rápidamente el coche que mejor se ajuste a mis necesidades y preferencias de conducción.

RF - 006 Añadir extras
Como: Cliente.
Quiero: añadir servicios adicionales (GPS, sillas de bebé o conductor adicional) durante el proceso de reserva.
Para: adaptar el equipamiento del vehículo a las características específicas de mi viaje.

RF - 007 Contratar seguro de la reserva
Como: Cliente.
Quiero: seleccionar un tipoSeguro (Básico o Premium) al formalizar mi alquiler.
Para: elegir el tipo de seguro que mejor se adapte a mis condiciones.

RF - 008 Registrar devolución y nivel de combustible
Como: Trabajador (Administrador).
Quiero: registrar el nivel de combustible final (combustible final) en el sistema cuando el cliente devuelve el vehículo en la oficina.
Para: que el sistema compare este dato con el combustible inicial y calcule si debe aplicar automáticamente el cargo por repostaje.

RF - 009 Aplicar penalización por cancelación tardía
Como: Administrador.
Quiero: que el sistema detecte si una cancelación se realiza después de la fecha límite y aplique automáticamente una penalización del 20% sobre el precio de la reserva.
Para: proteger los ingresos de la empresa frente a cancelaciones de última hora que dejan vehículos sin uso.

RF - 010 Consultar vehículos pendientes de revisión
Como: Trabajador (Mecánico).
Quiero: visualizar un listado de todos los vehículos cuyo estado actual sea en mantenimiento.
Para: poder organizar mi jornada de trabajo, localizar los coches que necesitan reparaciones y prepararlos para que vuelvan a estar disponibles.

#### 4.1.1. Requisitos de información

RI - 001 Información sobre los clientes.
Como: propietario de la empresa de alquiler de coches.
Quiero: conocer la información correspondiente a los clientes (nombre, apellidos, carnet de conducir…)
Para: tener un control de los clientes que utilizan la aplicación.

RI - 002 Información sobre los trabajadores.
Como: propietario de la empresa de alquiler de coches.
Quiero: disponer la información correspondiente a los trabajadores (id_trabajador, puesto, correo, nombre…).
Para: controlar la organización y responsabilidades de la empresa.

RI - 003 Información de la flota de vehículos.
Como: propietario de la empresa de alquiler de coches.
Quiero: tener un control sobre todo el stock de coches, junto a su información (matrícula, tipo de vehículo…), y el estado en el que se encuentran.
Para: conocer el inventario exacto y la disponibilidad en tiempo real.

RI 004 Información sobre las reservas.
Como: propietario de la empresa de alquiler de coches.
Quiero: saber los detalles de las reservas realizadas por los clientes (fecha de recogida, fecha de devolución, oficina de recogida…)
Para: tener un registro de cada alquiler y gestionar las entregas.

RI - 005 Información sobre los cobros.
Como: propietario de la empresa de alquiler de coches.
Quiero: controlar que los pagos se hayan realizado antes de la recogida del vehículo.
Para: realizar un seguimiento sobre los cobros.

RI - 006 Información sobre las penalizaciones.
Como: propietario de la empresa de alquiler de coches.
Quiero: disponer de la información sobre las penalizaciones ( motivo, coste, …).
Para: asegurar el cobro de esas penalizaciones.

RI - 007 Información sobre ofertas y promociones.
Como:  propietario de la empresa de alquiler de coches.
Quiero: disponer de la información correspondiente a las promociones: código promocional, descripción, porcentaje de descuento, fecha de inicio y fecha de caducidad.
Para: disponer del catálogo de ofertas y fidelizar clientes.

#### 4.1.2. Reglas de negocio

RN - 001 Restricción de disponibilidad.
Un vehículo no puede ser reservado, si su estado actual es en mantenimiento o si ya está alquilado por otro cliente.

RN - 002 Restricción de fecha.
Un vehículo no puede ser devuelto más tarde de la fecha de devolución pactada en la reserva.

RN - 003 Penalización de combustible.
Si un cliente entrega el coche con menos combustible que la cantidad de combustible inicial, se aplicará automáticamente un cargo adicional

RN - 004 Penalización de cancelación.
Si el sistema detecta que la cancelación de la reserva ha sido realizada posteriormente a la fecha límite, se aplicará un cargo adicional automáticamente.

RN - 005 Obligatoriedad de contratación de seguro.
Ninguna reserva podrá ser finalizada sin haber seleccionado uno de los dos tipos de seguros. 

RN - 006 Restricción de antigüedad de carnet.
Los clientes deben tener una antigüedad mínima de carnet de un año  para poder conducir el vehículo .

### 4.2. Mapa de historias de usuario (opcional)

### 4.3. Requisitos no funcionales (opcional)

**R.N.F. 01. Título requisito no funcional**
Como [tipo de usuario]
quiero [servicio]
para [razón]

-- fin entregable 1 --

## 5. Modelo conceptual

### 5.1. Diagramas de clases UML

- con restricciones.

### 5.2. Escenarios de prueba

- con descripción textual y diagrama de objetos UML.

## 6. Matrices de trazabilidad

- Matriz de trazabilidad entre los elementos del modelo conceptual y los requisitos.

|       | EntidadX   | AsociaciónX  | RestricciónX  | Entidad2 ...   | 
|:------|:-----------|:-----------|:-----------|:-----------|
| RI-1  | X          | X          | X          | X          |
| RI-2  |            | X          |            | X          |
| RF-1  |            | X          |            | X          |
| RF-2  | X          |            | X          | X          |
| RN-1  |            | X          |            |            |
| RN-2  | X          | X          | X          |            |
| ...   |            |            |            |            |

-- fin entregable 2 --

## 7. Modelo relacional en 3FN

- Relaciones obtenidas al aplicar la transformación del modelo conceptual.

### 7.1.  Justificación de la estrategia de transformación de jerarquías

- si se identificaron jerarquías en el MC.


### 8. Matriz de trazabilidad MC/SQL (opcional):

- Restricciones sobre el MC / Elementos del modelo tecnológico (SQL) (Triggers, checks, etc.)
- Incluir Reglas de negocio — Constraints/Triggers en las matrices de trazabilidad para el entregable 3

|       | EntidadX   | AsociaciónX  | RestricciónX  | Entidad2 ...   | 
|:-------|:-------|:-------|:-------|:-------|
| TABLA-1 |        |        |        |        |
| TABLA-2 |        |        |        |        |
| TABLA-3 |        |        |        |        |
| TABLA-4 |        |        |        |        |
| TRIG-1 |        |        |        |        |
| TRIG-2 | X      | X      |        | X      |
| TRIG-3 |        | X      |        | X      |
| TRIG-4 |        |        | X      |        |
| CONST-1 |        |        |        |        |
| CONST-2 | X      | X      |        | X      |
| CONST-3 |        | X      |        | X      |
| CONST-4 |        |        | X      |        |

Se consideran todo tipo de constraints declarativas (aquellas definidas durante el CREATE TABLE).
-- fin entregable 3 --

## Referencias


