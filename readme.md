### Archivos

#### console.sql

En este archivo están las querys para crear las tablas, keys, constraints y triggers. A la vez, los datos de las tablas fijas.


#### main.py


En este archivo está el código en Python para generar data que contiene +1 llave fóranea y no se pudo generar con DBeaver.


##### Código por añadir


En el archivo main.py se debe llamar a las funciones para generar la data. Este es el orden en el que se deben de llamar a estas.

```python
# ejemplo para 1M de datos.
n=1000000

# tablas fijas
generate_turno(48)
generate_stock(2600)

# tablas dinámicas
generate_cliente(n)
generate_repartidor(2000)
generate_odc(n)
generate_cdp(n)
generate_venta(n)
# antes hacer la inserccion de venta virtual en DBeaver.
generate_ventap(8100)
generate_abastecimiento(n)
generate_ventaep(200)
generate_ventapr(7900)
generate_ventav(1900)
generate_ItemVendido(n)
generate_pago(12000)
```


### Observaciones


Las tablas Persona, Empresa y VentaPresencial son las únicas que son creadas en DBeaver.

