USE Helpdesk_Kvas
GO

--NIVEL DE RECURSIVIDAD EN EL GRUPO
DROP PROCEDURE IF EXISTS sp_ListarNivelGrupo;
GO
CREATE PROCEDURE sp_ListarNivelGrupo(
	@IdGrupo INT )
	AS
		BEGIN
			WITH Cte_Grupos(IdGrupo,Nombre,Descripcion,IdPadre,Icono,Estatus,FechaRegistro, LevelGrupo) AS (
				SELECT g.IdGrupo, g.Nombre, g.Descripcion, g.IdPadre, g.Icono, g.Estatus, g.FechaRegistro, 0 AS LevelGrupo
				FROM Grupos AS g
				WHERE g.IdPadre is null
				UNION ALL
				SELECT gd.IdGrupo, gd.Nombre, gd.Descripcion, gd.IdPadre, gd.Icono, gd.Estatus, gd.FechaRegistro, LevelGrupo+1
				FROM Grupos AS gd
				INNER JOIN Cte_Grupos AS cte ON gd.IdPadre = cte.IdGrupo
			)
			SELECT ct.IdGrupo, ct.Nombre, ct.Descripcion, ct.IdPadre, c.IdGrupo AS IdGrupoPadre, c.Nombre AS Categoria, ct.Icono, ct.Estatus, ct.FechaRegistro, ct.LevelGrupo
			FROM Cte_Grupos AS ct
			INNER JOIN Cte_Grupos AS c ON ct.IdPadre = c.IdGrupo
			WHERE ct.IdGrupo = @IdGrupo
			ORDER BY ct.LevelGrupo ASC
		END
GO
--PERSONAS
DROP VIEW IF EXISTS vw_Personas;
GO
CREATE VIEW vw_Personas
AS
	SELECT p.IdPersona, p.IdUsuario, p.Nombres, gd.Nombre AS TipoPersona, p.CiRif, p.Direccion, p.Telefonos, p.Email, p.FechaRegistro
	FROM Personas AS p
	INNER JOIN GruposDetalles AS gd ON P.IdTipoPersona = gd.IdGrupoDetalle
GO
--GRUPOSDETALLES
DROP VIEW IF EXISTS vw_GruposDetalles;
GO
CREATE VIEW vw_GruposDetalles AS
	WITH Cte_GruposDetalles(IdGrupoDetalle,Nombre,Descripcion,Orden,IdGrupo,IdPadre,Imagen,UrlDetalle,Estatus,FechaRegistro, LevelGrupo) AS (
		SELECT g.IdGrupoDetalle, g.Nombre, g.Descripcion, g.Orden, g.IdGrupo, g.IdPadre, g.Imagen, g.UrlDetalle, g.Estatus, g.FechaRegistro, 0 AS LevelGrupo
		FROM GruposDetalles AS g
		WHERE g.IdPadre is null
		UNION ALL
		SELECT gd.IdGrupoDetalle, gd.Nombre, gd.Descripcion, gd.Orden, gd.IdGrupo, gd.IdPadre, gd.Imagen, gd.UrlDetalle, gd.Estatus, gd.FechaRegistro, LevelGrupo+1
		FROM GruposDetalles AS gd
		INNER JOIN Cte_GruposDetalles AS cte ON gd.IdPadre = cte.IdGrupoDetalle
	)
	SELECT ct.IdGrupoDetalle, ct.Nombre, ct.Descripcion, ct.Orden, ct.IdGrupo, g.Nombre AS NombreGrupo, ct.IdPadre, c.IdGrupo AS IdGrupoPadre, c.Nombre AS Categoria, ct.Imagen, ct.UrlDetalle, ct.Estatus, ct.FechaRegistro, ct.LevelGrupo
	FROM Cte_GruposDetalles AS ct
	INNER JOIN Cte_GruposDetalles AS c ON ct.IdPadre = c.IdGrupoDetalle
	INNER JOIN Grupos AS g ON ct.IdGrupo = g.IdGrupo
