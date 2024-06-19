
Este proyecto de Terraform despliega una infraestructura en AWS que incluye una VPC con subredes públicas y privadas, tablas de rutas, un NAT Gateway, un grupo de seguridad y una instancia EC2 configurada como servidor web.

#### Estructura de Archivos

- **main.tf**: Este archivo contiene la configuración principal de Terraform. Define los recursos de AWS necesarios para esta infraestructura, como la VPC, subredes, internet gateway, NAT gateway, tablas de rutas, asociaciones de tablas de rutas, grupos de seguridad y la instancia EC2.

- **variables.tf**: Este archivo define las variables usadas en la configuración de Terraform. Facilita la modificación de parámetros como la región de AWS y el nombre del par de claves sin cambiar directamente el código en `main.tf`.

- **terraform.tfvars**: Este archivo opcional contiene los valores de las variables definidas en `variables.tf`. Aquí se especifican las configuraciones sensibles o específicas del entorno, como la región de AWS y el nombre del par de claves.

- **outputs.tf**: Este archivo define las salidas de Terraform, que son valores devueltos después de aplicar la configuración. En este caso, proporciona el ID de la VPC, los IDs de las subredes públicas y privadas, y la dirección IP pública y DNS público de la instancia EC2.

#### Pasos para Desplegar la Infraestructura

1. **Instalar Terraform**:
   - Asegúrate de tener Terraform instalado en tu máquina. Puedes descargarlo desde la página oficial de [Terraform](https://www.terraform.io/downloads.html) e instalarlo siguiendo las instrucciones para tu sistema operativo.

2. **Configurar AWS CLI**:
   - Configura tus credenciales de AWS usando la AWS CLI. Ejecuta `aws configure` y proporciona tus credenciales de acceso, la región por defecto y el formato de salida.

3. **Preparar el Directorio de Trabajo**:
   - Crea un directorio para tu proyecto y navega dentro de él.
   - Coloca los archivos `main.tf`, `variables.tf`, `terraform.tfvars` y `outputs.tf` en este directorio.

4. **Inicializar el Directorio de Terraform**:
   - Abre una terminal en el directorio del proyecto y ejecuta:
     ```sh
     terraform init
     ```
   - Este comando descarga los plugins necesarios para interactuar con los proveedores de infraestructura definidos en tu configuración (en este caso, AWS).

5. **Previsualizar los Cambios del Plan**:
   - Ejecuta el siguiente comando para ver el plan de ejecución de Terraform:
     ```sh
     terraform plan
     ```
   - Este comando genera un plan de ejecución, mostrando los recursos que se crearán, cambiarán o destruirán.

6. **Aplicar el Plan para Crear los Recursos**:
   - Ejecuta el siguiente comando para aplicar el plan y desplegar la infraestructura en AWS:
     ```sh
     terraform apply
     ```
   - Terraform te pedirá confirmación para proceder. Escribe `yes` y presiona Enter.
   - Terraform comenzará a crear los recursos definidos en los archivos de configuración. Este proceso puede tardar unos minutos.

7. **Verificar las Salidas**:
   - Una vez que Terraform complete la ejecución, mostrará los valores de las salidas definidas en `outputs.tf`. Puedes ver el ID de la VPC, los IDs de las subredes y la dirección IP pública y DNS público de la instancia EC2.

8. **Acceder al Servidor Web**:
   - Copia el valor del DNS público de la instancia EC2 mostrado en las salidas de Terraform.
   - Abre un navegador web y pega el DNS público en la barra de direcciones. Deberías ver una página web mostrando el logo de AWS y los valores de meta-datos de la instancia, confirmando que el servidor web está funcionando correctamente.

Con estos pasos, habrás desplegado exitosamente una infraestructura de AWS utilizando Terraform, incluyendo una VPC, subredes, tablas de rutas, un NAT Gateway, un grupo de seguridad y una instancia EC2 configurada como servidor web.
