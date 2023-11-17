-------- De acuerdo al esquema --------
SET SCHEMA 'proyecto_1m';

-------- Tablas -------

CREATE TABLE Persona(
    DNI varchar(8),
    nombre_completo varchar(50),
    fecha_nacimiento date
);

CREATE TABLE Tienda(
    num_stand varchar(4),
    centro_comercial varchar(30),
    teléfono varchar(9),
    aforo varchar(3)
);

CREATE TABLE Vendedor(
    DNI varchar(8),
    sueldo smallint,
    num_stand varchar(4),
    centro_comercial varchar(30)
);

CREATE TABLE Cliente(
    DNI varchar(8)
);

CREATE TABLE Empresa(
    RUC varchar(11),
    nombre varchar(30),
    dirección varchar(300),
    teléfono varchar(9)
);

CREATE TABLE Repartidor(
    DNI varchar(8),
    calificación DOUBLE PRECISION,
    teléfono varchar(9),
    placa_vehículo varchar(7),
    RUC varchar(11)
);

CREATE TABLE Turno(
    DNI varchar(8),
    día varchar (1),
    hora_inicio time,
    num_horas smallint
);

CREATE TABLE Calzado(
    modelo varchar(4),
    color varchar(10),
    talla varchar(2),
    precio smallint
);

CREATE TABLE OrdenDeCompra(
    código integer,
    RUC varchar(11),
    num_stand varchar(4),
    centro_comercial varchar(30),
    fecha date
);

CREATE TABLE Caja(
    número smallint,
    num_stand varchar(4),
    centro_comercial varchar(30)
);

CREATE TABLE ComprobanteDePago(
    código integer
);

CREATE TABLE Venta(
    código integer,
    código_cp integer,
    fecha_y_hora timestamp,
    total smallint,
    estado varchar(20)
);

CREATE TABLE VentaVirtual(
    código integer,
    dirección_destino varchar(300),
    fecha_y_hora_destino timestamp,
    costo_envío smallint,
    dni_rep varchar(8)
);

CREATE TABLE VentaPresencial(
    código integer,
    caja_número smallint,
    num_stand varchar(4),
    centro_comercial varchar(30)
);

CREATE TABLE Pago(
    código integer,
    método_pago varchar(10),
    DNI varchar(8),
    monto smallint
);

CREATE TABLE Stock(
    modelo_c varchar(4),
    color_c varchar(10),
    talla_c varchar(2),
    precio_c smallint,
    num_stand_t varchar(4),
    centro_comercial_t varchar(30),
    cantidad integer
);

CREATE TABLE Abastecimiento(
    código_oc integer,
    modelo_c varchar(4),
    color_c varchar(10),
    talla_c varchar(2),
    precio_c smallint,
    cantidad integer
);

CREATE TABLE VentaEP(
    código_v integer,
    RUC varchar(11)
);

CREATE TABLE VentaP(
    código_v integer,
    DNI varchar(8)
);

CREATE TABLE VentaV(
    código_vv integer,
    DNI varchar(8)
);

CREATE TABLE ItemVendido(
    modelo_c varchar(4),
    color_c varchar(10),
    talla_c varchar(2),
    precio_c smallint,
    código_v integer,
    cantidad integer,
    subtotal smallint
);

-------- Key Constraints -------

ALTER TABLE Persona ADD CONSTRAINT persona_pk PRIMARY KEY (DNI);

ALTER TABLE Tienda ADD CONSTRAINT tienda_pk PRIMARY KEY (num_stand, centro_comercial);

ALTER TABLE Vendedor ADD CONSTRAINT vendedor_pk PRIMARY KEY (DNI);
ALTER TABLE Vendedor ADD CONSTRAINT vendedor_fk FOREIGN KEY (DNI) REFERENCES Persona(DNI);
ALTER TABLE Vendedor ADD CONSTRAINT vendedor_fk_ns FOREIGN KEY (num_stand, centro_comercial) REFERENCES Tienda(num_stand, centro_comercial);

ALTER TABLE Cliente ADD CONSTRAINT cliente_pk PRIMARY KEY (DNI);
ALTER TABLE Cliente ADD CONSTRAINT cliente_fk FOREIGN KEY (DNI) REFERENCES Persona(DNI);

ALTER TABLE Empresa ADD CONSTRAINT empresa_pk PRIMARY KEY (RUC);

ALTER TABLE Repartidor ADD CONSTRAINT repartidor_pk PRIMARY KEY (DNI);
ALTER TABLE Repartidor ADD CONSTRAINT repartidor_fk_p FOREIGN KEY (DNI) REFERENCES Persona(DNI);
ALTER TABLE Repartidor ADD CONSTRAINT repartidor_fk_e FOREIGN KEY (RUC) REFERENCES Empresa(RUC);

ALTER TABLE Turno ADD CONSTRAINT turno_pk PRIMARY KEY (DNI, día);
ALTER TABLE Turno ADD CONSTRAINT turno_fk FOREIGN KEY (DNI) REFERENCES Persona(DNI);

ALTER TABLE Calzado ADD CONSTRAINT calzado_pk PRIMARY KEY (modelo, color, talla, precio);

ALTER TABLE OrdenDeCompra ADD CONSTRAINT odc_pk PRIMARY KEY (código);
ALTER TABLE OrdenDeCompra ADD CONSTRAINT odc_fk_e FOREIGN KEY (RUC) REFERENCES Empresa(RUC);
ALTER TABLE OrdenDeCompra ADD CONSTRAINT odc_fk_tn FOREIGN KEY (num_stand, centro_comercial) REFERENCES Tienda(num_stand, centro_comercial);