GO
--MENU
DROP VIEW IF EXISTS vw_Menu;
GO
CREATE VIEW vw_Menu AS
WITH Cte_GruposDetalles(IdGrupoDetalle,Nombre,Descripcion,Orden,IdGrupo,IdPadre,Imagen,UrlDetalle,Estatus,FechaRegistro, LevelGrupo) AS (
		SELECT g.IdGrupoDetalle, g.Nombre, g.Descripcion, g.Orden, g.IdGrupo, g.IdPadre, g.Imagen, g.UrlDetalle, g.Estatus, g.FechaRegistro, 0 AS LevelGrupo
		FROM GruposDetalles AS g
		WHERE g.IdPadre is null
		UNION ALL
		SELECT gd.IdGrupoDetalle, gd.Nombre, gd.Descripcion, gd.Orden, gd.IdGrupo, gd.IdPadre, gd.Imagen, gd.UrlDetalle, gd.Estatus, gd.FechaRegistro, LevelGrupo+1
		FROM GruposDetalles AS gd
		INNER JOIN Cte_GruposDetalles AS cte ON gd.IdPadre = cte.IdGrupoDetalle
	)
	SELECT ct.IdGrupoDetalle, ct.Nombre, ct.Descripcion, ct.Orden, ct.IdGrupo, g.Nombre AS NombreGrupo, c.IdGrupo AS IdGrupoPadre, ct.IdPadre, c.Nombre AS Categoria, ct.Imagen, ct.UrlDetalle, ct.Estatus, ct.FechaRegistro, ct.LevelGrupo
	FROM Cte_GruposDetalles AS ct
	INNER JOIN Cte_GruposDetalles AS c ON ct.IdPadre = c.IdGrupoDetalle
	INNER JOIN Grupos AS g ON ct.IdGrupo = g.IdGrupo
	WHERE ct.IdGrupo IN(1,2)
GO
-- USUARIOs
DROP VIEW IF EXISTS vw_ListarUsuarios;
GO
CREATE VIEW vw_ListarUsuarios
 AS
	SELECT us.IdUsuario, us.NombreUsuario, us.Contrasena, us.IdRoles, rl.Nombre AS Rol, us.IdPreguntaSeguridad AS IdPregunta, ps.Nombre AS Pregunta, us.RespuestaSeguridad,
		us.Avatar, us.FechaLogin, us.ContadorFallido, us.Estatus, us.FormColor, us.FechaRegistro, us.FechaModificacion
	FROM Usuarios AS us
	INNER JOIN GruposDetalles AS rl ON us.IdRoles = rl.IdGrupoDetalle
	INNER JOIN GruposDetalles AS ps ON  us.IdPreguntaSeguridad = ps.IdGrupoDetalle         
 GO
 --VISTA QUE MUESTRA TODOS LOS USUARIOS CON SUS DATOS PERSONALES
DROP VIEW IF EXISTS vw_Usuarios_Personas;
GO
CREATE VIEW vw_Usuarios_Personas
AS
	SELECT lu.IdUsuario, lu.NombreUsuario, lu.Contrasena, lu.IdRoles, lu.Rol, lu.IdPregunta, lu.Pregunta, lu.RespuestaSeguridad, lu.Avatar, lu.FechaLogin,
			lu.ContadorFallido, lu.Estatus, lu.FormColor, lu.FechaRegistro AS FechaRegistroUsuario, lu.FechaModificacion, lp.IdPersona, lp.Nombres,
			lp.TipoPersona, lp.CiRif, lp.Direccion, lp.Telefonos, lp.Email, lp.FechaRegistro AS FechaRegistroPersona
	FROM vw_ListarUsuarios AS lu
	LEFT JOIN vw_Personas AS lp ON lu.IdUsuario = lp.IdUsuario
