# Proyecto Personal para visualizar Rentabilidad de Cartera
Este proyecto lo realicé para satisfacer una necesidad personal. Hace 2 años comencé a invertir en bolsa a traves de 
Degiro. A pesar de poder ver la rentabilidad acumulada de la cartera, no podía consultar la evolución de dicha rentabilidad.

El objetivo de este programa es, dada una serie de compras/ventas, crear un gráfico que muestre la evolución de la rentabilidad de la cartera.
Las fechas de inicio/fin del gráfico son modificables.

> [!NOTE]  
> La rentabilidad es calculada sobre el capital total, invertido o no.

Estructura de la carpeta Rentabilidad_Acumulada_Cartera_Inversion
- database.py: fichero con funciones para manejar la base de datos
- finance.py: funciones para calcular las rentabilidades
- data.db: fichero de base de datos, se crea la primera vez desde settings.py
- settings.py: ajustes básicos como fecha de inicio y fin o estructura de la cartera
- main.py: creará el gráfico
> [!WARNING]  
> Antes de ejecutar main.py ejecutar settings.py, modificando a mano settings deseadas y acciones de la cartera como se indica en el fichero.
