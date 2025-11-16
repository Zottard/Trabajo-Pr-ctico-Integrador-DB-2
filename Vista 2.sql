USE ViajesTuristicos
GO

CREATE VIEW vw_comparacion_precios_turno
AS
SELECT
	t.id AS turno_id,
	t.fecha,
	t.horario AS hora,
	d.zona AS destino, l.nombre AS lancha,
	l.capacidad,

	--precio base del turno
	t.precio_base AS precio_turno,

	--Contador de los pasajeros del turno
	COUNT(r.id) AS total_pasajeros,
	SUM(CASE WHEN r.estado = 'Confirmada' THEN 1 ELSE 0 END) AS pasajeros_confirmados,
	SUM(CASE WHEN r.estado = 'Pendiente' THEN 1 ELSE 0 END) AS pasajeros_pendientes,
	SUM(CASE WHEN r.estado = 'Cancelada' THEN 1 ELSE 0 END) AS pasajeros_cancelados,

	--Obtenemos lo que deberíamos recaudar total, lo descontado, y lo recaudado final solo de los confirmados
	SUM(CASE WHEN r.estado = 'Confirmada' THEN r.monto_base ELSE 0 END) AS total_sin_descuento,
	SUM(CASE WHEN r.estado = 'Confirmada' THEN r.descuento_aplicado ELSE 0 END) AS total_descuentos,
	SUM(CASE WHEN r.estado = 'Confirmada' THEN r.monto_final ELSE 0 END) AS total_con_descuento,

	--Calculamos la diferencia entre el total y lo cobrado
	SUM(CASE WHEN r.estado = 'Confirmada' THEN r.monto_base ELSE 0 END) -
	SUM(CASE WHEN r.estado = 'Confirmada' THEN r.monto_final ELSE 0 END) AS dinero_no_cobrado,

	--Calculamos el porcentaje promedio de descuento
	CASE
		WHEN SUM(CASE WHEN r.estado= 'Confirmada' THEN r.monto_base ELSE 0 END) > 0
		THEN CAST(
			(SUM(CASE WHEN r.estado = 'Confirmada' THEN r.descuento_aplicado ELSE 0 END) * 100.0) /
			SUM(CASE WHEN r.estado = 'Confirmada' THEN r.monto_base ELSE 0 END)
			AS DECIMAL(5,2))
		ELSE 0.00
	END AS porcentaje_descuento,

	-- promedio por pasajero
	CASE 
		WHEN SUM(CASE WHEN r.estado = 'Confirmada' THEN 1 ELSE 0 END) > 0
		THEN CAST(
			SUM(CASE WHEN r.estado = 'Confirmada' THEN r.monto_final ELSE 0 END) /
			SUM(CASE WHEN r.estado = 'Confirmada' THEN 1 ELSE 0 END)
			AS DECIMAL(10,2))
		ELSE 0.00
	END AS ingreso_promedio_pasajero



	FROM Turnos t
	JOIN Lanchas l ON t.id_lancha = l.id
	JOIN Destinos d ON t.id_destino = d.id
	LEFT JOIN Reservas r ON t.id = r.id_turno
	GROUP BY
		t.id, t.fecha, t.horario, t.precio_base, t.cantidad_reservado, d.zona,
		l.nombre, l.capacidad

GO



