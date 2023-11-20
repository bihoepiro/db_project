-- Consulta 1
-- Índices
CREATE INDEX idx_venta_fecha_hora_btree ON venta USING btree(fecha_y_hora);
CREATE INDEX idx_itemvendido_codigo_v ON ItemVendido USING btree(código_v);
CREATE INDEX idx_itemvendido_modelo_color ON ItemVendido USING btree(modelo_c, color_c);
CREATE INDEX idx_ventap_codigo ON ventapresencial USING hash(código);
CREATE INDEX idx_ventav_codigo ON ventavirtual USING hash(código);

-- Consulta 2
-- Índices
CREATE INDEX idx_VentaVirtual_dni_rep ON VentaVirtual USING hash(dni_rep);
CREATE INDEX idx_Repartidor_dni ON Repartidor USING hash(dni);
CREATE INDEX idx_Empresa_ruc ON Empresa USING btree(ruc);

-- Consulta 3
-- Índices
-- Índice en Pago(código)
CREATE INDEX idx_Pago_codigo ON Pago USING hash(código);
CREATE INDEX idx_VentaPresencial_compuesto ON VentaPresencial USING hash(caja_número, num_stand, centro_comercial);
CREATE INDEX idx_Caja_compuesto ON Caja USING hash(número, num_stand, centro_comercial);

-- Consulta 4
-- Índices
CREATE INDEX idx_Stock_compuesto ON Stock USING hash(modelo_c, color_c, talla_c);
CREATE INDEX idx_Abastecimiento_compuesto ON Abastecimiento USING hash(modelo_c, color_c, talla_c);
CREATE INDEX idx_ItemVendido_compuesto ON ItemVendido USING hash(modelo_c, color_c, talla_c);
