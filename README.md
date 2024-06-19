# Lab 2: Construye tu VPC y Lanza un Servidor Web

## Descripción y objetivos del laboratorio

En este laboratorio, usarás Amazon Virtual Private Cloud (VPC) para crear tu propia VPC y añadir componentes adicionales para producir una red personalizada. También crearás un grupo de seguridad. Luego, configurarás y personalizarás una instancia EC2 para ejecutar un servidor web y lanzarás la instancia EC2 para que funcione en una subred en la VPC.

Amazon Virtual Private Cloud (Amazon VPC) te permite lanzar recursos de Amazon Web Services (AWS) en una red virtual que tú defines. Esta red virtual se asemeja mucho a una red tradicional que operarías en tu propio centro de datos, con los beneficios de usar la infraestructura escalable de AWS. Puedes crear una VPC que abarque múltiples Zonas de Disponibilidad.

Después de completar este laboratorio, deberías poder:

- Crear una VPC.
- Crear subredes.
- Configurar un grupo de seguridad.
- Lanzar una instancia EC2 en una VPC.

### Duración

Este laboratorio toma aproximadamente 30 minutos para completarse.

### Restricciones del servicio AWS

En este entorno de laboratorio, el acceso a los servicios y acciones de AWS podría estar restringido a los necesarios para completar las instrucciones del laboratorio. Podrías encontrar errores si intentas acceder a otros servicios o realizar acciones más allá de las descritas en este laboratorio.

### Escenario

En este laboratorio, construirás la siguiente infraestructura:

![Arquitectura](enlace_a_diagrama)

## Pasos del laboratorio

### Acceder a la Consola de Administración de AWS

1. En la parte superior de estas instrucciones, elige **Start Lab** (Iniciar laboratorio).
2. La sesión del laboratorio se inicia. 
3. Un temporizador se muestra en la parte superior de la página indicando el tiempo restante de la sesión.
   
   **Consejo**: Para refrescar la duración de la sesión en cualquier momento, elige **Start Lab** nuevamente antes de que el temporizador llegue a 0:00.

4. Antes de continuar, espera hasta que el ícono de círculo a la derecha del enlace de AWS en la esquina superior izquierda se vuelva verde.
5. Para conectarte a la Consola de Administración de AWS, elige el enlace de AWS en la esquina superior izquierda. Se abrirá una nueva pestaña del navegador y se conectará a la consola.
   
   **Consejo**: Si no se abre una nueva pestaña del navegador, suele haber un banner o ícono en la parte superior de tu navegador con el mensaje de que tu navegador está evitando que el sitio abra ventanas emergentes. Elige el banner o ícono y luego elige **Permitir ventanas emergentes**.

6. Arregla la pestaña de la Consola de Administración de AWS para que se muestre junto a estas instrucciones. Idealmente, podrás ver ambas pestañas del navegador al mismo tiempo para facilitar el seguimiento de los pasos del laboratorio.

### Obtener crédito por tu trabajo

Al final de este laboratorio, se te indicará que envíes el laboratorio para recibir una puntuación basada en tu progreso.

**Consejo**: El script que verifica tu trabajo puede solo otorgar puntos si nombras recursos y configuras valores exactamente como se especifica. En particular, los valores en estas instrucciones que aparecen en **Este Formato** deben ser ingresados exactamente como se documenta (sensible a mayúsculas).

### Tarea 1: Crear tu VPC

En esta tarea, usarás la opción "VPC and more" en la consola de VPC para crear múltiples recursos, incluyendo una VPC, una puerta de enlace a Internet, una subred pública y una subred privada en una sola Zona de Disponibilidad, dos tablas de rutas y una puerta de enlace NAT.

1. En el cuadro de búsqueda a la derecha de **Services** (Servicios), busca y elige **VPC** para abrir la consola de VPC.
2. Comienza a crear una VPC.
   - En la parte superior derecha de la pantalla, verifica que la región sea **N. Virginia (us-east-1)**.
   - Elige el enlace del **VPC Dashboard** (Tablero de VPC) que está hacia la parte superior izquierda de la consola.
   - Luego, elige **Create VPC** (Crear VPC). 
     > Nota: Si no ves un botón con ese nombre, elige el botón **Launch VPC Wizard** (Iniciar asistente de VPC).
