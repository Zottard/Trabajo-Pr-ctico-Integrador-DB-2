USE ViajesTuristicos
GO

CREATE TRIGGER tr_asignar_categoria
ON Reservas
AFTER INSERT
AS
BEGIN
	DECLARE @id_reserva INT;
	DECLARE @id_persona INT;
	DECLARE @id_categoria INT;
	DECLARE @edad INT;
	DECLARE @id_turno INT;
	DECLARE @precio_base DECIMAL(10,2);
	DECLARE @porcentaje_tarifa DECIMAL(5,2);
	DECLARE @monto_base_nuevo DECIMAL(10,2);
	--Un cursor es como el for de SQL, en este caso nos servirá para procesar si vienen multiples reservas
	DECLARE cursor_categorias CURSOR FOR
	SELECT
		i.id,
		i.id_persona,
		i.id_categoria_pasajero,
		i.id_turno,
		i.monto_base
	FROM inserted i;

	DECLARE @monto_base_actual DECIMAL(10,2);

	OPEN cursor_categorias;
	--Inicia el ciclo for
	FETCH NEXT FROM cursor_categorias
	INTO @id_reserva, @id_persona, @id_categoria, @id_turno, @monto_base_actual;

	WHILE @@FETCH_STATUS = 0
	
	BEGIN
		--asignamos categoria solo si no fue asignada antes
		IF @id_categoria IS NULL
		BEGIN
			--obtengo la edad de la persona
			SELECT @edad= edad FROM Personas WHERE id= @id_persona;

			--busco la categoría que le corresponde
			SELECT @id_categoria = id, @porcentaje_tarifa = porcentaje_tarifa 
			FROM Categorias_Pasajero WHERE @edad>=edad_minima AND (@edad<=edad_maxima OR edad_maxima IS NULL)
			
			IF @id_categoria IS NOT NULL
			BEGIN
				--Actualizamos la reserva con la categoria obtenida
				UPDATE Reservas
				SET id_categoria_pasajero= @id_categoria
				WHERE id= @id_reserva;
			END
		END
		ELSE
		BEGIN
			--Si ya tiene categoría,
			SELECT @porcentaje_tarifa = porcentaje_tarifa FROM Categorias_Pasajero
			WHERE id= @id_categoria;
		END
		--Como el monto es not null y por defecto(DEFAULT) 0.00 calculamos el nuevo en caso que sea 0.00
		IF @monto_base_actual = 0.00
		BEGIN
			--Obtenemos el precio del turno
			SELECT @precio_base = precio_base FROM Turnos WHERE id=@id_turno;
			--Calculamos el monto base dependiendo la categoría
			SET @monto_base_nuevo = @precio_base * @porcentaje_tarifa;

			--Actualizamos la reserva
			UPDATE Reservas
			SET monto_base= @monto_base_nuevo,
				monto_final= @monto_base_nuevo- ISNULL(descuento_aplicado,0)
			WHERE id= @id_reserva;
		END
		--Pasamos a la siguiente reserva si es multiple
		FETCH NEXT FROM cursor_categorias
		INTO @id_reserva, @id_persona, @id_categoria, @id_turno, @monto_base_actual;
	END

	CLOSE cursor_categorias;
	DEALLOCATE cursor_categorias;
END
GO