GO
--AGREGAR USURAIOS COMPLETOS
IF OBJECT_ID('sp_AgregarUsuarioA') IS NOT NULL
BEGIN 
	DROP PROC sp_AgregarUsuarioA 
END
GO
CREATE PROCEDURE sp_AgregarUsuarioA (
	--DATOS DE USUARIO
	@NombreUsuario VARCHAR(30),      
    @Contrasena VARCHAR(100),      
    @IdPreguntaSeguridad INT,
	@RespuestaSeguridad VARCHAR(50),
	@Avatar VARCHAR(30),
	@IdRoles INT,
	@Estatus BIT,
	@FormColor VARCHAR(20),
	@FechaRegistro DATETIME,
	----DATOS PERSONALES
	@Nombres VARCHAR(50),
	@IdTipoPersona INT,
	@CiRif VARCHAR(11),
	@Direccion VARCHAR(100),
	@Telefonos VARCHAR(60),
	@Email VARCHAR(60)
)
	AS
	BEGIN TRY
		BEGIN TRAN Usuarios
			DECLARE @Id INT
			INSERT INTO Usuarios(NombreUsuario,Contrasena,IdPreguntaSeguridad,RespuestaSeguridad,Avatar,IdRoles,Estatus,FormColor,FechaRegistro) 
				VALUES(@NombreUsuario,@Contrasena,@IdPreguntaSeguridad,@RespuestaSeguridad,@Avatar,@IdRoles,@Estatus,@FormColor,@FechaRegistro)
			SELECT @Id = SCOPE_IDENTITY();
			INSERT INTO Personas(IdUsuario,Nombres,IdTipoPersona,CiRif,Direccion,Telefonos,Email,FechaRegistro) 
				VALUES (@Id,@Nombres,@IdTipoPersona,@CiRif,@Direccion,@Telefonos,@Email,@FechaRegistro)
		COMMIT TRANSACTION Usuarios
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS errNumber,
			   ERROR_SEVERITY() AS errSeverity,
			   ERROR_STATE() AS errState,
			   ERROR_PROCEDURE() AS errProcedure,
			   ERROR_LINE() AS errLine,
			   ERROR_MESSAGE() AS errMessage
		ROLLBACK TRAN Usuarios
	END CATCH
GO

 --PRODUCTOS
DROP VIEW IF EXISTS vw_ListarProductos;
GO
	CREATE VIEW vw_ListarProductos     
	AS
		 SELECT p.IdProducto, p.Sku,p.IdCategoria, gc.Nombre AS Categoria, p.IdGrupo, GP.Nombre AS Grupo, p.Nombre,p.Descripcion,p.IdFabricante, gf.Nombre AS Fabricante,
		 p.IdUnidad,gu.Nombre AS Unidad, p.Imagen,p.Stock,p.StockMin,p.PrecioCompra,p.PrecioVenta,p.Garantia,p.Estatus,p.FechaRegistro
		 FROM ProductoServicios AS p
		 INNER JOIN GruposDetalles AS gc ON p.IdCategoria = gc.IdGrupoDetalle
		 INNER JOIN Grupos AS gp ON p.IdGrupo = GP.IdGrupo
		 INNER JOIN GruposDetalles AS gf ON p.IdFabricante = gf.IdGrupoDetalle
		 INNER JOIN GruposDetalles AS gu ON p.IdUnidad = gu.IdGrupoDetalle
