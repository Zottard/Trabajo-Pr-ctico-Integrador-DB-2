USE ViajesTuristicos
GO

CREATE VIEW vw_licencias_por_vencer
AS
SELECT
	--Informacion del conductor
	c.id AS id_conductor,
	p.nombre + ' ' + p.apellido AS conductor,
	p.dni,
	p.telefono,
	c.estado AS conductor_activo,

	--Información de la licencia
	l.fecha_emision,
	l.fecha_caducidad,

	--Calculos de días
	DATEDIFF(DAY, CAST(GETDATE() AS DATE), l.fecha_caducidad) AS dias_hasta_vencer,

	--Estado de la licencia
	CASE
		WHEN l.fecha_caducidad < CAST(GETDATE() AS DATE)
			THEN 'VENCIDA'
		WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), l.fecha_caducidad) <=7
			THEN 'CRITICO (<=7 dias)'
		WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), l.fecha_caducidad) <=30
			THEN 'ADVERTENCIA(<=30 dias)'
		WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), l.fecha_caducidad) <= 90
			THEN 'PROXIMO (<=90 dias)' 
		ELSE 'VIGENTE'
	END AS estado_licencia,
	--Prioridad numérica para ordenar
	CASE 
		WHEN l.fecha_caducidad < CAST(GETDATE() AS DATE) THEN 1 -- VENCIDA
		WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), l.fecha_caducidad) <= 7 THEN 2 -- CRITICO
		WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), l.fecha_caducidad) <= 30 THEN 3 --ADVERTENCIA
		WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), l.fecha_caducidad) <= 90 THEN 4 -- PROXIMO
		ELSE 5 -- VIGENTE
	END AS prioridad,

	(SELECT COUNT(*) FROM Lanchas_Conductores lc WHERE lc.id_conductor= c.id) AS cantidad_lanchas

FROM Conductor c
JOIN Personas p ON c.id_persona = p.id
JOIN Licencias l ON c.id_licencia = l.id;
GO


