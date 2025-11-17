USE ViajesTuristicos
GO
CREATE PROCEDURE sp_calcular_ingresos_periodo
@fecha_inicio DATE,  
@fecha_fin DATE, 
@total_ingresos DECIMAL(10,2) OUTPUT, 
@cantidad_reservas INT OUTPUT, 
@clientes_unicos INT OUTPUT 
AS
BEGIN
    IF @fecha_inicio > @fecha_fin
    BEGIN
        RAISERROR('Error: la fecha de inicio no puede ser posterior a la fecha final', 16, 1);
        RETURN;
    END
    
    SELECT 
        @total_ingresos = SUM(r.monto_final),
        @cantidad_reservas = COUNT(r.id),
        @clientes_unicos = COUNT(DISTINCT r.id_persona)
    FROM Reservas r
    JOIN Turnos t ON r.id_turno = t.id
    WHERE r.estado = 'Confirmada'
    AND t.fecha BETWEEN @fecha_inicio AND @fecha_fin;
    
    SET @total_ingresos = ISNULL(@total_ingresos, 0);
    SET @cantidad_reservas = ISNULL(@cantidad_reservas, 0);
    SET @clientes_unicos = ISNULL(@clientes_unicos, 0);
END 
GO