GO
-- REQUERIMIENTOS
DROP VIEW IF EXISTS vw_Requerimientos;
GO
CREATE VIEW vw_Requerimientos AS (
	SELECT rq.IdRequerimiento,rq.Asignado, rq.Presupuestado, rq.IdDepartamento, dt.Nombre AS Departamento, rq.IdEmpleado, em.NombreUsuario AS Empleado, RQ.FechaEntrada, rq.FechaSalida,
			rq.IdCliente, ps.Nombres AS NombreCliente, CONCAT(tp.Nombre, ps.CiRif) AS Cedula,ps.Telefonos, ps.Email, ps.Direccion, eq.IdGrupoDetalle AS IdEquipo, 
			eq.Nombre AS Equipo, mq.IdGrupoDetalle AS IdMarca, mq.Nombre AS Marca, md.IdGrupoDetalle AS IdModelo, md.Nombre AS Modelo, pr.IdGrupoDetalle AS IdPrioridad, 
			pr.Nombre AS Prioridad, rq.Falla, rq.Diagnostico, rq.Solucion, rq.Serial, rq.Observaciones, rq.Accesorios, tc.IdUsuario AS IdTecnico, tc.NombreUsuario AS Tecnico,
			st.IdGrupoDetalle AS IdEstatus, st.Nombre AS Estatus
	FROM Requerimientos AS rq
		INNER JOIN GruposDetalles AS dt ON rq.IdDepartamento = dt.IdGrupoDetalle
		LEFT JOIN Usuarios AS em ON rq.IdEmpleado = em.IdUsuario
		INNER JOIN Personas AS ps ON rq.IdCliente = ps.IdPersona
		INNER JOIN GruposDetalles AS tp ON ps.IdTipoPersona = tp.IdGrupoDetalle
		INNER JOIN GruposDetalles AS eq ON rq.IdEquipo = eq.IdGrupoDetalle
		INNER JOIN GruposDetalles AS mq ON rq.IdMarca = mq.IdGrupoDetalle
		INNER JOIN GruposDetalles AS md ON rq.IdModelo = md.IdGrupoDetalle
		INNER JOIN GruposDetalles AS pr ON rq.IdPrioridad = pr.IdGrupoDetalle
		LEFT JOIN Usuarios AS tc ON rq.IdTecnico = tc.IdUsuario
		LEFT JOIN GruposDetalles AS st ON rq.IdEstatus = st.IdGrupoDetalle
)
GO
DROP VIEW IF EXISTS vw_Bitacora
GO
CREATE VIEW vw_Bitacora AS(
	SELECT bt.IdOxR,bt.IdRequerimiento, bt.IdUsuario, us.NombreUsuario, us.Avatar, bt.Observacion, bt.Leido, bt.FechaRegistro, us.IdRoles, gd.Nombre AS Rol
	FROM Observaciones AS bt
	INNER JOIN Usuarios AS us ON bt.IdUsuario = us.IdUsuario
	INNER JOIN GruposDetalles AS gd ON us.IdRoles = gd.IdGrupoDetalle
)
GO

--VISTA PRESUPUESTOS
DROP VIEW IF EXISTS vw_Presupuestos
GO
CREATE VIEW vw_Presupuestos AS(
	SELECT pt.IdPresupuesto, pt.IdRequerimiento, pt.FechaEmision, pt.FechaVencimiento, pt.IdPoS, ps.Sku, ps.Nombre, ps.Descripcion, pt.Cant, 
	pt.PrecioUnit, pt.SubTotal,pt.Iva, pt.IdEstatus, pt.IdUsuario
	FROM Presupuestos AS pt
		INNER JOIN ProductoServicios AS ps ON pt.IdPoS = ps.IdProducto
)
GO