3. Configura los detalles de la VPC en el panel de configuración de VPC a la izquierda:
   - Elige **VPC and more** (VPC y más).
   - Bajo **Name tag auto-generation** (Generación automática de etiqueta de nombre), mantén seleccionado **Auto-generate**, pero cambia el valor de **project** a **lab**.
   - Mantén el **IPv4 CIDR block** (bloque CIDR IPv4) en `10.0.0.0/16`.
   - Para **Number of Availability Zones** (Número de Zonas de Disponibilidad), elige `1`.
   - Para **Number of public subnets** (Número de subredes públicas), mantén `1`.
   - Para **Number of private subnets** (Número de subredes privadas), mantén `1`.
   - Expande la sección **Customize subnets CIDR blocks** (Personalizar bloques CIDR de subredes).
     - Cambia el **Public subnet CIDR block in us-east-1a** a `10.0.0.0/24`.
     - Cambia el **Private subnet CIDR block in us-east-1a** a `10.0.1.0/24`.
   - Configura **NAT gateways** a `In 1 AZ`.
   - Configura **VPC endpoints** a `None`.
   - Mantén ambos **DNS hostnames** y **DNS resolution** habilitados.
4. En el panel de vista previa a la derecha, confirma los ajustes que has configurado:
   - **VPC**: `lab-vpc`
   - **Subnets**:
     - `us-east-1a`
       - **Public subnet name**: `lab-subnet-public1-us-east-1a`
       - **Private subnet name**: `lab-subnet-private1-us-east-1a`
   - **Route tables**:
     - `lab-rtb-public`
     - `lab-rtb-private1-us-east-1a`
   - **Network connections**:
     - `lab-igw`
     - `lab-nat-public1-us-east-1a`
5. En la parte inferior de la pantalla, elige **Create VPC** (Crear VPC).
6. Los recursos de la VPC se crearán. La puerta de enlace NAT tomará unos minutos para activarse. Por favor, espera hasta que todos los recursos estén creados antes de proceder al siguiente paso.
7. Una vez completado, elige **View VPC** (Ver VPC).
   - El asistente ha aprovisionado una VPC con una subred pública y una subred privada en una Zona de Disponibilidad con tablas de rutas para cada subred. También creó una puerta de enlace a Internet y una puerta de enlace NAT.
   - Para ver la configuración de estos recursos, navega por los enlaces de la consola de VPC que muestran los detalles de los recursos. Por ejemplo, elige **Subnets** (Subredes) para ver los detalles de la subred y elige **Route tables** (Tablas de rutas) para ver los detalles de la tabla de rutas. El diagrama a continuación resume los recursos de la VPC que acabas de crear y cómo están configurados.

### Tarea 2: Crear Subredes Adicionales

En esta tarea, crearás dos subredes adicionales para la VPC en una segunda Zona de Disponibilidad. Tener subredes en múltiples Zonas de Disponibilidad dentro de una VPC es útil para implementar soluciones que proporcionen Alta Disponibilidad.

1. En el panel de navegación izquierdo, elige **Subnets** (Subredes).
2. Primero, crearás una segunda subred pública.
   - Elige **Create subnet** (Crear subred) y configura:
     - **VPC ID**: `lab-vpc` (selecciona del menú).
     - **Subnet name** (Nombre de subred): `lab-subnet-public2`
     - **Availability Zone** (Zona de disponibilidad): selecciona la segunda Zona de Disponibilidad (por ejemplo, `us-east-1b`).
     - **IPv4 CIDR block** (Bloque CIDR IPv4): `10.0.2.0/24`.
3. Elige **Create subnet** (Crear subred).
   - La segunda subred pública fue creada. Ahora crearás una segunda subred privada.
4. Elige **Create subnet** (Crear subred) y configura:
   - **VPC ID**: `lab-vpc`.
   - **Subnet name** (Nombre de subred): `lab-subnet-private2`.
   - **Availability Zone** (Zona de disponibilidad): selecciona la segunda Zona de Disponibilidad (por ejemplo, `us-east-1b`).
   - **IPv4 CIDR block** (Bloque CIDR IPv4): `10.0.3.0/24`.
