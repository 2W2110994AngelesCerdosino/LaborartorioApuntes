--use libreria
--set dateformat dmy

select * from clientes c left join facturas f on c.cod_cliente=f.cod_cliente
where year(fecha)=year(getdate())

select distinct c.cod_cliente, fecha from clientes c join facturas f on f.cod_cliente=c.cod_cliente
and c.cod_cliente in (select cod_cliente from facturas where year(fecha)=year(getdate()))

select * from clientes
where cod_cliente in (select cod_cliente from facturas where year(fecha)=year(getdate()))

select distinct *from facturas where year(fecha)=year(getdate())

-- IN listar los clientes que no vinieron el año pasadoselect * from clientes
where cod_cliente not in (select cod_cliente from facturas where year(fecha)=year(getdate())-1)

--EXISTS : lista los datos de los clientes que compraron este año
select * from clientes c
where exists (select cod_cliente from facturas f where c.cod_cliente=f.cod_cliente and year(fecha)=year(getdate()))

---EXISTS : lista los datos de los clientes que no compraron el año pasado

select * from clientes c where not exists (select cod_cliente from facturas f where f.cod_cliente=c.cod_cliente and year(fecha)=year(getdate())-1)

 --ANY: listar los clientes que alguna vez compraron un producto menor a $ 10.-
 select * from clientes c
 where 10 > any (select pre_unitario from detalle_facturas d join facturas f on f.nro_factura=d.nro_factura
								 where c.cod_cliente=f.cod_cliente)

--ALL: se quiere listar todos los clientes que siempre fueron atendidos por el vendedor 3:
select * from clientes c
where 3=all (select cod_vendedor from facturas f where c.cod_cliente=f.cod_cliente)


--listar los vendedores con sus ventas totales agrupado por vendedor y como condición es
--que su venta total (en el having) sea superior al resultado de una
--subconsulta que calcule el promedio general de ventas.select v.nom_vendedor,	   sum(cantidad*pre_unitario) 'total ventas' from vendedores v join facturas f on v.cod_vendedor=f.cod_vendedor join detalle_facturas d on f.nro_factura=d.nro_factura	   group by v.nom_vendedor	   having sum(cantidad*pre_unitario) > (select avg(pre_unitario*cantidad) from detalle_facturas)--subconsulta como parte de una expresión, se quiere listar el precio de los artículos y la diferencia de
--éste con el precio del artículo más caro:select descripcion, pre_unitario,
 (select max(pre_unitario)from articulos) - pre_unitario 'diferencia'
from articulos

 --una subconsulta en una columna por ejemplo: listar el precio actual de los artículos y el precio
--histórico vendido más barato:
select descripcion, pre_unitario 'precio actual',
 (select min(pre_unitario)from detalle_facturas d
 where d.cod_articulo=a.cod_articulo) 'precio historico'
from articulos a

--Guía de Ejercicios N 10 – Subconsultas en el HAVING
--1. Se quiere saber ¿cuándo realizó su primer venta cada vendedor? y ¿cuánto fue el importe total de
--las ventas que ha realizado? Mostrar estos datos en un listado solo para los casos en que su
--importe promedio de vendido sea superior al importe promedio general (importe promedio de todas
--las facturas).
select v.nom_vendedor,
	   min(fecha) 'primer vta',
	   sum(pre_unitario*cantidad) 'importe total'
from facturas f join detalle_facturas d on f.nro_factura=d.nro_factura join vendedores v on f.cod_vendedor=v.cod_vendedor
group by v.nom_vendedor
having sum(pre_unitario*cantidad) >(select avg(pre_unitario*cantidad) from detalle_facturas)

--2. Liste los montos totales mensuales facturados por cliente y además del promedio de ese monto y la
--el promedio de precio de artículos Todos esto datos correspondientes a período que va desde el 1°
--de febrero al 30 de agosto del 2014. Sólo muestre los datos si esos montos totales sea superior o
--igual al promedio global.
select c.nom_cliente'cliente',
	   month(fecha) 'mes',
	   sum(d.pre_unitario*cantidad) 'monto total',
	   avg(d.pre_unitario*cantidad) 'promedio de monto',
	   avg(a.pre_unitario) 'promedio de precio de art'
