USE ViajesTuristicos
GO

CREATE PROCEDURE sp_calcular_ingresos_periodo
@fecha_inicio DATE,  --Fecha desde la que comienza el periodo
@fecha_fin DATE, --Fecha hasta la que analizamos
@total_ingresos DECIMAL(10,2) OUTPUT, --Variable que devuelve el total
@cantidad_reservas INT OUTPUT, --Devuelve la cantidad
@cantidad_pasajeros INT OUTPUT --Devuelve los pasajeros
AS
BEGIN
	IF @fecha_inicio > @fecha_fin
	BEGIN
		RAISERROR('Error: la fecha de inicio no puede ser posterior a la fecha final', 16, 1);
		RETURN;
	END

	--Calculo de ingresos
	SELECT 
		@total_ingresos = SUM(r.monto_final),
		@cantidad_reservas = COUNT(r.id),
		@cantidad_pasajeros = COUNT(DISTINCT r.id_persona)
		FROM Reservas r
		JOIN Turnos t ON r.id_turno= t.id
		WHERE r.estado= 'Confirmada'
		AND t.fecha BETWEEN @fecha_inicio AND @fecha_fin;

		--Si no hay datos, asignamos 0
		SET @total_ingresos = ISNULL(@total_ingresos, 0);
		SET @cantidad_reservas = ISNULL(@cantidad_reservas, 0);
		SET @cantidad_pasajeros = ISNULL(@cantidad_pasajeros, 0);
END 
GO