USE ViajesTuristicos
GO

CREATE PROCEDURE sp_crear_turno(
	@id_lancha INT,
	@id_destino INT,
	@fecha DATE,
	@horario TIME,
	@precio_base DECIMAL(8,2),
	@id_turno_creado INT OUTPUT, --Id del turno creado
	@mensaje VARCHAR(500) --Mensaje en caso de error o exito
)
AS
BEGIN
	BEGIN TRY 
		BEGIN TRANSACTION;

		--Validamos que la lancha exista
		IF NOT EXISTS(SELECT 1 FROM Lanchas WHERE id= @id_lancha)
		BEGIN
			SET @mensaje = 'Error: la lancha especificada no existe';
			SET @id_turno_creado = NULL;
			ROLLBACK TRANSACTION;
			RETURN;
		END

		--Validar que el destino existe
		IF NOT EXISTS (SELECT 1 FROM Destinos WHERE id = @id_destino)
		BEGIN
			SET @mensaje = 'Error: El destino especificado no existe' ;
			SET @id_turno_creado = NULL;
			ROLLBACK TRANSACTION
			RETURN;
		END

		--Validamos que la fecha no sea del pasado
		IF @fecha < CAST(GETDATE() AS DATE)
		BEGIN
			SET @mensaje = 'Error: No se pueden crear turnos con fecha pasada';;
			SET @id_turno_creado = NULL;
			ROLLBACK TRANSACTION;
			RETURN;
		END
		
		--Validacion del horario
		IF @horario is NULL or @horario = '00:00:00' 
		BEGIN
			SET @mensaje = 'Error: El horario no puede estar vacio';
			SET @id_turno_creado = NULL;
			ROLLBACK TRANSACTION;
			RETURN
		END

		IF @precio_base <= 0
		BEGIN
			SET @mensaje = 'Error, el precio base no puede ser 0';
			SET @id_turno_creado = NULL;
			ROLLBACK TRANSACTION;
			RETURN;
		END

		--Verificamos que no haya un turno en el mismo momento para esa lancha
		IF EXISTS (
			SELECT 1 FROM Turnos WHERE id_lancha = @id_lancha AND fecha = @fecha AND horario = @horario
			)
		BEGIN
			SET @mensaje = 'Error: ya existe un turno para esa lancha en la fecha y horario ingresada'
			SET @id_turno_creado = NULL;
			ROLLBACK TRANSACTION;
			RETURN;
		END

		--Si supero todas las validaciones, creamos el turno
		INSERT INTO Turnos (
			id_lancha,
			id_destino,
			horario,
			fecha,
			precio_base,
			cantidad_reservado)
		VALUES (
			@id_lancha,
			@id_destino,
			@horario,
			@fecha,
			@precio_base,
			0
			);
		SET @id_turno_creado = SCOPE_IDENTITY();

		COMMIT TRANSACTION;
		--Mensaje de Exito

		SET @mensaje= 'Exito: Turno #' + CAST(@id_turno_creado AS VARCHAR);
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		SET @mensaje = 'Error: ' + ERROR_MESSAGE();
		SET @id_turno_creado = NULL;
	END CATCH
END
GO