from facturas f, detalle_facturas d, clientes c, articulos a
where f.nro_factura=d.nro_factura
and f.cod_cliente=c.cod_cliente
and d.cod_articulo=a.cod_articulo
and year(fecha) = 2014
group by nom_cliente, month(fecha)
having sum(d.pre_unitario*cantidad) >= (select avg(pre_unitario*cantidad) from detalle_facturas)

--3. Por cada artículo que se tiene a la venta, se quiere saber el importe promedio vendido, la cantidad
--total vendida por artículo, para los casos en que los números de factura no sean uno de los
--siguientes: 2, 10, 7, 13, 22 y que ese importe promedio sea inferior al importe promedio de ese
--artículo.
select a.cod_articulo, descripcion, f.nro_factura,
	   avg(d.pre_unitario*cantidad) 'importe promedio vendido',
	   sum(cantidad) 'cant vd por articulo'
from detalle_facturas d, facturas f, articulos a
where d.nro_factura=f.nro_factura 
and d.cod_articulo=a.cod_articulo
and f.nro_factura not in (2,10,7,13,22)
group by a.cod_articulo, descripcion, f.nro_factura
having avg(d.pre_unitario*cantidad) < (select avg(pre_unitario*cantidad) from detalle_facturas f1 where f1.cod_articulo=a.cod_articulo)


select * from articulos

--4. Listar la cantidad total vendida, el importe y promedio vendido por fecha, siempre que esa cantidad
--sea superior al promedio de la cantidad global. Rotule y ordene.
select f.fecha,
	   sum(cantidad) 'cantidad total vendida',
	   avg(pre_unitario) 'prom vendido por fecha',
	   sum(pre_unitario*cantidad) 'importe total'
from detalle_facturas d, facturas f
where d.nro_factura=f.nro_factura
group by fecha
having sum(cantidad)>(select avg(cantidad)from detalle_facturas)

--5. Se quiere saber el promedio del importe vendido y la fecha de la primer venta por fecha y artículo
--para los casos en que las cantidades vendidas oscilen entre 5 y 20 y que ese importe sea superior al
--importe promedio de ese artículo.
select a.cod_articulo,
       cantidad, 
	   descripcion,
       min(fecha) '1er vta',
	   avg(d.pre_unitario*cantidad) 'promedio del imp vendido'
from detalle_facturas d, facturas f, articulos a
where f.nro_factura=d.nro_factura 
and d.cod_articulo=a.cod_articulo
and cantidad between 5 and 20
group by a.cod_articulo, cantidad, descripcion
having sum(d.pre_unitario*cantidad) >(select avg(pre_unitario*cantidad) from detalle_facturas f1 where f1.cod_articulo=a.cod_articulo)


--6. Emita un listado con los montos diarios facturados que sean inferior al importe promedio general.
select fecha 'dia',
	   sum(d.pre_unitario*cantidad) 'montos diarios facturados'
	   from facturas f, detalle_facturas d
where f.nro_factura=d.nro_factura
group by fecha
having sum(d.pre_unitario*cantidad) < (select sum(pre_unitario*cantidad) from detalle_facturas)
order by 1

--7. Se quiere saber la fecha de la primera y última venta, el importe total facturado por cliente para los
--años que oscilen entre el 2007 y 2010 y que el importe promedio facturado sea menor que el
--importe promedio total para ese cliente.
select f.nro_factura,
	   c.cod_cliente,
	   nom_cliente,
	   min(fecha) '1er vta',
       max(fecha) 'Zma vta',
	   sum(pre_unitario*cantidad) 'importe tt fact'
from facturas f, detalle_facturas d, clientes c
where f.nro_factura=d.nro_factura
and c.cod_cliente=f.cod_cliente
and year(fecha) between 2007 and 2010
group by  f.nro_factura, c.cod_cliente, nom_cliente
having avg(d.pre_unitario*cantidad) < (select avg(pre_unitario*cantidad) from detalle_facturas d1, facturas f1 where d1.nro_factura=f1.nro_factura and f1.cod_cliente=c.cod_cliente)

