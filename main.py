import psycopg2
import random
from datetime import timedelta, datetime
import string
from faker import Faker

conn = psycopg2.connect(
    database="postgres",
    user="postgres",
    password="Ut3c0128",
    host="localhost",
    port="5432",
    options="-c search_path=proyecto_10k"
    )

cursor = conn.cursor()

conn.autocommit = True


# Generar datos generales
# Para generar telefonos
def generar_telefono():
    telefono = "9"  # Empieza con el dígito 9
    # Genera los siguientes 8 dígitos de manera aleatoria
    for _ in range(8):
        telefono += str(random.randint(0, 9))
    return telefono

# Generar placa
def generar_placa():
    letras = ''.join(random.choices(string.ascii_uppercase, k=3))  # Genera tres letras aleatorias
    numeros = ''.join(random.choices(string.digits, k=3))  # Genera tres números aleatorios
    placa = f"{letras}-{numeros}"  # Combina letras y números con un guion o separador deseado
    return placa

# Generar fecha
def generar_fecha():
    # Definir el rango de fechas
    fecha_inicio = datetime(2019, 1, 1).date()  # Fecha de inicio
    fecha_fin = datetime(2023, 12, 31).date()  # Fecha final

    # Generar una fecha aleatoria dentro del rango
    diferencia = fecha_fin - fecha_inicio
    dias_totales = diferencia.days
    dias_aleatorios = random.randint(0, dias_totales)
    fecha_generada = fecha_inicio + timedelta(days=dias_aleatorios)
    return fecha_generada

# Generar fecha y hora
def generar_fecha_hora_aleatoria():
    # Definir el rango de fechas (por ejemplo, desde el 1 de enero de 1970 hasta la fecha actual)
    fecha_inicio = datetime(2019, 1, 1)
    fecha_actual = datetime.now()
    diferencia = fecha_actual - fecha_inicio
    segundos_totales = int(diferencia.total_seconds())

    # Generar un número aleatorio de segundos dentro del rango
    segundos_aleatorios = random.randint(0, segundos_totales)

    # Crear la fecha y hora aleatoria sumando los segundos aleatorios al inicio del timestamp
    fecha_hora_aleatoria = fecha_inicio + timedelta(seconds=segundos_aleatorios)

    return fecha_hora_aleatoria

# Generar direccion
def generar_direccion_random():
    fake = Faker()
    direccion = fake.address()  # Generar dirección aleatoria
    # Asegurarse de que la dirección generada no supere los 300 caracteres
    if len(direccion) > 300:
        direccion = direccion[:300]  # Truncar la dirección a 300 caracteres
    return direccion

# Para poblar tablas fijas
# Generar turnos de los vendedores
def check_existing_turno(dni, dia):
    cursor.execute(f"SELECT COUNT(*) FROM Turno WHERE DNI='{dni}' AND día='{dia}';")
    count = cursor.fetchone()[0]
    return count > 0


