USE ViajesTuristicos
GO

CREATE TRIGGER tr_actualizar_contador_reservas
ON Reservas
AFTER UPDATE, DELETE
AS
BEGIN
	DECLARE @id_turno INT;
	DECLARE @incremento INT;

	--Caso DELETE
	IF NOT EXISTS(SELECT 1 FROM inserted)
	BEGIN
		--Como es un DELETE no hay filas en inserted
		
		--declaro un cursor para procesar varias reservas
		DECLARE cursor_deleted CURSOR FOR SELECT id_turno, estado FROM deleted;

		DECLARE @estado_eliminado VARCHAR(20);
		OPEN cursor_deleted;
		FETCH NEXT FROM cursor_deleted INTO @id_turno, @estado_eliminado;

		WHILE @@FETCH_STATUS= 0
		BEGIN
			--Solo resto si es confirmada
			IF @estado_eliminado = 'Confirmada'
			BEGIN
				UPDATE Turnos
				SET cantidad_reservado= cantidad_reservado - 1
				WHERE id= @id_turno;
			END
			FETCH NEXT FROM cursor_deleted INTO @id_turno, @estado_eliminado;
		END
		CLOSE cursor_deleted;
		DEALLOCATE cursor_deleted;
	END

	--Caso UPDATE
	BEGIN
		--declaro el cursor para comparar estado antes y después
		DECLARE cursor_update CURSOR FOR 
		SELECT d.id, d.id_turno, d.estado AS estado_anterior, i.estado AS estado_nuevo
		FROM deleted d JOIN inserted i ON d.id=i.id;

		DECLARE @id_reserva INT;
		DECLARE @estado_anterior VARCHAR(20);
		DECLARE @estado_nuevo VARCHAR(20);

		OPEN cursor_update;
		
		FETCH NEXT FROM cursor_update
		INTO @id_reserva, @id_turno, @estado_anterior, @estado_nuevo;

		WHILE @@FETCH_STATUS= 0
		BEGIN 
			--verificacion de si hubo cambio de estado
			IF @estado_anterior != @estado_nuevo
			BEGIN
				SET @incremento = 0;
				-- ahora determino el incremento dependiendo el cambio de estado
				-- Pendiente o cancelada a confirmada +1

				IF @estado_anterior IN ('Pendiente', 'Cancelada')
					AND @estado_nuevo = 'Confirmada'
				BEGIN
					SET @incremento = 1;
				END
				-- Confirmada a pendiente/cancelada -1
				ELSE IF @estado_anterior = 'Confirmada' 
						AND @estado_nuevo IN ('Pendiente', 'Cancelada')
				BEGIN
					SET @incremento = -1;
				END
				-- Entre pendiente y cancelada el incremento es 0
				ELSE IF @estado_anterior IN ('Pendiente', 'Cancelada')
						AND @estado_nuevo IN ('Pendiente', 'Cancelada')
				BEGIN
					SET @incremento = 0;
				END

				--Actualizamos el contador si hay cambio
				IF @incremento != 0
				BEGIN
					UPDATE Turnos
					SET cantidad_reservado = cantidad_reservado + @incremento
					WHERE id = @id_turno;
				END
			END
			
			FETCH NEXT FROM cursor_update
			INTO @id_reserva, @id_turno, @estado_anterior, @estado_nuevo;
		END
		
		CLOSE cursor_update;
		DEALLOCATE cursor_update;
	END
END;
GO