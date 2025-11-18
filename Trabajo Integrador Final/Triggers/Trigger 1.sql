USE ViajesTuristicos
GO

CREATE TRIGGER tr_validar_capacidad_lancha
ON Reservas
INSTEAD OF INSERT
AS
BEGIN 
	DECLARE @id_turno INT;
	DECLARE @capacidad_lancha INT;
	DECLARE @reservas_actuales INT;
	DECLARE @nuevas_reservas INT;
	DECLARE @total_reservas INT;
	DECLARE @id_lancha INT;
	--id_turno de la reserva por insertarse
	SELECT @id_turno = id_turno FROM inserted;
	--información del turno y la lancha
	SELECT @capacidad_lancha= l.capacidad,
		   @reservas_actuales= t.cantidad_reservado,
		   @id_lancha= t.id_lancha
	FROM Turnos t JOIN Lanchas l ON t.id_lancha= l.id WHERE t.id=@id_turno;
	--Contador de reservas ingresandose(pueden ser mas de 1 en un ingreso multiple)
	SELECT @nuevas_reservas= COUNT(*) FROM inserted;
	--Total de reservas si se hace el insert
	SET @total_reservas= @reservas_actuales + @nuevas_reservas;
	--Validamos si el espacio es suficiente comparando el total de reservas con la capacidad
	IF @total_reservas > @capacidad_lancha
	BEGIN
		DECLARE @mensaje_error VARCHAR(500);
		SET @mensaje_error = 
			'Error: no hay suficiente capacidad disponible en el respectivo turno';
		RAISERROR(@mensaje_error,16,1);
		ROLLBACK TRANSACTION;
		RETURN;
	END

	INSERT INTO Reservas(
		id_turno,
		id_persona,
		id_categoria_pasajero,
		id_metodo_pago,
		monto_base,
		descuento_aplicado,
		monto_final,
		estado,
		fecha_creacion
	)
	SELECT
		id_turno,
		id_persona,
		id_categoria_pasajero,
		id_metodo_pago,
		monto_base,
		descuento_aplicado,
		monto_final,
		estado,
		GETDATE()
	FROM inserted;

	UPDATE Turnos
	SET cantidad_reservado = cantidad_reservado + (SELECT COUNT(*) FROM inserted WHERE estado = 'Confirmada')
	WHERE id = @id_turno;
END
GO