### Guía Detallada para Construir tu VPC y Lanzar un Servidor Web en AWS Management Console

#### Inicio de la Sesión del Laboratorio
1. **Iniciar el laboratorio**: En la parte superior de las instrucciones, selecciona "Start Lab".
2. **Esperar a que inicie la sesión**: Aparecerá un temporizador en la parte superior de la página indicando el tiempo restante de la sesión.
   - **Consejo**: Para refrescar la duración de la sesión en cualquier momento, selecciona "Start Lab" nuevamente antes de que el temporizador llegue a 0:00.
3. **Verificación de conexión a AWS**: Espera hasta que el icono circular a la derecha del enlace de AWS en la esquina superior izquierda se vuelva verde.
4. **Conectar a AWS Management Console**: Selecciona el enlace de AWS en la esquina superior izquierda. Se abrirá una nueva pestaña del navegador conectándote a la consola.
   - **Consejo**: Si no se abre una nueva pestaña, asegúrate de permitir las ventanas emergentes en tu navegador.
5. **Organizar las pestañas**: Coloca la pestaña de AWS Management Console junto a las instrucciones para facilitar el seguimiento de los pasos.

#### Tarea 1: Crear tu VPC
1. **Abrir la consola de VPC**: En el cuadro de búsqueda a la derecha de "Services", busca y selecciona "VPC".
2. **Verificar la región**: En la parte superior derecha de la pantalla, asegúrate de que la región seleccionada sea N. Virginia (us-east-1).
3. **Crear VPC**:
   - Selecciona el enlace "VPC dashboard" hacia la parte superior izquierda de la consola.
   - Elige "Create VPC" (si no ves esta opción, selecciona "Launch VPC Wizard").
4. **Configurar detalles de la VPC**:
   - Selecciona "VPC and more".
   - Mantén "Auto-generate" seleccionado bajo "Name tag auto-generation" y cambia el valor a "lab".
   - Mantén el bloque CIDR IPv4 en 10.0.0.0/16.
   - Para "Number of Availability Zones", selecciona 1.
   - Mantén 1 para "Number of public subnets" y "Number of private subnets".
   - Expande "Customize subnets CIDR blocks":
     - Cambia el bloque CIDR de la subred pública en us-east-1a a 10.0.0.0/24.
     - Cambia el bloque CIDR de la subred privada en us-east-1a a 10.0.1.0/24.
   - Establece "NAT gateways" en "In 1 AZ".
   - Mantén "VPC endpoints" en "None".
   - Asegúrate de que ambos "DNS hostnames" y "DNS resolution" estén habilitados.
5. **Confirmar y crear VPC**:
   - Verifica las configuraciones en el panel de vista previa:
     - VPC: lab-vpc
     - Subnets:
       - Public subnet name: lab-subnet-public1-us-east-1a
       - Private subnet name: lab-subnet-private1-us-east-1a
     - Route tables:
       - lab-rtb-public
       - lab-rtb-private1-us-east-1a
     - Network connections:
       - lab-igw
       - lab-nat-public1-us-east-1a
   - Selecciona "Create VPC".
   - Espera a que todos los recursos se creen antes de proceder al siguiente paso.
6. **Ver y revisar VPC**:
   - Una vez completado, selecciona "View VPC".
   - Revisa los detalles de los recursos navegando por los enlaces de la consola VPC.

#### Tarea 2: Crear Subredes Adicionales
1. **Abrir la sección de Subnets**: En el panel de navegación izquierdo, selecciona "Subnets".
2. **Crear una segunda subred pública**:
   - Selecciona "Create subnet".
   - Configura:
     - VPC ID: lab-vpc.
     - Subnet name: lab-subnet-public2.
     - Availability Zone: selecciona la segunda zona (por ejemplo, us-east-1b).
     - IPv4 CIDR block: 10.0.2.0/24.
   - Selecciona "Create subnet".
3. **Crear una segunda subred privada**:
   - Selecciona "Create subnet".
   - Configura:
     - VPC ID: lab-vpc.
     - Subnet name: lab-subnet-private2.
     - Availability Zone: selecciona la segunda zona (por ejemplo, us-east-1b).
     - IPv4 CIDR block: 10.0.3.0/24.
   - Selecciona "Create subnet".