--8. Realice un informe que muestre cuánto fue el total anual facturado por cada vendedor, para los
--casos en que el nombre de vendedor no comience con ‘B’ ni con ‘M’, que los nros. de facturas
--oscilen entre 5 y 25 y que el promedio del monto facturado sea inferior al promedio de ese año
select f.nro_factura, v.cod_vendedor, v.nom_vendedor, f.fecha,
		year(f.fecha) 'año',
		sum(pre_unitario*cantidad) 'imp tt facturado'
from detalle_facturas d, facturas f, vendedores v
where d.nro_factura=f.nro_factura
and f.cod_vendedor=v.cod_vendedor
and nom_vendedor not like 'm%'
and f.nro_factura between 5 and 25
group by f.nro_factura, v.cod_vendedor, v.nom_vendedor, f.fecha
having avg(d.pre_unitario*cantidad) > (select avg(pre_unitario*cantidad) from detalle_facturas d1, facturas f1 where d1.nro_factura=f1.nro_factura and year(f1.fecha)=year(f.fecha))
	

--Guía de Ejercicios N 9 – Subconsultas en el WHERE
--1. Emitir un listado de los artículos que no fueron vendidos este año. En ese listado solo incluir
--aquellos cuyo precio unitario del artículo oscile entre 20 y 50.
select f.nro_factura, f.fecha, a.cod_articulo, a.descripcion
from detalle_facturas d join articulos a on d.cod_articulo=a.cod_articulo join facturas f on f.nro_factura=d.nro_factura
where a.cod_articulo not in 
(select distinct cod_articulo from detalle_facturas d1 join facturas f1 on d1.nro_factura=f1.nro_factura where year(fecha)=year(getdate())-1)


--2. Genere un reporte con los clientes que vinieron más de 2 veces el año pasado.
select c.cod_cliente, f.fecha
from clientes c  join facturas f on c.cod_cliente=f.cod_cliente where year(fecha)=year(getdate())-1
and 2 < all (select count(*) cod_cliente from facturas )


--3. Se quiere saber qué clientes no vinieron entre el 12/12/2007 y el 13/7/2010.
select c.cod_cliente, f.fecha
from clientes c join facturas f on c.cod_cliente=f.cod_cliente
where c.cod_cliente not in (select c.cod_cliente from facturas f1 where f1.fecha between '2007/12/12' and '2010/13/07')


--4. Liste los datos de las facturas de los clientes que solo vienen a comprar en febrero es decir que
--todas las veces que vino a comprar haya sido en el mes de febrero (y no otro mes).
select * from clientes c
where cod_cliente in(select cod_cliente from facturas where month(fecha) in (02))

--5. Muestre los datos de las facturas para los casos en que por año se hayan hecho menos de 9
--facturas.
select * from facturas f
where 9>(select count(*) from facturas f1 where year(f.fecha)=year(f1.fecha))

--6. Emita un reporte con las facturas cuyo importe total haya sido superior a 300 (incluya en el reporte
--los datos de los artículos vendidos y los importes).
select f.nro_factura, fecha, d.pre_unitario, descripcion, d.pre_unitario*cantidad importe
from facturas f join detalle_facturas d on f.nro_factura=d.nro_factura
				join articulos a on d.cod_articulo=a.cod_articulo
where 300 < (select sum(pre_unitario*cantidad) from detalle_facturas d1 where d1.nro_factura=f.nro_factura)

--7. Se quiere saber qué vendedores nunca atendieron a estos clientes: 1 y 6. Muestre solamente el
--nombre del vendedor.
--8. Listar los datos de los artículos que superaron el promedio del Importe de ventas de $ 200.
--9. Que artículos nunca se vendieron? Tenga además en cuenta que su nombre comience con letras
--que van de la “d” a la “p”. Muestre solamente la descripción de artículo.
--10. Liste número de factura, fecha y cliente para los casos en que ese cliente haya sido atendido alguna
--vez por el vendedor de código 3.
--
--11. Listar número de factura, fecha, artículo, cantidad e importe para los casos en que todas las
--cantidades (de unidades vendidas de cada artículo) de esa factura sean superiores a 40.
--12. Emitir un listado que muestre número de factura, fecha, artículo, cantidad e importe; para los casos
--en que la cantidad total de unidades vendidas sean superior a 80.
--13. Liste número de factura, fecha, cliente, artículo e importe para los casos en que alguno de los
--importes de esa factura sean menores a 100. 