5. Elige **Create subnet** (Crear subred).
   - La segunda subred privada fue creada.
6. Ahora, configurarás esta nueva subred privada para enrutar el tráfico con destino a Internet a la puerta de enlace NAT para que los recursos en la segunda subred privada puedan conectarse a

 Internet, manteniendo los recursos privados. Esto se hace configurando una Tabla de Rutas.
   - En el panel de navegación izquierdo, elige **Route tables** (Tablas de rutas).
   - Selecciona la tabla de rutas `lab-rtb-private1-us-east-1a`.
     - En el panel inferior, elige la pestaña **Routes** (Rutas).
     - Nota que el Destino `0.0.0.0/0` está configurado a `Target nat-xxxxxxxx`. Esto significa que el tráfico destinado a Internet (0.0.0.0/0) será enviado a la puerta de enlace NAT. La puerta de enlace NAT luego enviará el tráfico a Internet.
     - Esta tabla de rutas se está usando para enrutar el tráfico desde subredes privadas.
   - Elige la pestaña **Subnet associations** (Asociaciones de subred).
   - Creaste esta tabla de rutas en la tarea 1 cuando elegiste crear una VPC y múltiples recursos en la VPC. Esa acción también creó `lab-subnet-private-1` y asoció esa subred con esta tabla de rutas.
   - Ahora que has creado otra subred privada, `lab-subnet-private-2`, asociarás esta tabla de rutas con esa subred también.
   - En el panel de **Explicit subnet associations** (Asociaciones explícitas de subredes), elige **Edit subnet associations** (Editar asociaciones de subredes).
     - Deja seleccionada `lab-subnet-private1-us-east-1a`, pero también selecciona `lab-subnet-private2`.
   - Elige **Save associations** (Guardar asociaciones).
   - Ahora configurarás la Tabla de Rutas que se usa por las Subredes Públicas.
     - Selecciona la tabla de rutas `lab-rtb-public` (y deselecciona cualquier otra subred).
     - En el panel inferior, elige la pestaña **Routes** (Rutas).
     - Nota que el Destino `0.0.0.0/0` está configurado a `Target igw-xxxxxxxx`, que es una puerta de enlace a Internet. Esto significa que el tráfico con destino a Internet será enviado directamente a Internet a través de esta puerta de enlace a Internet.
     - Ahora asociarás esta tabla de rutas a la segunda subred pública que creaste.
   - Elige la pestaña **Subnet associations** (Asociaciones de subred).
   - En el área de **Explicit subnet associations** (Asociaciones explícitas de subredes), elige **Edit subnet associations** (Editar asociaciones de subredes).
     - Deja seleccionada `lab-subnet-public1-us-east-1a`, pero también selecciona `lab-subnet-public2`.
   - Elige **Save associations** (Guardar asociaciones).

Tu VPC ahora tiene subredes públicas y privadas configuradas en dos Zonas de Disponibilidad. Las tablas de rutas que creaste en la tarea 1 también se han actualizado para enrutar el tráfico de red para las dos nuevas subredes.

### Tarea 3: Crear un Grupo de Seguridad de la VPC

En esta tarea, crearás un grupo de seguridad de la VPC, que actúa como un firewall virtual. Cuando lanzas una instancia, asocias uno o más grupos de seguridad con la instancia. Puedes agregar reglas a cada grupo de seguridad que permitan tráfico hacia o desde sus instancias asociadas.

1. En el panel de navegación izquierdo, elige **Security groups** (Grupos de seguridad).
2. Elige **Create security group** (Crear grupo de seguridad) y luego configura:
   - **Security group name** (Nombre del grupo de seguridad): `Web Security Group`.
   - **Description** (Descripción): `Enable HTTP access` (Habilitar acceso HTTP).
   - **VPC**: elige la `X` para eliminar la VPC actualmente seleccionada, luego elige `lab-vpc` del menú desplegable.
3. En el panel **Inbound rules** (Reglas de entrada), elige **Add rule** (Agregar regla).
4. Configura los siguientes ajustes:
   - **Type** (Tipo): `HTTP`.
   - **Source** (Origen): `Anywhere-IPv4`.
   - **Description** (Descripción): `Permit web requests` (Permitir solicitudes web).
