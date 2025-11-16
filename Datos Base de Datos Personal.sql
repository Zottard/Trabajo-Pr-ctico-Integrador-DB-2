USE ViajesTuristicos
GO

INSERT INTO Categorias_Pasajero (nombre, descripcion, edad_minima, edad_maxima, porcentaje_tarifa) VALUES
('Bebé', 'Niños de 0 a 2 años - Viajan gratis', 0, 2, 0.00),
('Menor', 'Niños de 3 a 12 años - 50% de descuento', 3, 12, 0.50),
('Adulto', 'Personas de 13 a 64 años - Tarifa completa', 13, 64, 1.00),
('Jubilado', 'Personas de 65+ años - 30% de descuento', 65, 150, 0.70);
GO

INSERT INTO Metodo_Pago (descripcion, activo) VALUES
('Efectivo', 1),
('Tarjeta de Débito', 1),
('Tarjeta de Crédito', 1),
('Transferencia Bancaria', 1),
('MercadoPago', 1),
('Modo', 1);
GO

INSERT INTO Descuentos (descripcion, porcentaje, fecha_inicio, fecha_fin, activo, tipo) VALUES
('Temporada baja', 0.15, '2025-03-01', '2025-05-31', 1, 'temporal'),
('Temporada alta recargo', 0.10, '2025-12-15', '2026-01-15', 1, 'recargo'),
('Reserva anticipada (30+ días)', 0.10, '2025-01-01', '2025-12-31', 1, 'anticipada'),
('Grupo familiar (4+)', 0.20, NULL, NULL, 1, 'grupal'),
('Grupo escolar (10+)', 0.25, NULL, NULL, 1, 'grupal'),
('Promo cumpleaños mes', 0.15, NULL, NULL, 1, 'especial'),
('Estudiantes con credencial', 0.12, NULL, NULL, 1, 'especial'),
('Residentes de Tigre', 0.18, NULL, NULL, 1, 'especial');
GO

INSERT INTO Destinos (zona, muelle, duracion) VALUES
('Río Santiago', 'Muelle Delta Central', '01:30:00'),
('Tres Bocas', 'Muelle Norte', '02:00:00'),
('Museo Delta', 'Puerto Museo', '01:00:00'),
('Río Luján', 'Embarcadero Sur', '02:30:00'),
('Tigre Centro', 'Puerto Central', '00:45:00'),
('Arroyo Gambado', 'Muelle Este', '01:45:00'),
('Delta Adventure Park', 'Muelle Deportivo', '01:15:00'),
('Río Carapachay', 'Embarcadero Oeste', '02:15:00'),
('Paseo de la Costa', 'Puerto Paseo', '01:00:00'),
('Isla Grande', 'Muelle Isla', '03:00:00');
GO

INSERT INTO Lanchas (matricula, nombre, capacidad) VALUES
('TIG001', 'Delta Star', 20),
('TIG002', 'Río Veloz', 15),
('TIG003', 'Navegante del Sol', 25),
('TIG004', 'Isla Bonita', 18),
('TIG005', 'Puerto Alegre', 22),
('TIG006', 'Viento del Norte', 30),
('TIG007', 'Estrella Marina', 12),
('TIG008', 'Capitán Delta', 28);
GO

INSERT INTO Personas (dni, nombre, apellido, edad, telefono) VALUES
('20345678', 'Juan Carlos', 'Pérez', 35, '1122223333'),
('25456789', 'María Laura', 'Gómez', 32, '1133334444'),
('48567890', 'Pedro', 'Pérez', 8, '1122223333'),
('52678901', 'Sofía', 'Pérez', 1, '1122223333');
GO

INSERT INTO Personas (dni, nombre, apellido, edad, telefono) VALUES
('18789012', 'Carlos Alberto', 'López', 45, '1144445555'),
('22890123', 'Ana María', 'Martínez', 42, '1155556666'),
('46901234', 'Lucas', 'López', 10, '1144445555'),
('49012345', 'Emma', 'López', 6, '1144445555');
GO

