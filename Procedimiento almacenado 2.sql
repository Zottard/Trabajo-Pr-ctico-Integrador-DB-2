USE ViajesTuristicos
GO

CREATE PROCEDURE sp_crear_reserva_grupal
	@id_turno INT,
	@id_metodo_pago SMALLINT,
	@pasajeros_data NVARCHAR(MAX), --Para que podamos hacerlo multiple, necesitamos un JSON con los datos de cada uno de los pasajeros de la reserva
	@codigo_descuento VARCHAR(50) = NULL, --Por si tiene algun descuento, por ej, temporada alta
	@reservas_creadas INT OUTPUT, --Cantidad de reservas que son creadas si todo sale bien
	@monto_total DECIMAL(10,2) OUTPUT, --Monto total del grupo
	@mensaje VARCHAR(500) OUTPUT --Mensaje que sale al usuario si salio todo bien o hubo un error
AS
BEGIN
	DECLARE @capacidad_lancha TINYINT;
	DECLARE @cantidad_reservado TINYINT;
	DECLARE @capacidad_disponible TINYINT;
	DECLARE @cantidad_pasajeros INT;
	DECLARE @precio_base DECIMAL(8,2);
	DECLARE @id_descuento INT = NULL;
	DECLARE @porcentaje_descuento DECIMAL(5,2)= 0;
	DECLARE @fecha_turno DATE;

	BEGIN TRY
		BEGIN TRANSACTION
		-- Validamos que el turno existe
		IF NOT EXISTS(SELECT 1 FROM Turnos WHERE id=@id_turno)
		BEGIN
			SET @mensaje = 'Error: El turno no existe';
			ROLLBACK TRANSACTION;
			RETURN;
		END

		--Obtenemos la informacion del turno y la capacidad
		SELECT 
			@precio_base = t.precio_base,
			@cantidad_reservado = t.cantidad_reservado,
			@capacidad_lancha = l.capacidad,
			@fecha_turno = t.fecha
		FROM Turnos t JOIN Lanchas l ON t.id_lancha = l.id WHERE t.id = @id_turno;
		--Calculamos la capacidad disponible
		SET @capacidad_disponible = @capacidad_lancha - @cantidad_reservado;
		--Contamos la cantidad de pasajeros que vamos a ingresar
		SELECT @cantidad_pasajeros = COUNT(*) FROM OPENJSON(@pasajeros_data);
		--Validamos la capacidad disponible
		IF @cantidad_pasajeros > @capacidad_disponible
		BEGIN
			SET @mensaje = 'Error: No hay suficiente capacidad para hacer la reserva';
			ROLLBACK TRANSACTION;
			RETURN;
		END
		--Validamos que el turno no sea pasado
		IF @fecha_turno < CAST(GETDATE() AS DATE)
		BEGIN 
			SET @mensaje = 'Error: no se puede crear una reserva para un turno pasado';
			ROLLBACK TRANSACTION;
			RETURN;
		END
		--Validamos que el metodo de pago exista y este activo
		IF NOT EXISTS (SELECT 1 FROM Metodo_Pago WHERE id=@id_metodo_pago AND activo=1)
		BEGIN
			SET @mensaje = 'Error: Metodo de pago inexistente o inactivo';
			ROLLBACK TRANSACTION;
			RETURN;
		END
		--Buscar descuento seleccionado si es ingresado
		IF @codigo_descuento IS NOT NULL
		BEGIN
			SELECT
				@id_descuento = id,
				@porcentaje_descuento = porcentaje
			FROM Descuentos WHERE descripcion = @codigo_descuento
			AND activo= 1 AND(fecha_inicio IS NULL or @fecha_turno >= fecha_inicio) 
			AND(fecha_fin IS NULL OR @fecha_turno <= fecha_fin);

			IF @id_descuento IS NULL
			BEGIN
				SET @mensaje = 'Advertencia: Código de descuento inválido o expirado';
			END
		END
		--Iniciamos los contadores
		SET @reservas_creadas = 0;
		SET @monto_total = 0;
		--Declaramos una tabla para procesar pasajeros
		DECLARE @id_persona INT;
		DECLARE @dni VARCHAR(8);
		DECLARE @nombre VARCHAR(30);
		DECLARE @apellido VARCHAR(30);
		DECLARE @edad TINYINT;
		DECLARE @telefono VARCHAR(10);
		DECLARE @porcentaje_categoria DECIMAL (5,2);
		DECLARE @monto_base DECIMAL(10,2);
		DECLARE @descuento_aplicado DECIMAL(10,2);
		DECLARE @monto_final DECIMAL(10,2);
		DECLARE @id_reserva INT;

		--Utilizamos un cursor para poder procesar todos los pasajeros ingresados
		DECLARE pasajeros_cursor CURSOR FOR
		SELECT
			JSON_VALUE(value, '$.dni'),
			JSON_VALUE(value, '$.nombre'),
			JSON_VALUE(value, '$.apellido'),
			CAST(JSON_VALUE(value, '$.edad') AS TINYINT),
			JSON_VALUE(value, '$.telefono')
		FROM OPENJSON(@pasajeros_data);

		OPEN pasajeros_cursor;
		FETCH NEXT FROM pasajeros_cursor INTO @dni, @nombre, @apellido, @edad, @telefono;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--Buscar o crear persona
			SELECT @id_persona = id FROM Personas WHERE dni= @dni;
			IF @id_persona IS NULL
			BEGIN
				INSERT INTO Personas(dni, nombre, apellido, edad, telefono)
				VALUES(@dni, @nombre, @apellido,@edad, @telefono);
				SET @id_persona = SCOPE_IDENTITY();
			END
			--Calculamos los montons
			SET @monto_base = @precio_base * @porcentaje_categoria
			SET @descuento_aplicado = @monto_base * @porcentaje_descuento;
			SET @monto_final = @monto_base - @descuento_aplicado;

			--Creamos la reserva
			INSERT INTO Reservas(
				id_turno,
				id_persona,
				id_categoria_pasajero,
				id_metodo_pago,
				monto_base,
				descuento_aplicado,
				monto_final,
				estado
			)
			VALUES (
				@id_turno,
				@id_persona,
				NULL,
				@id_metodo_pago,
				@monto_base,
				@descuento_aplicado,
				@monto_final,
				'Confirmada'
			);
			SET @id_reserva = SCOPE_IDENTITY();
			--Obtenemos el porcentaje de descuento de la categoría ya que tenemos un trigger que asigna automaticamente la categoria con la edad
			SELECT TOP 1 @porcentaje_categoria = porcentaje_tarifa 
			FROM Categorias_Pasajero
			WHERE @edad BETWEEN edad_minima AND edad_maxima
			ORDER BY edad_minima DESC;

			--Registramos el descuento si fue aplicado
			IF @id_descuento IS NOT NULL
			BEGIN
				INSERT INTO Reservas_Descuentos(id_reserva, id_descuento, monto_descuento)
				VALUES (@id_reserva, @id_descuento, @descuento_aplicado);
			END

			--Actualizamos los contadores
			SET @reservas_creadas = @reservas_creadas + 1;
			SET @monto_total = @monto_total + @monto_final;
			
			FETCH NEXT FROM pasajeros_cursor INTO @dni, @nombre, @apellido, @edad, @telefono;
		END
		
		CLOSE pasajeros_cursor;
		DEALLOCATE pasajeros_cursor;
		--Actualizamos la cantidad reservada del turno
		UPDATE Turnos
		SET cantidad_reservado = cantidad_reservado + @reservas_creadas
		WHERE id = @id_turno;

		COMMIT TRANSACTION;

		SET @mensaje = 'Operacion exitosa, se crearon las reservas';
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			SET @mensaje = 'Error: ' + ERROR_MESSAGE();
			SET @reservas_creadas = 0;
			SET @monto_total = 0;
	END CATCH
END
GO


