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
CREATE INDEX idx_VentaPresencial_compuesto ON VentaPresencial USING hash(caja_número);
CREATE INDEX idx_VentaPresencial_num_stand ON VentaPresencial USING hash(num_stand);
CREATE INDEX idx_VentaPresencial_centro_comercial ON VentaPresencial USING hash(centro_comercial);
CREATE INDEX idx_Caja_compuesto ON Caja USING hash(número);
CREATE INDEX idx_Caja_num_stand ON Caja USING hash(num_stand);
CREATE INDEX idx_Caja_centro_comercial ON Caja USING hash(centro_comercial);

-- Consulta 4
-- Índices
CREATE INDEX idx_Stock_compuesto ON Stock USING hash(modelo_c, color_c, talla_c);
CREATE INDEX idx_Abastecimiento_modelo_c ON Abastecimiento USING hash(modelo_c);
CREATE INDEX idx_Abastecimiento_color_c ON Abastecimiento USING hash(color_c);
CREATE INDEX idx_Abastecimiento_talla_c ON Abastecimiento USING hash(talla_c);
CREATE INDEX idx_ItemVendido_modelo_c ON ItemVendido USING hash(modelo_c);
CREATE INDEX idx_ItemVendido_color_c ON ItemVendido USING hash(color_c);
CREATE INDEX idxItemVendido_talla_c ON ItemVendido USING hash(talla_c);