INSERT INTO Personas (dni, nombre, apellido, edad, telefono) VALUES
('12123456', 'Roberto', 'Fernández', 68, '1166667777'),
('10234567', 'Marta', 'González', 72, '1177778888'),
('11345678', 'Alberto', 'Rodríguez', 70, '1188889999');
GO

INSERT INTO Personas (dni, nombre, apellido, edad, telefono) VALUES
('30456789', 'Laura', 'Sánchez', 28, '1199990000'),
('32567890', 'Diego', 'Ramírez', 23, '1100001111'),
('35678901', 'Sofía', 'Torres', 30, '1111112222'),
('33789012', 'Martín', 'Silva', 26, '1122223333');
GO

INSERT INTO Personas (dni, nombre, apellido, edad, telefono) VALUES
('28890123', 'Patricia', 'Morales', 40, '1133334444'), 
('47901234', 'Agustín', 'Benítez', 10, '1144445555'),
('48012345', 'Valentina', 'Castro', 11, '1155556666'),
('46123456', 'Mateo', 'Díaz', 12, '1166667777'),
('47234567', 'Catalina', 'Espinoza', 10, '1177778888'),
('48345678', 'Joaquín', 'Flores', 11, '1188889999'),
('47456789', 'Martina', 'García', 12, '1199990000'),
('46567890', 'Benjamín', 'Herrera', 10, '1100001111'),
('48678901', 'Isabella', 'Iglesias', 11, '1111112222'),
('47789012', 'Santiago', 'Jiménez', 12, '1122223333'),
('46890123', 'Emilia', 'Kovacs', 10, '1133334444'),
('48901234', 'Thiago', 'Luna', 11, '1144445555'),
('47012345', 'Renata', 'Méndez', 12, '1155556666');
GO

INSERT INTO Personas (dni, nombre, apellido, edad, telefono) VALUES
('22222222', 'Jorge Luis', 'Silva', 40, '1198765432'),
('33333333', 'Martín', 'Torres Castro', 35, '1187654321'),
('44444444', 'Federico', 'Castro', 38, '1176543210'),
('55555555', 'Ricardo', 'Moreno', 42, '1165432109'),
('66666666', 'Pablo', 'Ruiz', 36, '1154321098');
GO

INSERT INTO Licencias (dni, fecha_emision, fecha_caducidad) VALUES
('22222222', '2023-01-15', '2028-01-15'),
('33333333', '2022-06-20', '2027-06-20'),
('44444444', '2024-03-10', '2029-03-10'),
('55555555', '2023-09-05', '2028-09-05'),
('66666666', '2024-07-18', '2029-07-18');
GO

INSERT INTO Conductor (id_persona, estado, id_licencia) VALUES
((SELECT id FROM Personas WHERE dni = '22222222'), 1, (SELECT id FROM Licencias WHERE dni = '22222222')),
((SELECT id FROM Personas WHERE dni = '33333333'), 1, (SELECT id FROM Licencias WHERE dni = '33333333')),
((SELECT id FROM Personas WHERE dni = '44444444'), 1, (SELECT id FROM Licencias WHERE dni = '44444444')),
((SELECT id FROM Personas WHERE dni = '55555555'), 1, (SELECT id FROM Licencias WHERE dni = '55555555')),
((SELECT id FROM Personas WHERE dni = '66666666'), 1, (SELECT id FROM Licencias WHERE dni = '66666666'));
GO

INSERT INTO Lanchas_Conductores (id_lancha, id_conductor) VALUES
(1, 1), (2, 1), (3, 1);
GO

INSERT INTO Lanchas_Conductores (id_lancha, id_conductor) VALUES
(2, 2), (4, 2), (5, 2);
GO

INSERT INTO Lanchas_Conductores (id_lancha, id_conductor) VALUES
(1, 3), (3, 3), (5, 3), (6, 3);
GO

INSERT INTO Lanchas_Conductores (id_lancha, id_conductor) VALUES
(4, 4), (6, 4), (7, 4);
GO