5. Desplázate hasta la parte inferior de la página y elige **Create security group** (Crear grupo de seguridad).

Usarás este grupo de seguridad en la siguiente tarea al lanzar una instancia de Amazon EC2.

### Tarea 4: Lanzar una Instancia de Servidor Web

En esta tarea, lanzarás una instancia de Amazon EC2 en la nueva VPC que creaste y configurarás un servidor web en ella.

1. En la Consola de Administración de AWS, en el cuadro de búsqueda a la derecha de **Services** (Servicios), busca y elige **EC2** para abrir la consola de Amazon EC2.
2. En el panel de navegación izquierdo, elige **Instances** (Instancias) y luego elige **Launch instances** (Lanzar instancias).

#### Paso 1: Elegir una AMI (Imagen de Máquina de Amazon)
3. Selecciona **Amazon Linux 2 AMI (HVM), SSD Volume Type**.
   - Asegúrate de elegir la opción gratuita (Free tier eligible).

#### Paso 2: Elegir un tipo de instancia
4. Elige el tipo de instancia `t2.micro`.
   - Este tipo de instancia es elegible para el nivel gratuito.

#### Paso 3: Configurar los detalles de la instancia
5. Configura los siguientes detalles:
   - **Network**: selecciona `lab-vpc`.
   - **Subnet**: selecciona `lab-subnet-public1-us-east-1a`.
   - **Auto-assign Public IP**: selecciona `Enable` (Habilitar).
   - **IAM role**: deja el valor predeterminado (sin rol).
6. Desplázate hacia abajo y expande la sección **Advanced Details** (Detalles avanzados).
   - En el cuadro **User data** (Datos de usuario), ingresa el siguiente script para instalar y configurar el servidor web Apache al iniciarse la instancia:
     ```bash
     #!/bin/bash
     yum update -y
     yum install -y httpd
     systemctl start httpd
     systemctl enable httpd
     echo "<html><h1>Bienvenido a mi servidor web</h1></html>" > /var/www/html/index.html
     ```

#### Paso 4: Añadir almacenamiento
7. Mantén los valores predeterminados en la sección de almacenamiento.

#### Paso 5: Añadir etiquetas
8. Agrega una etiqueta:
   - **Key**: `Name`
   - **Value**: `Web Server`

#### Paso 6: Configurar un grupo de seguridad
9. Selecciona la opción **Select an existing security group** (Seleccionar un grupo de seguridad existente).
   - Marca la casilla junto a `Web Security Group`.

#### Paso 7: Revisar y lanzar
10. Revisa los detalles de la instancia y luego elige **Launch** (Lanzar).
11. Aparecerá un cuadro de diálogo para seleccionar un par de claves. Selecciona una de las siguientes opciones:
    - **Choose an existing key pair** (Elegir un par de claves existente) si ya tienes uno.
    - **Create a new key pair** (Crear un nuevo par de claves) si necesitas crear uno.
    - **Proceed without a key pair** (Continuar sin un par de claves) si no necesitas acceso SSH a la instancia.
12. Acepta la casilla de verificación y elige **Launch instances** (Lanzar instancias).

### Tarea 5: Verificar el Servidor Web

1. Una vez que la instancia esté en estado `running` (ejecutándose), selecciona la instancia en la consola de EC2.
2. En la parte inferior, copia la **Public IPv4 address** (Dirección IPv4 pública) de la instancia.
3. Abre un navegador web y pega la dirección IPv4 pública en la barra de direcciones. Deberías ver una página web con el mensaje "Bienvenido a mi servidor web".

### Tarea 6: Limpiar los Recursos

Para evitar cargos innecesarios, es importante limpiar los recursos creados después de completar el laboratorio.

1. En la consola de Amazon EC2, selecciona la instancia lanzada.
2. Elige **Actions** (Acciones) > **Instance state** (Estado de la instancia) > **Terminate** (Terminar).
3. En la consola de VPC, elimina los subrecursos (subredes, tablas de rutas, puerta de enlace NAT) y finalmente la VPC creada.

---

¡Felicidades! Has completado el laboratorio y ahora tienes experiencia en la creación de una VPC personalizada, el lanzamiento de una instancia EC2, y la configuración de un servidor web en AWS.