ALTER TABLE Caja ADD CONSTRAINT caja_pk PRIMARY KEY (número, num_stand, centro_comercial);
ALTER TABLE Caja ADD CONSTRAINT caja_fk_tn FOREIGN KEY (num_stand, centro_comercial) REFERENCES Tienda(num_stand, centro_comercial);

ALTER TABLE ComprobanteDePago ADD CONSTRAINT cdp_pk PRIMARY KEY (código);

ALTER TABLE Venta ADD CONSTRAINT venta_pk PRIMARY KEY (código);
ALTER TABLE Venta ADD CONSTRAINT venta_fk FOREIGN KEY (código_cp) REFERENCES ComprobanteDePago(código);

ALTER TABLE VentaVirtual ADD CONSTRAINT venta_virtual_pk PRIMARY KEY (código);
ALTER TABLE VentaVirtual ADD CONSTRAINT venta_virtual_fk FOREIGN KEY (código) REFERENCES Venta(código);
ALTER TABLE VentaVirtual ADD CONSTRAINT venta_virtual_fk_r FOREIGN KEY (dni_rep) REFERENCES Repartidor(dni);

ALTER TABLE VentaPresencial ADD CONSTRAINT venta_presencial_pk PRIMARY KEY (código);
ALTER TABLE VentaPresencial ADD CONSTRAINT venta_presencial_fk FOREIGN KEY (código) REFERENCES Venta(código);
ALTER TABLE VentaPresencial ADD CONSTRAINT venta_presencial_tn FOREIGN KEY (caja_número, num_stand, centro_comercial) REFERENCES Caja(número, num_stand, centro_comercial);

ALTER TABLE Pago ADD CONSTRAINT pago_pk PRIMARY KEY (código, método_pago);
ALTER TABLE Pago ADD CONSTRAINT pago_fk_cp FOREIGN KEY (código) REFERENCES Venta(código);
ALTER TABLE Pago ADD CONSTRAINT pago_fk_v FOREIGN KEY (DNI) REFERENCES Vendedor(DNI);

ALTER TABLE Stock ADD CONSTRAINT stock_pk PRIMARY KEY (modelo_c, color_c, talla_c, precio_c, num_stand_t, centro_comercial_t);
ALTER TABLE Stock ADD CONSTRAINT stock_fk_m FOREIGN KEY (modelo_c, color_c, talla_c, precio_c) REFERENCES  Calzado(modelo, color, talla, precio);
ALTER TABLE Stock ADD CONSTRAINT stock_fk_n FOREIGN KEY (num_stand_t, centro_comercial_t) REFERENCES  Tienda(num_stand, centro_comercial);

ALTER TABLE Abastecimiento ADD CONSTRAINT abastecimiento_pk PRIMARY KEY (modelo_c, color_c, talla_c, precio_c, código_oc);
ALTER TABLE Abastecimiento ADD CONSTRAINT abastecimiento_fk_coc FOREIGN KEY (código_oc) REFERENCES  OrdenDeCompra(código);
ALTER TABLE Abastecimiento ADD CONSTRAINT abastecimiento_fk_c FOREIGN KEY (modelo_c, color_c, talla_c, precio_c) REFERENCES  Calzado(modelo, color, talla, precio);

ALTER TABLE VentaEP ADD CONSTRAINT ventaep_pk PRIMARY KEY (código_v);
ALTER TABLE VentaEP ADD CONSTRAINT ventaep_fk_c FOREIGN KEY (código_v) REFERENCES VentaPresencial(código);
ALTER TABLE VentaEP ADD CONSTRAINT ventaep_fk_r FOREIGN KEY (RUC) REFERENCES Empresa(RUC);

ALTER TABLE VentaP ADD CONSTRAINT ventap_pk PRIMARY KEY (código_v);
ALTER TABLE VentaP ADD CONSTRAINT ventap_fk_c FOREIGN KEY (código_v) REFERENCES VentaPresencial(código);
ALTER TABLE VentaP ADD CONSTRAINT ventap_fk_d FOREIGN KEY (DNI) REFERENCES Cliente(DNI);

ALTER TABLE VentaV ADD CONSTRAINT ventav_pk PRIMARY KEY (código_vv);
ALTER TABLE VentaV ADD CONSTRAINT ventav_fk_c FOREIGN KEY (código_vv) REFERENCES VentaVirtual(código);
ALTER TABLE VentaV ADD CONSTRAINT ventav_fk_d FOREIGN KEY (DNI) REFERENCES Cliente(DNI);

ALTER TABLE ItemVendido ADD CONSTRAINT iv_pk PRIMARY KEY (modelo_c, color_c, talla_c, código_v, precio_c);
ALTER TABLE ItemVendido ADD CONSTRAINT iv_fk_m FOREIGN KEY (modelo_c, color_c, talla_c, precio_c) REFERENCES  Calzado(modelo, color, talla, precio);
ALTER TABLE ItemVendido ADD CONSTRAINT iv_fk_cv FOREIGN KEY (código_v) REFERENCES  Venta(código);

-------- Not Null Constraints -------

ALTER TABLE Persona ALTER COLUMN nombre_completo SET NOT NULL;

ALTER TABLE Vendedor ALTER COLUMN sueldo SET NOT NULL;

ALTER TABLE Repartidor ALTER COLUMN teléfono SET NOT NULL;
ALTER TABLE Repartidor ALTER COLUMN placa_vehículo SET NOT NULL;
ALTER TABLE Repartidor ALTER COLUMN RUC SET NOT NULL;

ALTER TABLE Turno ALTER COLUMN hora_inicio SET NOT NULL;
ALTER TABLE Turno ALTER COLUMN num_horas SET NOT NULL;

ALTER TABLE Tienda ALTER COLUMN teléfono SET NOT NULL;

ALTER TABLE Calzado ALTER COLUMN precio SET NOT NULL;