INSERT INTO Lanchas_Conductores (id_lancha, id_conductor) VALUES
(7, 5), (8, 5);
GO

INSERT INTO Turnos (id_lancha, id_destino, horario, fecha, precio_base, cantidad_reservado) VALUES
(1, 1, CAST('10:00:00' AS TIME), CAST('2025-11-17' AS DATE), 10000.00, 0),
(2, 2, CAST('11:00:00' AS TIME), CAST('2025-11-17' AS DATE), 12000.00, 0),
(3, 3, CAST('14:00:00' AS TIME), CAST('2025-11-17' AS DATE), 8000.00, 0),
(4, 4, CAST('15:30:00' AS TIME), CAST('2025-11-17' AS DATE), 15000.00, 0),
(5, 5, CAST('16:00:00' AS TIME), CAST('2025-11-17' AS DATE), 7000.00, 0);
GO

INSERT INTO Turnos (id_lancha, id_destino, horario, fecha, precio_base, cantidad_reservado) VALUES
(1, 4, CAST('09:00:00' AS TIME), CAST('2025-11-18' AS DATE), 15000.00, 0),
(2, 1, CAST('10:30:00' AS TIME), CAST('2025-11-18' AS DATE), 10000.00, 0),
(3, 6, CAST('11:00:00' AS TIME), CAST('2025-11-18' AS DATE), 11000.00, 0),
(4, 5, CAST('15:00:00' AS TIME), CAST('2025-11-18' AS DATE), 7000.00, 0),
(5, 7, CAST('16:30:00' AS TIME), CAST('2025-11-18' AS DATE), 9500.00, 0),
(6, 8, CAST('13:00:00' AS TIME), CAST('2025-11-18' AS DATE), 13500.00, 0);
GO

INSERT INTO Turnos (id_lancha, id_destino, horario, fecha, precio_base, cantidad_reservado) VALUES
(1, 2, CAST('10:00:00' AS TIME), CAST('2025-11-19' AS DATE), 12000.00, 0),
(2, 3, CAST('13:00:00' AS TIME), CAST('2025-11-19' AS DATE), 8000.00, 0),
(3, 9, CAST('14:30:00' AS TIME), CAST('2025-11-19' AS DATE), 9000.00, 0),
(7, 10, CAST('09:00:00' AS TIME), CAST('2025-11-19' AS DATE), 18000.00, 0);
GO

INSERT INTO Turnos (id_lancha, id_destino, horario, fecha, precio_base, cantidad_reservado) VALUES
(1, 1, CAST('09:00:00' AS TIME), CAST('2025-11-23' AS DATE), 10000.00, 0),
(2, 2, CAST('10:00:00' AS TIME), CAST('2025-11-23' AS DATE), 12000.00, 0),
(3, 3, CAST('11:00:00' AS TIME), CAST('2025-11-23' AS DATE), 8000.00, 0),
(4, 7, CAST('12:00:00' AS TIME), CAST('2025-11-23' AS DATE), 9500.00, 0),
(5, 5, CAST('13:00:00' AS TIME), CAST('2025-11-23' AS DATE), 7000.00, 0),
(6, 10, CAST('10:00:00' AS TIME), CAST('2025-11-23' AS DATE), 18000.00, 0),
(7, 8, CAST('14:00:00' AS TIME), CAST('2025-11-23' AS DATE), 13500.00, 0),
(8, 2, CAST('11:30:00' AS TIME), CAST('2025-11-23' AS DATE), 12000.00, 0);
GO

INSERT INTO Turnos (id_lancha, id_destino, horario, fecha, precio_base, cantidad_reservado) VALUES
(1, 4, CAST('10:00:00' AS TIME), CAST('2025-11-24' AS DATE), 15000.00, 0),
(2, 1, CAST('11:00:00' AS TIME), CAST('2025-11-24' AS DATE), 10000.00, 0),
(3, 6, CAST('12:00:00' AS TIME), CAST('2025-11-24' AS DATE), 11000.00, 0),
(4, 3, CAST('13:00:00' AS TIME), CAST('2025-11-24' AS DATE), 8000.00, 0),
(5, 9, CAST('14:00:00' AS TIME), CAST('2025-11-24' AS DATE), 9000.00, 0),
(6, 7, CAST('15:00:00' AS TIME), CAST('2025-11-24' AS DATE), 9500.00, 0);
GO

