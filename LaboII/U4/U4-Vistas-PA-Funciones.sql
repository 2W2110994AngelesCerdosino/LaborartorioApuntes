use LIBRERIA


--Vistas
--1. Cree las siguientes vistas:
--a. LEGAJO-Detalle_Ventas_Vendedor: Liste la fecha, la factura, el codigo y nombre del
--vendedor, el articulo, la cantidad e importe, para lo que va del año. Rotule como FECHA,
--NRO_FACTURA, CODIGO_VENDEDOR, NOMBRE_VENDEDOR, ARTICULO,
--CANTIDAD, IMPORTE.
alter view L110994_Detalle_Ventas_Vendedor as
select f.fecha 'Fecha', 
       f.nro_factura 'nro factura', 
	   v.cod_vendedor 'cod_vendedor',
	   v.nom_vendedor 'vendedor',
	   v.ape_vendedor 'apellido',
	   a.descripcion 'articulo', 
	   df.cantidad 'cantidad', 
	   (cantidad*df.pre_unitario) 'importe'
from detalle_facturas df join facturas f on df.nro_factura =f.nro_factura
						 join vendedores v on v.cod_vendedor=f.cod_vendedor
						 join articulos a on a.cod_articulo=df.cod_articulo
where year(fecha)=year(getdate())
  
select * from L110994_Detalle_Ventas_Vendedor


--b. LEGAJO-Subtotales_Ventas_Vendedor: Se quiere saber el importe vendido y la
--cantidad de ventas por vendedor. Rotule como VENDEDOR, IMPORTE_VENDIDO,
--CANTIDAD_VENDIDA.

alter view Subtotales_ventas_vendedor as
select v.nom_vendedor 'vendedor',
	   v.ape_vendedor 'apellido vendedor',
	   sum(df.cantidad*df.pre_unitario) 'importe vendido',
	   count(df.cantidad) 'cantidad vendida'
from facturas f join vendedores v on f.cod_vendedor=v.cod_vendedor
				join detalle_facturas df on f.nro_factura=f.nro_factura
group by v.nom_vendedor, v.ape_vendedor

select * from Subtotales_ventas_vendedor

--2. Modifique las vistas según el siguientes detalle:
--a. La vista creada en el punto b, agréguele la condición de que solo tome lo del año en
--curso y que también muestre el promedio vendido y el código del vendedor.
alter view Subtotales_ventas_vendedor as
select v.nom_vendedor 'vendedor',
	   v.ape_vendedor 'apellido vendedor',
	   v.cod_vendedor 'cod_vendedor',
	   sum(cantidad*df.pre_unitario) 'importe vendido',
	   count(*) 'cantidad vendida',
	   avg(cantidad*df.pre_unitario) 'promedio vendido'
from facturas f join vendedores v on f.cod_vendedor=v.cod_vendedor
				join detalle_facturas df on f.nro_factura=df.nro_factura
where year(fecha)=year(getdate())
group by v.nom_vendedor, v.ape_vendedor, v.cod_vendedor

select * from Subtotales_ventas_vendedor

--3. Consulta las vistas según el siguiente detalle:
--a. Llame a la vista creada en el punto 1.a pero filtrando por importes inferiores a $12.
select * from L110994_Detalle_Ventas_Vendedor
where importe > 12

--b. Llame a la vista creada en el punto 1.b filtrando para el vendedor Hernandez.
select * from L110994_Detalle_Ventas_Vendedor
where apellido like 'Zanguango'

--c. Llama a la vista creada en el punto 1.b filtrando para promedios superiores a 100.
select * from L110994_Detalle_Ventas_Vendedor
where importe > 100

--4. Elimine las vistas creadas en el punto 1 (no se olvide de colocar el nombre como corresponde)
drop view L110994_Detalle_Ventas_Vendedor



--Procedimientos Almacenados
--propios del sistema son:
sp_databases
sp_columns clientes --muestra la columnas de esa tabla
sp_column_privileges clientes
sp_server_info
sp_fkeys articulos
sp_pkeys articulos

--1. Cree los siguientes SP:
--a. LEGAJO-Detalle_Ventas: liste la fecha, la factura, el vendedor, el cliente, el artículo,
--cantidad e importe. Este SP recibirá como parámetros de E un rango de fechas.
alter procedure L110994_Detalle_Ventas
@fecha1 datetime,
@fecha2 datetime
as
select f.fecha 'fecha',
	   f.nro_factura 'nro factura',
	   v.nom_vendedor 'vendedor',
	   c.nom_cliente 'cliente',
	   a.descripcion 'articulo',
	   count(cantidad) 'cantidad',
	   sum(df.pre_unitario*cantidad) 'importe'
from facturas f join detalle_facturas df on f.nro_factura=df.nro_factura 
				join vendedores v on f.cod_vendedor=v.cod_vendedor
				join articulos a on a.cod_articulo=df.cod_articulo
				join clientes c on c.cod_cliente=f.cod_cliente
where f.fecha between @fecha1 and @fecha2
group by f.fecha, f.nro_factura, v.nom_vendedor, c.nom_cliente,a.descripcion

exec L110994_Detalle_Ventas '2018-01-01', '2019-01-01'


--b. LEGAJO-CantidadArt_Cli : este SP me debe devolver la cantidad de artículos o
--clientes (según se pida) que existen en la empresa.

create proc L110994_CantidadArt_cli
@parametro varchar (30)
as
if(@parametro='clientes')
begin
select count(*) 'Cant. de Clientes' from clientes
end
else if (@parametro='articulos')
begin
select count(*) 'Cant. de Articulos' from articulos
end;

exec L110994_CantidadArt_cli 'clientes'
exec L110994_CantidadArt_cli 'articulos'



--c. LEGAJO-INS_Vendedor: Cree un SP que le permita insertar registros en la tabla
--vendedores.

--d. LEGAJO-UPD_Vendedor: cree un SP que le permita modificar un vendedor cargado.

--e. LEGAJO-DEL_Vendedor: cree un SP que le permita eliminar un vendedor
--ingresado.

--2. Modifique el SP 1-a, permitiendo que los resultados del SP puedan filtrarse por una fecha
--determinada, por un rango de fechas y por un rango de vendedores; según se pida.

--3. Ejecute los SP creados en el punto 1 (todos).

--4. Elimine los SP creados en el punto 1.

--Implementar un PA que muestre el listado de los articulos y su total vendido

create proc articulosxtotal
as
select a.descripcion 'articulos', count(*) 'cantidad', sum(cantidad*df.pre_unitario) 'importe vendido' 
from articulos a join detalle_facturas df on a.cod_articulo=df.cod_articulo
group by a.descripcion

exec articulosxtotal

select * from articulos
select * from detalle_facturas

if object_id('articulosxtotal') is not null --si existe
begin
drop proc articulosxtotal
end