--DROP PROCEDURE IF EXISTS sp_BuscarProducto;
--GO   
--CREATE PROCEDURE sp_BuscarProducto
-- (      
--    @IdProducto INT      
-- )      
-- AS      
-- BEGIN       
--    WITH Cte_Productos(IdGrupoDetalle,Nombre,Descripcion,Orden,IdGrupo,IdPadre,Icono,UrlDetalle,Estatus,FechaRegistro, LevelGrupo) AS (
--		SELECT g.IdGrupoDetalle, g.Nombre, g.Descripcion, g.Orden, g.IdGrupo, g.IdPadre, g.Icono, g.UrlDetalle, g.Estatus, g.FechaRegistro, 0 AS LevelGrupo
--		FROM GruposDetalles AS g
--		WHERE g.IdPadre is null
--		UNION ALL
--		SELECT gd.IdGrupoDetalle, gd.Nombre, gd.Descripcion, gd.Orden, gd.IdGrupo, gd.IdPadre, gd.Icono, gd.UrlDetalle, gd.Estatus, gd.FechaRegistro, LevelGrupo+1
--		FROM GruposDetalles AS gd
--		INNER JOIN Cte_Productos AS cte ON gd.IdPadre = cte.IdGrupoDetalle
--	)
--	SELECT ct.IdGrupoDetalle AS IdProducto, ps.Sku, ct.Nombre AS Titulo, ct.Descripcion, ct.Orden, ct.IdGrupo, g.Nombre AS Grupo, ct.IdPadre, c.Nombre AS Padre, ct.Icono, ct.UrlDetalle, ct.Estatus, 
--			ps.IdFabricante, gd.Nombre AS Fabricante, ps.Stock, ps.Stock_Min, ps.IdUnidad, ps.Garantia, ps.PrecioCompra, ps.PrecioVenta, ct.FechaRegistro
--	FROM Cte_Productos AS ct
--	INNER JOIN Cte_Productos AS c ON ct.IdPadre = c.IdGrupoDetalle
--	INNER JOIN Grupos AS g ON ct.IdGrupo = g.IdGrupo
--	LEFT JOIN PSDetalles AS ps ON ct.IdGrupoDetalle = ps.IdProducto
--	LEFT JOIN GruposDetalles AS gd ON ps.IdFabricante = gd.IdGrupoDetalle
--	WHERE ct.IdGrupoDetalle = @IdProducto
--	ORDER BY ct.LevelGrupo ASC    
-- END
-- GO

----CRUDL PRODUCTOS
--IF OBJECT_ID('sp_AgregarProducto') IS NOT NULL
--BEGIN 
--	DROP PROC sp_AgregarProducto 
--END
--GO
--CREATE PROCEDURE sp_AgregarProducto (
--	@Nombre VARCHAR(50),      
--    @Descripcion VARCHAR(50),      
--    @Orden INT,
--	@IdGrupo INT,
--	@IdPadre INT,
--	@Icono VARCHAR(30), -- DIRECTORIO DONDE ESTA LA IMAGEN
--	@UrlDetalle VARCHAR(100),
--	@Estatus BIT,
--	@FechaRegistro DATETIME,
--	@Sku VARCHAR(24),
--	@IdFabricante INT,
--	@IdEquipo INT,
--	@Stock INT,
--	@IdUnidad INT,
--	@StockMin INT,
--	@PrecioCompra DECIMAL(8,2),
--	@PrecioVenta DECIMAL(8,2),
--	@Garantia INT
--)
--	AS
--	BEGIN TRY
--		BEGIN TRAN Products
--			DECLARE @Id INT
--			INSERT INTO GruposDetalles VALUES(@Nombre,@Descripcion,@Orden,@IdGrupo,@IdPadre,@Icono,@UrlDetalle,@Estatus,@FechaRegistro)
--			SELECT @Id = SCOPE_IDENTITY();
--			INSERT INTO PSDetalles VALUES (@Id,@Sku,@IdFabricante,@Stock,@IdUnidad,@IdEquipo,@StockMin,@PrecioCompra,@PrecioVenta,@Garantia)
--		COMMIT TRANSACTION Products
--	END TRY
--	BEGIN CATCH
--		SELECT ERROR_NUMBER() AS errNumber,
--			   ERROR_SEVERITY() AS errSeverity,
--			   ERROR_STATE() AS errState,
--			   ERROR_PROCEDURE() AS errProcedure,
--			   ERROR_LINE() AS errLine,
--			   ERROR_MESSAGE() AS errMessage
--		ROLLBACK TRAN Products
--	END CATCH
--GO

