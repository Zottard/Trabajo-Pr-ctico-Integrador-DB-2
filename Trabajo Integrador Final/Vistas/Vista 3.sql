USE ViajesTuristicos
GO

CREATE VIEW vw_pasajeros_por_categoria
AS
SELECT
	--informacion del turno
	t.id AS turno_id,
	t.fecha,
	t.horario AS hora,
	d.zona AS destino,
	l.nombre AS lancha,

	--Conteo por cada categoría(solo se cuentan las confirmadas)
	SUM(CASE WHEN r.estado = 'Confirmada' AND cp.nombre = 'Bebé' THEN 1 ELSE 0 END) AS bebes,
	SUM(CASE WHEN r.estado = 'Confirmada' AND cp.nombre = 'Menor' THEN 1 ELSE 0 END) AS menores,
	SUM(CASE WHEN r.estado = 'Confirmada' AND cp.nombre = 'Adulto' THEN 1 ELSE 0 END) AS adultos,
	SUM(CASE WHEN r.estado = 'Confirmada' AND cp.nombre = 'Jubilado' THEN 1 ELSE 0 END) AS jubilados,

	--Conteo de pasajeros confirmados
	SUM(CASE WHEN r.estado= 'Confirmada' THEN 1 ELSE 0 END) AS total_pasajeros,

	--Porcentaje por cada categoría
	CASE 
		WHEN SUM(CASE WHEN r.estado= 'Confirmada' THEN 1 ELSE 0 END) > 0
		THEN CAST(
		(SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre = 'Bebé' THEN 1 ELSE 0 END) * 100.0) /
		SUM(CASE WHEN r.estado = 'Confirmada' THEN 1 ELSE 0 END)
		AS DECIMAL(5,2))
		ELSE 0.00
	END AS porcentaje_bebes,
	
	CASE 
		WHEN SUM(CASE WHEN r.estado= 'Confirmada' THEN 1 ELSE 0 END) > 0
		THEN CAST(
		(SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre = 'Menor' THEN 1 ELSE 0 END) * 100.0) /
		SUM(CASE WHEN r.estado = 'Confirmada' THEN 1 ELSE 0 END)
		AS DECIMAL(5,2))
		ELSE 0.00
	END AS porcentaje_menores,

	CASE 
		WHEN SUM(CASE WHEN r.estado= 'Confirmada' THEN 1 ELSE 0 END) > 0
		THEN CAST(
		(SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre = 'Adulto' THEN 1 ELSE 0 END) * 100.0) /
		SUM(CASE WHEN r.estado = 'Confirmada' THEN 1 ELSE 0 END)
		AS DECIMAL(5,2))
		ELSE 0.00
	END AS porcentaje_adultos,

	CASE 
		WHEN SUM(CASE WHEN r.estado= 'Confirmada' THEN 1 ELSE 0 END) > 0
		THEN CAST(
		(SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre = 'Jubilado' THEN 1 ELSE 0 END) * 100.0) /
		SUM(CASE WHEN r.estado = 'Confirmada' THEN 1 ELSE 0 END)
		AS DECIMAL(5,2))
		ELSE 0.00
	END AS porcentaje_jubilados,

	--Con los porcentajes ya calculados podemos ponerle una clasificación al grupo
	CASE
		--Más del 50% son niños o bebés 
		WHEN SUM(CASE WHEN r.estado = 'Confirmada' AND cp.nombre IN('Bebé','Menor') THEN 1 ELSE 0 END) >
			SUM(CASE WHEN r.estado = 'Confirmada' AND cp.nombre IN('Adulto', 'Jubilado') THEN 1 ELSE 0 END)
		THEN 'Orientado a familias'
		--Más del 50% son jubilados
		WHEN SUM(CASE WHEN r.estado = 'Confirmada' AND cp.nombre = 'Jubilado' THEN 1 ELSE 0 END) >
			SUM(CASE WHEN r.estado= 'Confirmada' THEN 1 ELSE 0 END) * 0.5
		THEN 'Orientado a adultos mayores'
		--Más del 80% son adultos
		WHEN SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre= 'Adulto' THEN 1 ELSE 0 END) >
			SUM(CASE WHEN r.estado= 'Confirmada' THEN 1 ELSE 0 END) * 0.8
		THEN 'Principalmente adultos'
		--Turno sin reservas
		WHEN SUM(CASE WHEN r.estado= 'Confirmada' THEN 1 ELSE 0 END) = 0
		THEN 'Sin reservas' 
		ELSE 'Grupo Mixto'
	END AS tipo_grupo,

	--Tambien podemos analizar los ingresos por cada categoría
	SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre = 'Bebé' THEN r.monto_final ELSE 0 END) AS ingresos_bebes,
	SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre = 'Menor' THEN r.monto_final ELSE 0 END) AS ingresos_menores,
	SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre = 'Adulto' THEN r.monto_final ELSE 0 END) AS ingresos_adultos,
	SUM(CASE WHEN r.estado= 'Confirmada' AND cp.nombre = 'Jubilado' THEN r.monto_final ELSE 0 END) AS ingresos_jubilados,

	--Ingreso total
	SUM(CASE WHEN r.estado = 'Confirmada' THEN r.monto_final ELSE 0 END) AS ingreso_total

FROM Turnos t
JOIN Lanchas l ON t.id_lancha= l.id
JOIN Destinos d ON t.id_destino = d.id
LEFT JOIN Reservas r ON t.id= r.id_turno
LEFT JOIN Categorias_Pasajero cp ON r.id_categoria_pasajero = cp.id
GROUP BY
	t.id, t.fecha, t.horario, d.zona, l.nombre;

GO