INSERT INTO Turnos (id_lancha, id_destino, horario, fecha, precio_base, cantidad_reservado) VALUES
(1, 2, CAST('10:00:00' AS TIME), CAST('2025-11-25' AS DATE), 12000.00, 0),
(2, 5, CAST('14:00:00' AS TIME), CAST('2025-11-25' AS DATE), 7000.00, 0),
(3, 8, CAST('11:00:00' AS TIME), CAST('2025-11-25' AS DATE), 13500.00, 0);
GO

INSERT INTO Turnos (id_lancha, id_destino, horario, fecha, precio_base, cantidad_reservado) VALUES
(1, 10, CAST('10:00:00' AS TIME), CAST('2025-12-25' AS DATE), 22000.00, 0),
(2, 10, CAST('12:00:00' AS TIME), CAST('2025-12-25' AS DATE), 22000.00, 0),
(3, 4, CAST('11:00:00' AS TIME), CAST('2025-12-25' AS DATE), 18000.00, 0),
(4, 2, CAST('13:00:00' AS TIME), CAST('2025-12-25' AS DATE), 15000.00, 0),
(5, 1, CAST('14:00:00' AS TIME), CAST('2025-12-25' AS DATE), 12000.00, 0),
(6, 7, CAST('10:30:00' AS TIME), CAST('2025-12-25' AS DATE), 11500.00, 0);
GO

INSERT INTO Turnos (id_lancha, id_destino, horario, fecha, precio_base, cantidad_reservado) VALUES
(1, 10, CAST('20:00:00' AS TIME), CAST('2025-12-31' AS DATE), 30000.00, 0),
(2, 10, CAST('21:00:00' AS TIME), CAST('2025-12-31' AS DATE), 30000.00, 0),
(3, 8, CAST('19:30:00' AS TIME), CAST('2025-12-31' AS DATE), 25000.00, 0),
(6, 4, CAST('20:30:00' AS TIME), CAST('2025-12-31' AS DATE), 22000.00, 0);
GO



INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES (
    1, -- Turno 1 (Río Santiago, $10,000)
    (SELECT id FROM Personas WHERE dni = '20345678'), -- Juan
    7, -- Categoría Adulto (100%)
    1, -- Efectivo
    10000.00, -- monto_base = 10000 × 1.00
    0.00,     -- Sin descuento
    10000.00, -- monto_final
    'Confirmada'
);

-- Reserva 2: María (adulto) - Turno 1
INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES (
    1, 
    (SELECT id FROM Personas WHERE dni = '25456789'), -- María
    7, -- Adulto
    1, -- Efectivo
    10000.00,
    0.00,
    10000.00,
    'Confirmada'
);

-- Reserva 3: Pedro (menor) - Turno 1
INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES (
    1, 
    (SELECT id FROM Personas WHERE dni = '48567890'), -- Pedro (8 años)
    6, -- Categoría Menor (50%)
    1, -- Efectivo
    5000.00, -- monto_base = 10000 × 0.50
    0.00,
    5000.00,
    'Confirmada'
);

-- Reserva 4: Sofía (bebé) - Turno 1
INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES (
    1, 
    (SELECT id FROM Personas WHERE dni = '52678901'), -- Sofía (1 año)
    5, -- Categoría Bebé (0%)
    1, -- Efectivo
    0.00, -- monto_base = 10000 × 0.00
    0.00,
    0.00,
    'Confirmada'
);