--IF OBJECT_ID('sp_ActualizarProducto') IS NOT NULL
--BEGIN 
--	DROP PROC sp_ActualizarProducto 
--END
--GO
--CREATE PROCEDURE sp_ActualizarProducto (
--	@Id INT,
--	@Nombre VARCHAR(50),      
--    @Descripcion VARCHAR(50),      
--    @Orden INT,
--	@IdGrupo INT,
--	@IdPadre INT,
--	@Icono VARCHAR(30), -- DIRECTORIO DONDE ESTA LA IMAGEN
--	@UrlDetalle VARCHAR(100),
--	@Estatus BIT,
--	@Sku VARCHAR(24),
--	@IdFabricante INT,
--	@IdEquipo INT,
--	@Stock INT,
--	@IdUnidad INT,
--	@StockMin INT,
--	@PrecioCompra DECIMAL(8,2),
--	@PrecioVenta DECIMAL(8,2),
--	@Garantia INT
--)	
--	AS
--	BEGIN TRY
--		BEGIN TRAN Products
--			UPDATE GruposDetalles SET
--				Nombre= @Nombre,      
--				Descripcion= @Descripcion,      
--				Orden= @Orden,
--				IdGrupo= @IdGrupo,
--				IdPadre= @IdPadre,
--				Icono= @Icono, -- DIRECTORIO DONDE ESTA LA IMAGEN
--				UrlDetalle= @UrlDetalle,
--				Estatus= @Estatus
--				WHERE IdGrupoDetalle = @Id;
--			UPDATE PSDetalles SET
--				Sku= @Sku,
--				IdFabricante= @IdFabricante,
--				Stock= @Stock,
--				IdUnidad= @IdUnidad,
--				Stock_Min= @StockMin,
--				PrecioCompra= @PrecioCompra,
--				PrecioVenta= @PrecioVenta,
--				Garantia= @Garantia
--				WHERE IdProducto = @Id;
--		COMMIT TRANSACTION Products
--	END TRY
--	BEGIN CATCH
--		SELECT ERROR_NUMBER() AS errNumber,
--			   ERROR_SEVERITY() AS errSeverity,
--			   ERROR_STATE() AS errState,
--			   ERROR_PROCEDURE() AS errProcedure,
--			   ERROR_LINE() AS errLine,
--			   ERROR_MESSAGE() AS errMessage
--			   ROLLBACK TRAN Products
--	END CATCH
--GO

--IF OBJECT_ID('sp_OperacionesInventarioProducto') IS NOT NULL
--BEGIN 
--	DROP PROC sp_OperacionesInventarioProducto 
--END
--GO
--CREATE PROCEDURE sp_OperacionesInventarioProducto (
--	@Id INT,
--	@Operador INT,
--	@Stock INT,
--	@PrecioCompra DECIMAL(8,2),
--	@PrecioVenta DECIMAL(8,2)
--)	
--	AS
--	BEGIN TRY
--		BEGIN TRAN Products
--			IF @Operador = 1
--			UPDATE PSDetalles SET
--				Stock= Stock+@Stock,
--				PrecioCompra= @PrecioCompra,
--				PrecioVenta= @PrecioVenta
--				WHERE IdProducto = @Id;
--			IF @Operador = 2
--			UPDATE PSDetalles SET
--				Stock= Stock-@Stock,
--				PrecioCompra= @PrecioCompra,
--				PrecioVenta= @PrecioVenta
--				WHERE IdProducto = @Id;
--		COMMIT TRANSACTION Products
--	END TRY
--	BEGIN CATCH
--		SELECT ERROR_NUMBER() AS errNumber,
--			   ERROR_SEVERITY() AS errSeverity,
--			   ERROR_STATE() AS errState,
--			   ERROR_PROCEDURE() AS errProcedure,
--			   ERROR_LINE() AS errLine,
--			   ERROR_MESSAGE() AS errMessage
--			   ROLLBACK TRAN Products
--	END CATCH
--GO