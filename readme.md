### Archivos

#### console.sql

En este archivo está el código para crear las tablas, keys, constraints y triggers. A la vez, los datos de las tablas fijas.


#### main.py


En este archivo está el código en Python para generar data que contiene +1 llave fóranea y no se pudo generar con DBeaver.


##### - Código por añadir


En el archivo main.py se debe llamar a las funciones para generar la data. Este es el orden en el que se deben de llamar a estas.

```python
# ejemplo para 1M de datos.
n=1000000

# tablas fijas
generate_turno(48)
generate_stock(2600)

# tablas dinámicas
generate_cliente(n)
generate_repartidor(200000)
generate_odc(n)
generate_cdp(n)
generate_venta(n)
generate_ventavirtual(190000)
generate_ventap(810000)
generate_abastecimiento(n)
generate_ventaep(20000)
generate_ventapr(790000)
generate_ventav(190000)
generate_ItemVendido(n)
generate_pago(1200000)
```
#### consultas.sql

Las consultas que se ejecutarán en los 4 esquemas.

### Observaciones
Las tablas Persona y Empresa son las únicas que son creadas en DBeaver.