ALTER TABLE OrdenDeCompra ALTER COLUMN fecha SET NOT NULL;

ALTER TABLE Empresa ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE Empresa ALTER COLUMN teléfono SET NOT NULL;

ALTER TABLE Venta ALTER COLUMN código_cp SET NOT NULL;
ALTER TABLE Venta ALTER COLUMN fecha_y_hora SET NOT NULL;
ALTER TABLE Venta ALTER COLUMN total SET NOT NULL;

ALTER TABLE VentaVirtual ALTER COLUMN fecha_y_hora_destino SET NOT NULL;
ALTER TABLE VentaVirtual ALTER COLUMN dirección_destino SET NOT NULL;
ALTER TABLE VentaVirtual ALTER COLUMN costo_envío SET NOT NULL;

ALTER TABLE VentaPresencial ALTER COLUMN num_stand SET NOT NULL;
ALTER TABLE VentaPresencial ALTER COLUMN centro_comercial SET NOT NULL;

ALTER TABLE Pago ALTER COLUMN monto SET NOT NULL;

ALTER TABLE Stock ALTER COLUMN cantidad SET NOT NULL;

ALTER TABLE Abastecimiento ALTER COLUMN cantidad SET NOT NULL;

ALTER TABLE ItemVendido ALTER COLUMN cantidad SET NOT NULL;
ALTER TABLE ItemVendido ALTER COLUMN subtotal SET NOT NULL;

-------- Otros Constraints -------

ALTER TABLE Repartidor ADD CONSTRAINT calificacion_permitida CHECK (calificación>=3);
ALTER TABLE Repartidor ADD CONSTRAINT check_tel_r CHECK (teléfono ~ '^9');

ALTER TABLE Turno ADD CONSTRAINT check_día CHECK (día IN ('L', 'M', 'X', 'J', 'V', 'S', 'D'));
ALTER TABLE Turno ADD CONSTRAINT check_nh CHECK (num_horas<=10);

ALTER TABLE Tienda ADD CONSTRAINT check_tel_t CHECK (teléfono ~ '^9');

ALTER TABLE Calzado ADD CONSTRAINT check_precio CHECK (precio>0);

ALTER TABLE Empresa ADD CONSTRAINT check_tel_e CHECK (teléfono ~ '^9');

ALTER TABLE VentaVirtual ADD CONSTRAINT check_costo CHECK (costo_envío>0);

ALTER TABLE Pago ADD CONSTRAINT check_mp CHECK (método_pago IN ( 'Yape' , 'Plin' , 'Visa' , 'MasterCard' , 'Efectivo') ) ;

ALTER TABLE Stock ADD CONSTRAINT check_cantidad_s CHECK (cantidad>0);

ALTER TABLE Abastecimiento ADD CONSTRAINT check_cantidad_a CHECK (cantidad>0);

ALTER TABLE ItemVendido ADD CONSTRAINT check_cantidad_iv CHECK (cantidad>0);

-------- Triggers -------

CREATE OR REPLACE FUNCTION actualizar_total_venta()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Venta
    SET total = total + (
        SELECT SUM(subtotal)
        FROM ItemVendido
        WHERE código_v = NEW.código_v
    )
    WHERE código = NEW.código_v;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER after_insert_itemvendido
AFTER INSERT ON ItemVendido
FOR EACH ROW
EXECUTE FUNCTION actualizar_total_venta();


CREATE OR REPLACE FUNCTION validar_monto_pago()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.monto > (SELECT total FROM Venta WHERE código = NEW.código)- (SELECT sum(monto) FROM Pago WHERE código = NEW.código) THEN
        RAISE EXCEPTION 'El monto del pago excede el total de la venta';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_validar_monto_pago
BEFORE INSERT OR UPDATE ON Pago
FOR EACH ROW EXECUTE FUNCTION validar_monto_pago();


CREATE OR REPLACE FUNCTION actualizar_estado_venta() RETURNS TRIGGER AS $$
DECLARE
    total_venta numeric;
    total_pagado numeric;
BEGIN
    SELECT total INTO total_venta FROM Venta WHERE código = NEW.código;
    SELECT COALESCE(SUM(monto), 0) INTO total_pagado FROM Pago WHERE código = NEW.código;
    IF total_pagado = total_venta THEN
        UPDATE Venta SET estado = 'pagado' WHERE código = NEW.código;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER actualizar_estado_despues_pago
AFTER INSERT OR UPDATE ON Pago
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_venta();

-------- Datos proporcionados por la Empresa -------

INSERT INTO Tienda(num_stand, centro_comercial, teléfono, aforo)  VALUES
('107','C.C. CalzaMundo','992155734','15'),
('150','C.C. CalzaMundo','941394761','12'),
('1204','C.C. 5 Continentes','993353765','5'),
('1311','C.C. 5 Continentes','948056414','5');

INSERT INTO Caja(número, num_stand, centro_comercial) VALUES
('1','107','C.C. CalzaMundo'),
('2','107','C.C. CalzaMundo'),
('1','150','C.C. CalzaMundo'),
('2','150','C.C. CalzaMundo'),
('1','1204','C.C. 5 Continentes'),
('2','1204','C.C. 5 Continentes'),
('1','1311','C.C. 5 Continentes'),
('2','1311','C.C. 5 Continentes');