4. **Configurar tablas de rutas**:
   - Selecciona "Route tables" en el panel de navegación izquierdo.
   - Configurar lab-rtb-private1-us-east-1a:
     - Selecciona "lab-rtb-private1-us-east-1a".
     - En la pestaña "Routes", asegúrate que el destino 0.0.0.0/0 esté dirigido al NAT Gateway.
     - En la pestaña "Subnet associations", selecciona "Edit subnet associations" y agrega "lab-subnet-private2".
     - Selecciona "Save associations".
   - Configurar lab-rtb-public:
     - Selecciona "lab-rtb-public".
     - En la pestaña "Routes", verifica que el destino 0.0.0.0/0 esté dirigido al Internet Gateway.
     - En la pestaña "Subnet associations", selecciona "Edit subnet associations" y agrega "lab-subnet-public2".
     - Selecciona "Save associations".

#### Tarea 3: Crear un Grupo de Seguridad de VPC
1. **Abrir la sección de Security groups**: En el panel de navegación izquierdo, selecciona "Security groups".
2. **Crear un grupo de seguridad**:
   - Selecciona "Create security group".
   - Configura:
     - Security group name: Web Security Group.
     - Description: Enable HTTP access.
     - VPC: selecciona el VPC lab-vpc.
   - Agregar reglas de entrada:
     - Selecciona "Add rule".
     - Configura:
       - Type: HTTP.
       - Source: Anywhere-IPv4.
       - Description: Permit web requests.
   - Selecciona "Create security group".

#### Tarea 4: Lanzar una Instancia de Servidor Web
1. **Abrir la consola de EC2**: En el cuadro de búsqueda a la derecha de "Services", busca y selecciona "EC2".
2. **Lanzar una nueva instancia**:
   - Selecciona "Launch instance".
   - Configurar la instancia:
     - Name: Web Server 1.
     - AMI: Mantén la Amazon Linux 2023 AMI predeterminada.
     - Instance type: Mantén t2.micro.
     - Key pair: Selecciona "vockey".
     - Network settings:
       - Network: lab-vpc.
       - Subnet: lab-subnet-public2.
       - Auto-assign public IP: Enable.
     - Security group: Selecciona "Web Security Group".
     - Storage: Mantén las configuraciones predeterminadas (8 GiB gp3).
     - User data script:
       - En la sección "Advanced details", copia y pega el siguiente script en el cuadro de "User data":
```bash
#!/bin/bash
# Install Apache Web Server and PHP
dnf install -y httpd wget php mariadb105-server
# Download Lab files
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-ACCLFO-2/2-lab2-vpc/s3/lab-app.zip
unzip lab-app.zip -d /var/www/html/
# Turn on web server
chkconfig httpd on
service httpd start
```
3. **Lanzar la instancia**: Selecciona "Launch instance".
   - Verifica que la instancia haya sido creada exitosamente.
4. **Conectar al servidor web**:
   - Espera hasta que "Web Server 1" muestre "2/2 checks passed" en la columna de estado.
   - Selecciona "Web Server 1".
   - Copia el valor del "Public IPv4 DNS" y pégalo en una nueva pestaña del navegador.

#### Tarea Adicional: Crear Instancias EC2 para Verificar las Redes
1. **Crear instancia en subred pública**:
   - Repite los pasos de la Tarea 4, pero selecciona la subred "lab-subnet-public1".
2. **Crear instancia en subred privada**:
   - Repite los pasos de la Tarea 4, pero selecciona la subred "lab-subnet-private1".
   - Asegúrate de que la instancia tenga una ruta hacia el NAT Gateway para verificar la conectividad.

#### Resumen de la Arquitectura Implementada
La arquitectura completa incluye:
- Una VPC con subredes públicas y privadas en dos zonas de disponibilidad.
- Un Internet Gateway asociado a las subredes públicas.
- Un NAT Gateway para proporcionar conectividad a las subredes privadas.
- Instancias EC2 en ambas subredes para verificar la conectividad.

Siguiendo estos pasos detallados, habrás creado una infraestructura robusta en AWS que incluye una VPC con alta disponibilidad y un servidor web funcional.