-- Reserva 5: Roberto (jubilado) con descuento temporada baja
INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES (
    2, -- Turno 2 (Tres Bocas, $12,000)
    (SELECT id FROM Personas WHERE dni = '12123456'), -- Roberto (68 años)
    8, -- Categoría Jubilado (70%)
    3, -- Tarjeta de Crédito
    8400.00, -- monto_base = 12000 × 0.70
    1260.00, -- descuento = 8400 × 0.15 (temporada baja)
    7140.00, -- monto_final = 8400 - 1260
    'Confirmada'
);

-- Reserva 6: Laura (adulto) - Turno 3
INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES (
    3, -- Turno 3 (Museo Delta, $8,000)
    (SELECT id FROM Personas WHERE dni = '30456789'), -- Laura
    7, -- Adulto
    5, -- MercadoPago
    8000.00,
    0.00,
    8000.00,
    'Confirmada'
);

-- Reserva 7: Diego (adulto) con reserva anticipada - Turno próxima semana
INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES (
    19, -- Turno próxima semana
    (SELECT id FROM Personas WHERE dni = '32567890'), -- Diego
    7, -- Adulto
    2, -- Débito
    9500.00,
    950.00, -- 10% reserva anticipada
    8550.00,
    'Confirmada'
);

-- Reservas 8-11: Familia López completa - Turno 6
INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES 
-- Carlos (adulto)
(7, (SELECT id FROM Personas WHERE dni = '18789012'), 7, 1, 10000.00, 2000.00, 8000.00, 'Confirmada'),
-- Ana (adulto)
(7, (SELECT id FROM Personas WHERE dni = '22890123'), 7, 1, 10000.00, 2000.00, 8000.00, 'Confirmada'),
-- Lucas (menor)
(7, (SELECT id FROM Personas WHERE dni = '46901234'), 6, 1, 5000.00, 1000.00, 4000.00, 'Confirmada'),
-- Emma (menor)
(7, (SELECT id FROM Personas WHERE dni = '49012345'), 6, 1, 5000.00, 1000.00, 4000.00, 'Confirmada');

-- Reserva pendiente (ejemplo)
INSERT INTO Reservas (
    id_turno, id_persona, id_categoria_pasajero, id_metodo_pago,
    monto_base, descuento_aplicado, monto_final, estado
) VALUES (
    6, 
    (SELECT id FROM Personas WHERE dni = '35678901'), -- Sofía Torres
    7, -- Adulto
    4, -- Transferencia
    15000.00,
    0.00,
    15000.00,
    'Pendiente' -- Aún no confirmada
);
GO

INSERT INTO Reservas_Descuentos (id_reserva, id_descuento, monto_descuento) VALUES
(5, 1, 1260.00); -- Temporada baja 15%

-- Descuento de Diego (reserva anticipada)
INSERT INTO Reservas_Descuentos (id_reserva, id_descuento, monto_descuento) VALUES
(7, 3, 950.00); -- Reserva anticipada 10%

-- Descuentos de Familia López (grupo familiar 4+)
INSERT INTO Reservas_Descuentos (id_reserva, id_descuento, monto_descuento) VALUES
(8, 4, 2000.00),  -- Carlos
(9, 4, 2000.00),  -- Ana
(10, 4, 1000.00), -- Lucas
(11, 4, 1000.00); -- Emma
GO

-- Turno 1: 4 reservas (Familia Pérez)
UPDATE Turnos SET cantidad_reservado = 4 WHERE id = 1;

-- Turno 2: 1 reserva (Roberto)
UPDATE Turnos SET cantidad_reservado = 1 WHERE id = 2;

-- Turno 3: 1 reserva (Laura)
UPDATE Turnos SET cantidad_reservado = 1 WHERE id = 3;

-- Turno 6: 4 reservas (Familia López)
UPDATE Turnos SET cantidad_reservado = 4 WHERE id = 7;

-- Turno 7: 1 reserva pendiente
UPDATE Turnos SET cantidad_reservado = 1 WHERE id = 6;

-- Turno 17: 1 reserva (Diego)
UPDATE Turnos SET cantidad_reservado = 1 WHERE id = 19;
GO
