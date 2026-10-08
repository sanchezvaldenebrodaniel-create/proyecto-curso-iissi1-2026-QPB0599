# Título Proyecto

## Miembros del grupo LX-XXX-X (sustituir)

1. Parro Muruve, Pablo
1. Sánchez Valdenebro, Daniel
1. Ridruejo Dorado, Nicolás 
1. Fuentes Cuesta, José Joaquín

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

Digitalización del servicio para el cliente (registro del cliente, reservas, coches disponibles, fechas, seguros, extras, etc).

Facilitar la gestión de la empresa para el personal de la empresa (control y seguimiento del inventario, estado, ubicación, etc).

Procesar las devoluciones.

Automatizar cobros ( incluyendo posibles cargos adicionales, precio de extras, penalizaciones, etc).


### 3.2. Usuarios del sistema
Cliente: Es el usuario final que utiliza la plataforma para contratar el servicio. Además de sus credenciales, debe aportar su DNI, teléfono y la fecha de expedición de su carnet de conducir, que se tendrá en consideración a la hora de establecer las condiciones del contrato. Sus interacciones principales son la búsqueda de vehículos, la creación de reservas (asociando seguros y extras como GPS o conductor adicional) y la cancelación de las mismas.

Trabajador - Administrador: Es un empleado con rol de gestión y supervisor, identificado por su ID de trabajador, que será único debido a los privilegios que se le otorgan. Se encarga de la administración global de la plataforma, la gestión del catálogo de vehículos (altas, bajas, modificaciones de precios), el control de las reservas de los clientes y la configuración de las oficinas, así como cualquier problema en alguno de los aspectos del sistema.

Trabajador - Mecánico: Es un empleado con un rol técnico centrado en la logística de la flota. Su función en el sistema está restringida y tan solo se limita a los temas técnicos de los vehículos. Principalmente, consulta qué coches requieren asistencia y actualiza su estado en la plataforma (por ejemplo, pasándolos del estado "en mantenimiento." a "disponible" para que el sistema permita que vuelvan a ser reservados por los clientes).


## 4. Catálogo de requisitos

Mapa de historias de usuario → Matriz o esquema que agrupa las necesidades de los usuarios

Requisitos de información → Mínimo 6, Datos que tiene que almacenar el sistema.

Reglas de negocio → Mínimo 5, Restricciones y condiciones lógicas que deben cumplirse en la base de datos, “No puede alquilar un menor”.

Requisitos funcionales → Mínimo 10, Consultas que el sistema deberá poder responder más adelante mediante consultas SQL.

Requisitos no funcionales → Criterios técnicos de rendimiento, seguridad, almacenamiento “Tiempo de respuestas menores a x segundos”

Pruebas de aceptación de negocio → Escenarios para verificar que todo funciona correctamente y que se cumplen las reglas de negocio.


### 4.1. Requisitos funcionales

#### R.F.01. Título requisito funcional

Como [tipo de usuario]
quiero [servicio]
para [razón]

**Prueba de aceptación**
- Descripción de la primera comprobación a realizar
- Descripción de la segunda comprobación a realizar
- Se debe aplicar la regla de negocio R.N.XX.
- ...

#### 4.1.1. Requisitos de información

##### R.I.01. Título requisito de información

Como [tipo de usuario]
quiero [servicio]
para [razón]

**Prueba de aceptación**
- Descripción de la primera comprobación a realizar
- Descripción de la segunda comprobación a realizar
- ...

#### 4.1.2. Reglas de negocio

##### R.N.01. Título regla negocio

Descripción de la regla de negocio.

### 4.2. Mapa de historias de usuario (opcional)

### 4.3. Requisitos no funcionales (opcional)

**R.N.F. 01. Título requisito no funcional**
Como [tipo de usuario]
quiero [servicio]
para [razón]