INSERT INTO Calzado(modelo, color, talla, precio) VALUES
('S101', 'marron', '35', 70),
('S101', 'marron', '36', 70),
('S101', 'marron', '37', 70),
('S101', 'marron', '38', 70),
('S101', 'marron', '39', 70),
('S101', 'negro', '35', 70),
('S101', 'negro', '36', 70),
('S101', 'negro', '37', 70),
('S101', 'negro', '38', 70),
('S101', 'negro', '39', 70),
('S101', 'nude', '35', 70),
('S101', 'nude', '36', 70),
('S101', 'nude', '37', 70),
('S101', 'nude', '38', 70),
('S101', 'nude', '39', 70),
('S115', 'oro', '35', 100),
('S115', 'oro', '36', 100),
('S115', 'oro', '37', 100),
('S115', 'oro', '38', 100),
('S115', 'oro', '39', 100),
('S115', 'azul', '35', 100),
('S115', 'azul', '36', 100),
('S115', 'azul', '37', 100),
('S115', 'azul', '38', 100),
('S115', 'azul', '39', 100),
('S134', 'azul', '35', 100),
('S134', 'azul', '36', 100),
('S134', 'azul', '37', 100),
('S134', 'azul', '38', 100),
('S134', 'azul', '39', 100),
('S134', 'negro', '35', 100),
('S134', 'negro', '36', 100),
('S134', 'negro', '37', 100),
('S134', 'negro', '38', 100),
('S134', 'negro', '39', 100),
('S134', 'verde', '35', 100),
('S134', 'verde', '36', 100),
('S134', 'verde', '37', 100),
('S134', 'verde', '38', 100),
('S134', 'verde', '39', 100),
('S200', 'negro', '35', 85),
('S200', 'negro', '36', 85),
('S200', 'negro', '37', 85),
('S200', 'negro', '38', 85),
('S200', 'negro', '39', 85),
('S200', 'beige', '35', 85),
('S200', 'beige', '36', 85),
('S200', 'beige', '37', 85),
('S200', 'beige', '38', 85),
('S200', 'beige', '39', 85),
('S200', 'plata', '35', 85),
('S200', 'plata', '36', 85),
('S200', 'plata', '37', 85),
('S200', 'plata', '38', 85),
('S200', 'plata', '39', 85),
('S200', 'blanco', '35', 85),
('S200', 'blanco', '36', 85),
('S200', 'blanco', '37', 85),
('S200', 'blanco', '38', 85),
('S200', 'blanco', '39', 85),
('S210', 'blanco', '35', 95),
('S210', 'blanco', '36', 95),
('S210', 'blanco', '37', 95),
('S210', 'blanco', '38', 95),
('S210', 'blanco', '39', 95),
('S210', 'negro', '35', 95),
('S210', 'negro', '36', 95),
('S210', 'negro', '37', 95),
('S210', 'negro', '38', 95),
('S210', 'negro', '39', 95),
('S210', 'rojo', '35', 95),
('S210', 'rojo', '36', 95),
('S210', 'rojo', '37', 95),
('S210', 'rojo', '38', 95),
('S210', 'rojo', '39', 95),
('S210', 'nude', '35', 95),
('S210', 'nude', '36', 95),
('S210', 'nude', '37', 95),
('S210', 'nude', '38', 95),
('S210', 'nude', '39', 95),
('S215', 'nude', '35', 95),
('S215', 'nude', '36', 95),
('S215', 'nude', '37', 95),
('S215', 'nude', '38', 95),
('S215', 'nude', '39', 95),
('S215', 'blanco', '35', 95),
('S215', 'blanco', '36', 95),
('S215', 'blanco', '37', 95),
('S215', 'blanco', '38', 95),
('S215', 'blanco', '39', 95),
('S215', 'negro', '35', 95),
('S215', 'negro', '36', 95),
('S215', 'negro', '37', 95),
('S215', 'negro', '38', 95),
('S215', 'negro', '39', 95),
('S215', 'rojo', '35', 95),
('S215', 'rojo', '36', 95),
('S215', 'rojo', '37', 95),
('S215', 'rojo', '38', 95),
('S215', 'rojo', '39', 95),
('S215', 'fucsia', '35', 95),
('S215', 'fucsia', '36', 95),
('S215', 'fucsia', '37', 95),
('S215', 'fucsia', '38', 95),
('S215', 'fucsia', '39', 95),
('B101', 'marron', '35', 180),
('B101', 'marron', '36', 180),
('B101', 'marron', '37', 180),
('B101', 'marron', '38', 180),
('B101', 'marron', '39', 180),
('B101', 'negro', '35', 180),
('B101', 'negro', '36', 180),
('B101', 'negro', '37', 180),
('B101', 'negro', '38', 180),
('B101', 'negro', '39', 180),
('B101', 'natural', '35', 180),
('B101', 'natural', '36', 180),
('B101', 'natural', '37', 180),
('B101', 'natural', '38', 180),
('B101', 'natural', '39', 180),
('B101', 'rojo', '35', 180),
('B101', 'rojo', '36', 180),
('B101', 'rojo', '37', 180),
('B101', 'rojo', '38', 180),
('B101', 'rojo', '39', 180),
('B110', 'negro', '35', 200),
('B110', 'negro', '36', 200),
('B110', 'negro', '37', 200),
('B110', 'negro', '38', 200),
('B110', 'negro', '39', 200),
('B110', 'natural', '35', 200),
('B110', 'natural', '36', 200),
('B110', 'natural', '37', 200),
('B110', 'natural', '38', 200),
('B110', 'natural', '39', 200),
('B120', 'marron', '35', 250),
('B120', 'marron', '36', 250),
('B120', 'marron', '37', 250),
('B120', 'marron', '38', 250),
('B120', 'marron', '39', 250),
('B120', 'negro', '35', 250),
('B120', 'negro', '36', 250),
('B120', 'negro', '37', 250),
('B120', 'negro', '38', 250),
('B120', 'negro', '39', 250),
('B120', 'natural', '35', 250),
('B120', 'natural', '36', 250),
('B120', 'natural', '37', 250),
('B120', 'natural', '38', 250),
('B120', 'natural', '39', 250),
('B200', 'marron', '35', 165),
('B200', 'marron', '36', 165),
('B200', 'marron', '37', 165),
('B200', 'marron', '38', 165),
('B200', 'marron', '39', 165),
('B200', 'negro', '35', 165),
('B200', 'negro', '36', 165),
('B200', 'negro', '37', 165),
('B200', 'negro', '38', 165),
('B200', 'negro', '39', 165),
('B200', 'azul', '35', 165),
('B200', 'azul', '36', 165),
('B200', 'azul', '37', 165),
('B200', 'azul', '38', 165),
('B200', 'azul', '39', 165),
('B200', 'natural', '35', 165),
('B200', 'natural', '36', 165),
('B200', 'natural', '37', 165),
('B200', 'natural', '38', 165),
('B200', 'natural', '39', 165),
('B250', 'marron', '35', 190),
('B250', 'marron', '36', 190),
('B250', 'marron', '37', 190),
('B250', 'marron', '38', 190),
('B250', 'marron', '39', 190),
('B250', 'negro', '35', 190),
('B250', 'negro', '36', 190),
('B250', 'negro', '37', 190),
('B250', 'negro', '38', 190),
('B250', 'negro', '39', 190),
('B250', 'azul', '35', 190),
('B250', 'azul', '36', 190),
('B250', 'azul', '37', 190),
('B250', 'azul', '38', 190),
('B250', 'azul', '39', 190),
('M100', 'marron', '35', 100),
('M100', 'marron', '36', 100),
('M100', 'marron', '37', 100),
('M100', 'marron', '38', 100),
('M100', 'marron', '39', 100),
('M100', 'negro', '35', 100),
('M100', 'negro', '36', 100),
('M100', 'negro', '37', 100),
('M100', 'negro', '38', 100),
('M100', 'negro', '39', 100),
('M100', 'azul', '35', 100),
('M100', 'azul', '36', 100),
('M100', 'azul', '37', 100),
('M100', 'azul', '38', 100),
('M100', 'azul', '39', 100),
('M100', 'rojo', '35', 100),
('M100', 'rojo', '36', 100),
('M100', 'rojo', '37', 100),
('M100', 'rojo', '38', 100),
('M100', 'rojo', '39', 100),
('M100', 'celeste', '35', 100),
('M100', 'celeste', '36', 100),
('M100', 'celeste', '37', 100),
('M100', 'celeste', '38', 100),
('M100', 'celeste', '39', 100),
('M115', 'marron', '35', 100),
('M115', 'marron', '36', 100),
('M115', 'marron', '37', 100),
('M115', 'marron', '38', 100),
('M115', 'marron', '39', 100),
('M115', 'negro', '35', 100),
('M115', 'negro', '36', 100),
('M115', 'negro', '37', 100),
('M115', 'negro', '38', 100),
('M115', 'negro', '39', 100),
('M115', 'fucsia', '35', 100),
('M115', 'fucsia', '36', 100),
('M115', 'fucsia', '37', 100),
('M115', 'fucsia', '38', 100),
('M115', 'fucsia', '39', 100),
('M115', 'verde', '35', 100),
('M115', 'verde', '36', 100),
('M115', 'verde', '37', 100),
('M115', 'verde', '38', 100),
('M115', 'verde', '39', 100),
('M115', 'nude', '35', 100),
('M115', 'nude', '36', 100),
('M115', 'nude', '37', 100),
('M115', 'nude', '38', 100),
('M115', 'nude', '39', 100),
('M150', 'beige', '35', 105),
('M150', 'beige', '36', 105),
('M150', 'beige', '37', 105),
('M150', 'beige', '38', 105),
('M150', 'beige', '39', 105),
('M150', 'negro', '35', 105),
('M150', 'negro', '36', 105),
('M150', 'negro', '37', 105),
('M150', 'negro', '38', 105),
('M150', 'negro', '39', 105),
('M150', 'fucsia', '35', 105),
('M150', 'fucsia', '36', 105),
('M150', 'fucsia', '37', 105),
('M150', 'fucsia', '38', 105),
('M150', 'fucsia', '39', 105),
('M150', 'verde', '35', 105),
('M150', 'verde', '36', 105),
('M150', 'verde', '37', 105),
('M150', 'verde', '38', 105),
('M150', 'verde', '39', 105),
('M150', 'nude', '35', 105),
('M150', 'nude', '36', 105),
('M150', 'nude', '37', 105),
('M150', 'nude', '38', 105),
('M150', 'nude', '39', 105),
('M150', 'plomo', '35', 105),
('M150', 'plomo', '36', 105),
('M150', 'plomo', '37', 105),
('M150', 'plomo', '38', 105),
('M150', 'plomo', '39', 105),
('M200', 'beige', '35', 90),
('M200', 'beige', '36', 90),
('M200', 'beige', '37', 90),
('M200', 'beige', '38', 90),
('M200', 'beige', '39', 90),
('M200', 'negro', '35', 90),
('M200', 'negro', '36', 90),
('M200', 'negro', '37', 90),
('M200', 'negro', '38', 90),
('M200', 'negro', '39', 90),
('M200', 'fucsia', '35', 90),
('M200', 'fucsia', '36', 90),
('M200', 'fucsia', '37', 90),
('M200', 'fucsia', '38', 90),
('M200', 'fucsia', '39', 90),
('M200', 'morado', '35', 90),
('M200', 'morado', '36', 90),
('M200', 'morado', '37', 90),
('M200', 'morado', '38', 90),
('M200', 'morado', '39', 90),
('M200', 'nude', '35', 90),
('M200', 'nude', '36', 90),
('M200', 'nude', '37', 90),
('M200', 'nude', '38', 90),
('M200', 'nude', '39', 90),
('M200', 'plomo', '35', 90),
('M200', 'plomo', '36', 90),
('M200', 'plomo', '37', 90),
('M200', 'plomo', '38', 90),
('M200', 'plomo', '39', 90),
('M200', 'azul', '35', 90),
('M200', 'azul', '36', 90),
('M200', 'azul', '37', 90),
('M200', 'azul', '38', 90),
('M200', 'azul', '39', 90),
('M200', 'blanco', '35', 90),
('M200', 'blanco', '36', 90),
('M200', 'blanco', '37', 90),
('M200', 'blanco', '38', 90),
('M200', 'blanco', '39', 90),
('M210', 'beige', '35', 110),
('M210', 'beige', '36', 110),
('M210', 'beige', '37', 110),
('M210', 'beige', '38', 110),
('M210', 'beige', '39', 110),
('M210', 'negro', '35', 110),
('M210', 'negro', '36', 110),
('M210', 'negro', '37', 110),
('M210', 'negro', '38', 110),
('M210', 'negro', '39', 110),
('M210', 'azul', '35', 110),
('M210', 'azul', '36', 110),
('M210', 'azul', '37', 110),
('M210', 'azul', '38', 110),
('M210', 'azul', '39', 110),
('M210', 'nude', '35', 110),
('M210', 'nude', '36', 110),
('M210', 'nude', '37', 110),
('M210', 'nude', '38', 110),
('M210', 'nude', '39', 110),
('M210', 'plomo', '35', 110),
('M210', 'plomo', '36', 110),
('M210', 'plomo', '37', 110),
('M210', 'plomo', '38', 110),
('M210', 'plomo', '39', 110),
('M210', 'blanco', '35', 110),
('M210', 'blanco', '36', 110),
('M210', 'blanco', '37', 110),
('M210', 'blanco', '38', 110),
('M210', 'blanco', '39', 110),
('V100', 'negro', '35', 120),
('V100', 'negro', '36', 120),
('V100', 'negro', '37', 120),
('V100', 'negro', '38', 120),
('V100', 'negro', '39', 120),
('V100', 'azul', '35', 120),
('V100', 'azul', '36', 120),
('V100', 'azul', '37', 120),
('V100', 'azul', '38', 120),
('V100', 'azul', '39', 120),
('V100', 'nude', '35', 120),
('V100', 'nude', '36', 120),
('V100', 'nude', '37', 120),
('V100', 'nude', '38', 120),
('V100', 'nude', '39', 120),
('V100', 'fucsia', '35', 120),
('V100', 'fucsia', '36', 120),
('V100', 'fucsia', '37', 120),
('V100', 'fucsia', '38', 120),
('V100', 'fucsia', '39', 120),
('V100', 'verde', '35', 120),
('V100', 'verde', '36', 120),
('V100', 'verde', '37', 120),
('V100', 'verde', '38', 120),
('V100', 'verde', '39', 120),
('V100', 'blanco', '35', 120),
('V100', 'blanco', '36', 120),
('V100', 'blanco', '37', 120),
('V100', 'blanco', '38', 120),
('V100', 'blanco', '39', 120),
('V100', 'amarillo', '35', 120),
('V100', 'amarillo', '36', 120),
('V100', 'amarillo', '37', 120),
('V100', 'amarillo', '38', 120),
('V100', 'amarillo', '39', 120),
('V110', 'negro', '35', 120),
('V110', 'negro', '36', 120),
('V110', 'negro', '37', 120),
('V110', 'negro', '38', 120),
('V110', 'negro', '39', 120),
('V110', 'nude', '35', 120),
('V110', 'nude', '36', 120),
('V110', 'nude', '37', 120),
('V110', 'nude', '38', 120),
('V110', 'nude', '39', 120),
('V110', 'blanco', '35', 120),
('V110', 'blanco', '36', 120),
('V110', 'blanco', '37', 120),
('V110', 'blanco', '38', 120),
('V110', 'blanco', '39', 120),
('V120', 'negro', '35', 120),
('V120', 'negro', '36', 120),
('V120', 'negro', '37', 120),
('V120', 'negro', '38', 120),
('V120', 'negro', '39', 120),
('V120', 'nude', '35', 120),
('V120', 'nude', '36', 120),
('V120', 'nude', '37', 120),
('V120', 'nude', '38', 120),
('V120', 'nude', '39', 120),
('V120', 'blanco', '35', 120),
('V120', 'blanco', '36', 120),
('V120', 'blanco', '37', 120),
('V120', 'blanco', '38', 120),
('V120', 'blanco', '39', 120),
('C100', 'negro', '35', 100),
('C100', 'negro', '36', 100),
('C100', 'negro', '37', 100),
('C100', 'negro', '38', 100),
('C100', 'negro', '39', 100),
('C100', 'nude', '35', 100),
('C100', 'nude', '36', 100),
('C100', 'nude', '37', 100),
('C100', 'nude', '38', 100),
('C100', 'nude', '39', 100),
('C100', 'blanco', '35', 100),
('C100', 'blanco', '36', 100),
('C100', 'blanco', '37', 100),
('C100', 'blanco', '38', 100),
('C100', 'blanco', '39', 100),
('C100', 'azul', '35', 100),
('C100', 'azul', '36', 100),
('C100', 'azul', '37', 100),
('C100', 'azul', '38', 100),
('C100', 'azul', '39', 100),
('C110', 'negro', '35', 100),
('C110', 'negro', '36', 100),
('C110', 'negro', '37', 100),
('C110', 'negro', '38', 100),
('C110', 'negro', '39', 100),
('C110', 'nude', '35', 100),
('C110', 'nude', '36', 100),
('C110', 'nude', '37', 100),
('C110', 'nude', '38', 100),
('C110', 'nude', '39', 100),
('C110', 'blanco', '35', 100),
('C110', 'blanco', '36', 100),
('C110', 'blanco', '37', 100),
('C110', 'blanco', '38', 100),
('C110', 'blanco', '39', 100),
('C110', 'azul', '35', 100),
('C110', 'azul', '36', 100),
('C110', 'azul', '37', 100),
('C110', 'azul', '38', 100),
('C110', 'azul', '39', 100),
('C150', 'negro', '35', 100),
('C150', 'negro', '36', 100),
('C150', 'negro', '37', 100),
('C150', 'negro', '38', 100),
('C150', 'negro', '39', 100),
('C150', 'nude', '35', 100),
('C150', 'nude', '36', 100),
('C150', 'nude', '37', 100),
('C150', 'nude', '38', 100),
('C150', 'nude', '39', 100),
('C150', 'blanco', '35', 100),
('C150', 'blanco', '36', 100),
('C150', 'blanco', '37', 100),
('C150', 'blanco', '38', 100),
('C150', 'blanco', '39', 100),
('C150', 'marrón', '35', 100),
('C150', 'marrón', '36', 100),
('C150', 'marrón', '37', 100),
('C150', 'marrón', '38', 100),
('C150', 'marrón', '39', 100),
('C180', 'negro', '35', 100),
('C180', 'negro', '36', 100),
('C180', 'negro', '37', 100),
('C180', 'negro', '38', 100),
('C180', 'negro', '39', 100),
('C180', 'nude', '35', 100),
('C180', 'nude', '36', 100),
('C180', 'nude', '37', 100),
('C180', 'nude', '38', 100),
('C180', 'nude', '39', 100),
('C180', 'blanco', '35', 100),
('C180', 'blanco', '36', 100),
('C180', 'blanco', '37', 100),
('C180', 'blanco', '38', 100),
('C180', 'blanco', '39', 100),
('C180', 'marrón', '35', 100),
('C180', 'marrón', '36', 100),
('C180', 'marrón', '37', 100),
('C180', 'marrón', '38', 100),
('C180', 'marrón', '39', 100),
('C180', 'beige', '35', 100),
('C180', 'beige', '36', 100),
('C180', 'beige', '37', 100),
('C180', 'beige', '38', 100),
('C180', 'beige', '39', 100),
('Z100', 'negro', '35', 130),
('Z100', 'negro', '36', 130),
('Z100', 'negro', '37', 130),
('Z100', 'negro', '38', 130),
('Z100', 'negro', '39', 130),
('Z100', 'blanco', '35', 130),
('Z100', 'blanco', '36', 130),
('Z100', 'blanco', '37', 130),
('Z100', 'blanco', '38', 130),
('Z100', 'blanco', '39', 130),
('Z110', 'negro', '35', 130),
('Z110', 'negro', '36', 130),
('Z110', 'negro', '37', 130),
('Z110', 'negro', '38', 130),
('Z110', 'negro', '39', 130),
('Z110', 'blanco', '35', 130),
('Z110', 'blanco', '36', 130),
('Z110', 'blanco', '37', 130),
('Z110', 'blanco', '38', 130),
('Z110', 'blanco', '39', 130),
('Z150', 'negro', '35', 130),
('Z150', 'negro', '36', 130),
('Z150', 'negro', '37', 130),
('Z150', 'negro', '38', 130),
('Z150', 'negro', '39', 130),
('Z150', 'blanco', '35', 130),
('Z150', 'blanco', '36', 130),
('Z150', 'blanco', '37', 130),
('Z150', 'blanco', '38', 130),
('Z150', 'blanco', '39', 130),
('Z150', 'beige', '35', 130),
('Z150', 'beige', '36', 130),
('Z150', 'beige', '37', 130),
('Z150', 'beige', '38', 130),
('Z150', 'beige', '39', 130),
('Z150', 'plomo', '35', 130),
('Z150', 'plomo', '36', 130),
('Z150', 'plomo', '37', 130),
('Z150', 'plomo', '38', 130),
('Z150', 'plomo', '39', 130),
('Z170', 'negro', '35', 130),
('Z170', 'negro', '36', 130),
('Z170', 'negro', '37', 130),
('Z170', 'negro', '38', 130),
('Z170', 'negro', '39', 130),
('Z170', 'blanco', '35', 130),
('Z170', 'blanco', '36', 130),
('Z170', 'blanco', '37', 130),
('Z170', 'blanco', '38', 130),
('Z170', 'blanco', '39', 130),
('Z180', 'negro', '35', 130),
('Z180', 'negro', '36', 130),
('Z180', 'negro', '37', 130),
('Z180', 'negro', '38', 130),
('Z180', 'negro', '39', 130),
('Z180', 'blanco', '35', 130),
('Z180', 'blanco', '36', 130),
('Z180', 'blanco', '37', 130),
('Z180', 'blanco', '38', 130),
('Z180', 'blanco', '39', 130),
('Z180', 'azul', '35', 130),
('Z180', 'azul', '36', 130),
('Z180', 'azul', '37', 130),
('Z180', 'azul', '38', 130),
('Z180', 'azul', '39', 130),
('Z180', 'nude', '35', 130),
('Z180', 'nude', '36', 130),
('Z180', 'nude', '37', 130),
('Z180', 'nude', '38', 130),
('Z180', 'nude', '39', 130),
('E100', 'negro', '35', 80),
('E100', 'negro', '36', 80),
('E100', 'negro', '37', 80),
('E100', 'negro', '38', 80),
('E100', 'negro', '39', 80),
('E150', 'negro', '35', 80),
('E150', 'negro', '36', 80),
('E150', 'negro', '37', 80),
('E150', 'negro', '38', 80),
('E150', 'negro', '39', 80),
('E160', 'negro', '35', 80),
('E160', 'negro', '36', 80),
('E160', 'negro', '37', 80),
('E160', 'negro', '38', 80),
('E160', 'negro', '39', 80),
('E180', 'negro', '35', 80),
('E180', 'negro', '36', 80),
('E180', 'negro', '37', 80),
('E180', 'negro', '38', 80),
('E180', 'negro', '39', 80),
('P100', 'negro', '35', 100),
('P100', 'negro', '36', 100),
('P100', 'negro', '37', 100),
('P100', 'negro', '38', 100),
('P100', 'negro', '39', 100),
('P100', 'nude', '35', 100),
('P100', 'nude', '36', 100),
('P100', 'nude', '37', 100),
('P100', 'nude', '38', 100),
('P100', 'nude', '39', 100),
('P110', 'negro', '35', 100),
('P110', 'negro', '36', 100),
('P110', 'negro', '37', 100),
('P110', 'negro', '38', 100),
('P110', 'negro', '39', 100),
('P120', 'negro', '35', 100),
('P120', 'negro', '36', 100),
('P120', 'negro', '37', 100),
('P120', 'negro', '38', 100),
('P120', 'negro', '39', 100),
('P120', 'blanco', '35', 100),
('P120', 'blanco', '36', 100),
('P120', 'blanco', '37', 100),
('P120', 'blanco', '38', 100),
('P120', 'blanco', '39', 100),
('P120', 'azul', '35', 100),
('P120', 'azul', '36', 100),
('P120', 'azul', '37', 100),
('P120', 'azul', '38', 100),
('P120', 'azul', '39', 100),
('O100', 'negro', '35', 100),
('O100', 'negro', '36', 100),
('O100', 'negro', '37', 100),
('O100', 'negro', '38', 100),
('O100', 'negro', '39', 100),
('O100', 'nude', '35', 100),
('O100', 'nude', '36', 100),
('O100', 'nude', '37', 100),
('O100', 'nude', '38', 100),
('O100', 'nude', '39', 100),
('O110', 'negro', '35', 100),
('O110', 'negro', '36', 100),
('O110', 'negro', '37', 100),
('O110', 'negro', '38', 100),
('O110', 'negro', '39', 100),
('O120', 'negro', '35', 100),
('O120', 'negro', '36', 100),
('O120', 'negro', '37', 100),
('O120', 'negro', '38', 100),
('O120', 'negro', '39', 100),
('O120', 'nude', '35', 100),
('O120', 'nude', '36', 100),
('O120', 'nude', '37', 100),
('O120', 'nude', '38', 100),
('O120', 'nude', '39', 100),
('O120', 'blanco', '35', 100),
('O120', 'blanco', '36', 100),
('O120', 'blanco', '37', 100),
('O120', 'blanco', '38', 100),
('O120', 'blanco', '39', 100),
('O120', 'fucsia', '35', 100),
('O120', 'fucsia', '36', 100),
('O120', 'fucsia', '37', 100),
('O120', 'fucsia', '38', 100),
('O120', 'fucsia', '39', 100),
('O120', 'verde', '35', 100),
('O120', 'verde', '36', 100),
('O120', 'verde', '37', 100),
('O120', 'verde', '38', 100),
('O120', 'verde', '39', 100),
('O120', 'rojo', '35', 100),
('O120', 'rojo', '36', 100),
('O120', 'rojo', '37', 100),
('O120', 'rojo', '38', 100),
('O120', 'rojo', '39', 100);