def generate_turno(n):
    days_of_week = ['L', 'M', 'X', 'J', 'V', 'S', 'D']
    i = 0
    cursor.execute("SELECT dni FROM Vendedor;")
    personas = cursor.fetchall()
    while i < n:
        try:
            dni = random.choice(personas)[0]
            dia = random.choice(days_of_week)
            if not check_existing_turno(dni, dia):
                hora_inicio = timedelta(hours=random.randint(9, 12), minutes=random.randint(0, 59))
                # Definir el límite de tiempo para que no exceda las 20:00
                max_time = timedelta(hours=20, minutes=0)
                remaining_time = max_time - hora_inicio
                # Asegurar que el número de horas generadas no exceda el tiempo restante
                num_horas = min(remaining_time.seconds // 3600, 11)
                cursor.execute(
                    f"INSERT INTO Turno(DNI, día, hora_inicio, num_horas) VALUES ('{dni}', '{dia}', '{hora_inicio}', {num_horas});")
                print("Successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar Stock
def generate_stock(n):
    i = 0
    cursor.execute("SELECT modelo, color, talla, precio FROM calzado;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT num_stand, centro_comercial FROM tienda;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            fk = random.choice(res1)
            fk2 = random.choice(res2)
            cantidad = random.randint(2, 8)
            cursor.execute(f"SELECT modelo_c, color_c, talla_c, precio_c, num_stand_t,centro_comercial_t  FROM Stock WHERE modelo_c='{fk[0]}' AND color_c='{fk[1]}' AND talla_c='{fk[2]}' AND num_stand_t='{fk2[0]}' AND centro_comercial_t='{fk2[1]}' AND precio_c={fk[3]}")
            if not cursor.fetchone():
                cursor.execute(f"INSERT INTO Stock(modelo_c, color_c, talla_c, precio_c, num_stand_t,centro_comercial_t, cantidad) VALUES ('{fk[0]}', '{fk[1]}', '{fk[2]}',{fk[3]}, '{fk2[0]}', '{fk2[1]}', {cantidad})")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Para poblar tablas dinámicas
# Generar CLientes
def check_existing_cliente(dni):
    cursor.execute(f"SELECT COUNT(*) FROM Cliente WHERE DNI='{dni}'")
    count = cursor.fetchone()[0]
    return count > 0

def generate_cliente(n):
    i = 0
    cursor.execute("SELECT dni FROM Persona;")
    personas = cursor.fetchall()
    while i < n:
        try:
            dni = random.choice(personas)[0]
            if not check_existing_cliente(dni):
                cursor.execute(
                    f"INSERT INTO Cliente(DNI) VALUES ('{dni}');")
                print("Successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar Repartidores
def generate_repartidor(n):
    i = 0
    cursor.execute("SELECT dni FROM persona;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT ruc FROM empresa;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            dni = random.choice(res1)[0]
            ruc = random.choice(res2)[0]
            calificacion = random.randint(3, 5)
            telefono = generar_telefono()
            placa= generar_placa()
            cursor.execute(f"SELECT dni  FROM Repartidor WHERE dni='{dni}'")
            if not cursor.fetchone():
                cursor.execute(f"INSERT INTO Repartidor(dni, calificación, teléfono, placa_vehículo, ruc) VALUES ('{dni}', '{calificacion}', '{telefono}', '{placa}', '{ruc}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar Orden de compra
def generate_odc(n):
    i = 0
    cursor.execute("SELECT num_stand, centro_comercial FROM tienda;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT ruc FROM empresa;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            codigo= i
            fk = random.choice(res1)
            ruc= random.choice(res2)[0]
            fecha= generar_fecha()
            cursor.execute(f"SELECT código  FROM OrdenDeCompra WHERE código={codigo}")
            if not cursor.fetchone():
                cursor.execute(f"INSERT INTO OrdenDeCompra(código, ruc, num_stand, centro_comercial, fecha) VALUES ({codigo}, '{ruc}', '{fk[0]}', '{fk[1]}', '{fecha}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar Comprobante de Pago
def generate_cdp(n):
    i = 0
    while i < n:
        try:
            codigo= i
            cursor.execute(f"SELECT código  FROM ComprobanteDePago WHERE código={codigo}")
            if not cursor.fetchone():
                cursor.execute(f"INSERT INTO ComprobanteDePago(código) VALUES ({codigo})")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar Venta
def generate_venta(n):
    i = 0
    cursor.execute("SELECT código FROM comprobantedepago;")
    res1 = cursor.fetchall()
    while i < n:
        try:
            codigo= i
            codigocp= res1[i][0]
            fecha_hora= generar_fecha_hora_aleatoria()
            total= 0
            estado= 'no pagado'
            cursor.execute(f"SELECT código  FROM Venta WHERE código={codigo}")
            if not cursor.fetchone():
                cursor.execute(f"INSERT INTO Venta(código, código_cp, fecha_y_hora, total, estado) VALUES ({codigo}, {codigocp}, '{fecha_hora}', {total}, '{estado}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar Venta Virtual
def generate_ventavirtual(n):
    i = 0
    cursor.execute("SELECT código FROM venta;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT dni FROM repartidor;")
    res3 = cursor.fetchall()
    while i < n:
        try:
            codigo = random.choice(res1)[0]
            direccion= generar_direccion_random()
            fecha= generar_fecha_hora_aleatoria()
            costo= random.randint(5, 10)
            dni= random.choice(res3)[0]
            cursor.execute(f"SELECT código FROM ventavirtual WHERE código={codigo}")
            venta_virtual_existente = cursor.fetchone()
            if not venta_virtual_existente:
                cursor.execute(
                    f"INSERT INTO VentaVirtual(código, dirección_destino, fecha_y_hora_destino, costo_envío, dni_rep) VALUES ({codigo}, '{direccion}', '{fecha}', {costo}, '{dni}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar Venta Presencial
def generate_ventap(n):
    i = 0
    cursor.execute("SELECT código FROM venta;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT número, num_stand, centro_comercial FROM caja;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            codigo = random.choice(res1)[0]
            fk = random.choice(res2)
            cursor.execute(f"SELECT código FROM VentaPresencial WHERE código={codigo}")
            venta_presencial_existente = cursor.fetchone()

            # Verificar si el código generado para la venta presencial ya existe en la tabla ventavirtual
            cursor.execute(f"SELECT código FROM ventavirtual WHERE código={codigo}")
            venta_virtual_existente = cursor.fetchone()

            # Si el código generado para la venta presencial no existe en la tabla ventavirtual, insertarlo
            if not venta_presencial_existente and not venta_virtual_existente:
                cursor.execute(
                    f"INSERT INTO VentaPresencial(código, caja_número, num_stand, centro_comercial) VALUES ({codigo}, {fk[0]}, '{fk[1]}', '{fk[2]}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar abastecimiento
def generate_abastecimiento(n):
    i = 0
    cursor.execute("SELECT modelo, color, talla, precio FROM calzado;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT código FROM ordendecompra;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            codigo= random.choice(res2)[0]
            fk = random.choice(res1)
            cantidad = random.randint(2, 8)
            cursor.execute(f"SELECT código_oc, modelo_c, color_c, talla_c, precio_c  FROM Abastecimiento WHERE código_oc= {codigo} AND modelo_c='{fk[0]}' AND precio_c={fk[3]} AND color_c='{fk[1]}' AND talla_c='{fk[2]}'")
            if not cursor.fetchone():
                cursor.execute(f"INSERT INTO Abastecimiento(código_oc, modelo_c, color_c, talla_c, precio_c, cantidad) VALUES ({codigo},'{fk[0]}', '{fk[1]}', '{fk[2]}', {fk[3]}, '{cantidad}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar VentaEP
def generate_ventaep(n):
    i = 0
    cursor.execute("SELECT código FROM ventapresencial;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT ruc FROM empresa;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            codigo = random.choice(res1)[0]
            ruc = random.choice(res2)[0]
            cursor.execute(f"SELECT código_v FROM ventaep WHERE código_v={codigo}")
            venta_epresencial_existente = cursor.fetchone()
            cursor.execute(f"SELECT código_v FROM ventap WHERE código_v={codigo}")
            venta_p_existente = cursor.fetchone()
            if not venta_epresencial_existente and not venta_p_existente:
                cursor.execute(
                    f"INSERT INTO VentaEP(código_v,  ruc) VALUES ({codigo}, '{ruc}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar VentaP
def generate_ventapr(n):
    i = 0
    cursor.execute("SELECT código FROM ventapresencial;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT dni FROM cliente;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            codigo = random.choice(res1)[0]
            dni = random.choice(res2)[0]
            cursor.execute(f"SELECT código_v FROM ventaep WHERE código_v={codigo}")
            venta_epresencial_existente = cursor.fetchone()
            cursor.execute(f"SELECT código_v FROM ventap WHERE código_v={codigo}")
            venta_p_existente = cursor.fetchone()
            if not venta_epresencial_existente and not venta_p_existente:
                cursor.execute(
                    f"INSERT INTO VentaP(código_v,  dni) VALUES ({codigo}, '{dni}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar VentaV
def generate_ventav(n):
    i = 0
    cursor.execute("SELECT código FROM ventavirtual;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT dni FROM cliente;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            codigo = random.choice(res1)[0]
            dni = random.choice(res2)[0]
            cursor.execute(f"SELECT código_vv FROM ventav WHERE código_vv={codigo}")
            venta_v_existente = cursor.fetchone()

            if not venta_v_existente:
                cursor.execute(
                    f"INSERT INTO VentaV(código_vv,  dni) VALUES ({codigo}, '{dni}')")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar ItemVendido
def generate_ItemVendido(n):
    i = 0
    cursor.execute("SELECT modelo, color, talla, precio FROM calzado;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT código FROM venta;")
    res2 = cursor.fetchall()
    while i < n:
        try:
            codigo = random.choice(res2)[0]
            fk = random.choice(res1)
            cantidad= random.randint(1, 8)
            subtotal= (fk[3]) * cantidad
            cursor.execute(f"SELECT modelo_c, color_c, talla_c, precio_c, código_v FROM ItemVendido WHERE código_v={codigo} AND modelo_c='{fk[0]}' AND color_c='{fk[1]}' AND talla_c='{fk[2]}' AND precio_c={fk[3]}")
            venta_v_existente = cursor.fetchone()

            if not venta_v_existente:
                cursor.execute(
                    f"INSERT INTO ItemVendido(modelo_c, color_c, talla_c, precio_c, código_v, cantidad, subtotal) VALUES ('{fk[0]}', '{fk[1]}', '{fk[2]}', {fk[3]}, {codigo}, {cantidad}, {subtotal})")
                print("successfully inserted", i)
                i += 1
        except Exception as e:
            print(e, i)

# Generar Pago
def generate_pago(n):
    i = 0
    cursor.execute("SELECT código, total FROM venta;")
    res1 = cursor.fetchall()
    cursor.execute("SELECT dni FROM vendedor;")
    res2 = cursor.fetchall()
    metodo_pago = ['Yape', 'Plin', 'Visa', 'MasterCard', 'Efectivo']
    while i < n:
        try:
            venta = random.choice(res1)
            codigo_venta = venta[0]
            total_venta = venta[1]

            cursor.execute(f"SELECT SUM(monto) FROM Pago WHERE código={codigo_venta};")
            total_pagado = cursor.fetchone()[0] or 0  # Si no hay registros en la suma, se toma como 0
            if total_pagado < total_venta:
                metodo = random.choice(metodo_pago)
                dni = random.choice(res2)[0]
                monto = min(total_venta - total_pagado,
                            total_venta // 2)  # Se limita el monto a la mitad del total o lo que falta por pagar
                cursor.execute(
                    f"INSERT INTO Pago(código, método_pago, dni, monto) VALUES ({codigo_venta}, '{metodo}', '{dni}', {monto})")
                print("Successfully inserted payment for sale:", codigo_venta)
                i += 1
            else:
                continue
            if i == n:
                break

        except Exception as e:
            print(e, i)