INSERT INTO Persona(dni, nombre_completo, fecha_nacimiento) VALUES
('76300128', 'Gabriela Arredondo', '1980-08-11'),
('42420646', 'Yahaira Mollan', '2001-06-16'),
('46792558', 'Beverly Soto', '1993-02-11'),
('68066279', 'Maria Tuesta', '1985-09-18'),
('72965038', 'Ariadna Ramirez', '1995-06-30'),
('78286499', 'Verónica Cruz', '1986-12-16'),
('64732147', 'Sandra Izquierdo', '1999-10-25'),
('87501818', 'Luciana Paitan', '1988-07-22'),
('21763045', 'Andrea Tapia', '1983-02-14'),
('19625051', 'Tania Lopez', '1998-11-11'),
('32441714', 'Sebastian Marquez', '1982-07-02'),
('65038832', 'Cristian Flores', '2005-03-20'),
('74171827', 'Daniel Tijeras', '2000-04-23'),
('33168105', 'Luis Lopez', '1994-02-27'),
('24638831', 'Juana Ruiz', '2004-02-13'),
('65111826', 'Gonzalo Chu', '2000-04-23');

INSERT INTO Vendedor(dni, sueldo, num_stand, centro_comercial) VALUES
('76300128', '2000','107','C.C. CalzaMundo'),
('42420646', '1600','107','C.C. CalzaMundo'),
('46792558', '1400','107','C.C. CalzaMundo'),
('68066279', '1600','107','C.C. CalzaMundo'),
('72965038', '1400','107','C.C. CalzaMundo'),
('78286499', '2000','150','C.C. CalzaMundo'),
('64732147', '1600','150','C.C. CalzaMundo'),
('87501818', '1600','150','C.C. CalzaMundo'),
('21763045', '1400','150','C.C. CalzaMundo'),
('19625051', '1400','150','C.C. CalzaMundo'),
('32441714', '2000','1204','C.C. 5 Continentes'),
('65038832', '1600','1204','C.C. 5 Continentes'),
('74171827', '1400','1204','C.C. 5 Continentes'),
('33168105', '2000','1311','C.C. 5 Continentes'),
('24638831', '1600','1311','C.C. 5 Continentes'),
('65111826', '1400','1311','C.C. 5 Continentes');
