--use libreria



--select * from clientes
--where nom_cliente not like '^[a-e]%'
--order by nom_cliente


--select * from articulos
--where descripcion like '%junto%'

--select * from vendedores
--where cod_vendedor like '[1-5]'

--delete vendedores where cod_vendedor=1

--update vendedores set nom_vendedor='Carmela', ape_vendedor='Logros' where cod_vendedor=1

--select * from vendedores

--dbcc checkident ('vendedores', reseed, 1)
--go

--insert into vendedores (nom_vendedor,ape_vendedor,calle,altura,cod_barrio,nro_tel,[e-mail], fec_nac) values ('Sandra','Ortega','Pueyrredon',333,5,null,'sandraortega@gmail.com', null)

--select nom_cliente + ' ' + ape_cliente 'Nombre Cliente'
--from clientes

--select distinct cod_articulo, pre_unitario --muestra una sola con su precio, no dos como ocurre sin el distinct
--from detalle_facturas
--order by cod_articulo

--select nro_factura, fecha --listar facturas antes  del 10/7/2008
--from facturas
--where fecha < '10/07/2008'

--select *
--from articulos
--where pre_unitario between 50 and 100

--select cod_cliente, nom_cliente
--from clientes
--where cod_cliente in (1,3,7,8,12)

--select descripcion
--from articulos
--where descripcion like 'l%'

--select *
--from articulos
--where observaciones is null

--select * from articulos where stock_minimo > 100 or pre_unitario>80

--select * from vendedores where nom_vendedor like 'c%' and fec_nac < 1980

--select * from articulos order by 3

--4 Se quiere listar todos los datos de los clientes con nro. de teléfono conocidos. Muestre el nombre y apellido en una
--misma columna. Ordene por nombre completo. Rotule en forma conveniente.
--select * from clientes 
--where nro_tel is not null
--order by nom_cliente

--5 --Se quiere saber el subtotal de todos los artículos vendidos, para ello liste el código y multiplique la cantidad por el precio
--unitario (de la tabla: detalle_facturas). Ordene por código en forma ascendente y subtotal en forma descendente. No
--muestre datos duplicados.
--select distinct cod_articulo, pre_unitario * cantidad subtotal
--from detalle_facturas d
--order by cod_articulo asc, subtotal desc

--6. Muestre el código, nombre, apellido (todo el apellido en mayúsculas) y dirección (calle y altura en una sola columna;
--para la altura utilice una función de conversión) de todos los clientes cuyo nombre comience con “C” y cuyo apellido
--termine con “Z”. Rotule como CÓDIGO DE CLIENTE, NOMBRE, DIRECCIÓN.
--select * from clientes

--select upper (nom_cliente + ' ' + ape_cliente) 'Clientes', calle + ', ' + cast(altura as char) 'Direccion'
--from clientes
--where nom_cliente like 'c%' and ape_cliente like '%z'


--7. Ídem al anterior pero el apellido comience con letras que van de la “D” a la “L” y cuyo nombre no comience con letras
--que van de la “A” a la “G”.

--select upper(nom_cliente + ' ' + ape_cliente) 'Clientes', calle + ', ' + cast(altura as char) 'Direccion'
--from clientes
--where ape_cliente like '[d-l]%' and nom_cliente not like '[a-g]%'

--8. Liste los artículos cuyo precio sea menor a 40 y sin observaciones. Ordene por descripción y precio ambos descendente.
select *
from articulos
where pre_unitario<40 and observaciones is null
order by descripcion desc, pre_unitario desc

--9. Muestre los datos de los vendedores cuyo nombre no contenga “Z” y cuya fecha de nacimiento sea posterior a
--1/1/1970.
select * from vendedores
where nom_vendedor not like '%z%' and fec_nac> '1/1/1970'


--10. Mostrar las facturas realizadas entre el 1/1/2007 y el 1/5/2009 y cuyos códigos de vendedor sean 1, 3 y 4 o bien entre el
--1/1/2010 y el 1/5/2011 y cuyos códigos de vendedor sean 2 y 4.
select * from facturas

select * from facturas
where fecha between '1/1/2007' and '1/5/2009' and cod_vendedor in (1,3,4) 
or fecha between '1/1/2010' and '1/5/2011' and cod_vendedor in (2,4) 

--11. Muestre las ventas (tabla detalle_facturas) de los artículos cuyo precio unitario sea mayor o igual a 10 o cuyos códigos
--de artículos no sea uno de los siguientes: 2,5, 6, 8, 10. En ambos casos que los números de facturas oscilen entre 50 y
--100.
select * from detalle_facturas
where (pre_unitario >= 10 or cod_articulo not in (2,5,6,8,10)) and nro_factura between 50 and 100


--12. Listar todos los datos de los artículos cuyo stock mínimo sea superior a 10 o cuyo precio sea inferior a 20. En ambos
--casos su descripción no debe comenzar con las letras “p” ni la letra “r”.
select * from articulos
where (stock_minimo>10 or pre_unitario<20) and descripcion not like '[p-r]%'

--13. Listar los datos de los vendedores nacidos en febrero, abril, mayo o septiembre
select * from vendedores
where month(fec_nac) in (02,04,05,09)

--14) Listar los datos de los vendedores pero la fecha de nacimiento en
--columnas diferentes día, mes y año. Rotular

select nom_vendedor, ape_vendedor, calle, altura, cod_barrio, nro_tel,[e-mail], day(fec_nac) 'dia', month(fec_nac) 'mes', YEAR(fec_nac) 'año'
from vendedores

--15) Mostrar todos los datos de las facturas realizadas durante el año
--en curso; luego las del año pasado.
select*from facturas
where year(fecha)=GETDATE()

select * from facturas
where year(fecha)=GETDATE()-1

--16.Listar los datos de los clientes: el apellido y nombre en la misma
--columna,separados por 5 espacios y el apellido en mayúscula.

select upper(nom_cliente + '     ' + ape_cliente) 'Clientes' from clientes
-- otra forma de hacerlo
select upper(nom_cliente) + space(5) + upper(ape_cliente) 'Clientes' from clientes

--2. Liste número de factura, fecha de venta y vendedor (apellido y nombre), para los casos en que el código del cliente van
--del 2 al 6. Ordene por vendedor y fecha, ambas en forma descendente.
select nro_factura, f.fecha,nom_vendedor+' '+ape_vendedor
from facturas f, vendedores v
where f.cod_vendedor=v.cod_vendedor
and cod_cliente in (2,3,4,5,6) --o like '[2-6]'
order by nom_vendedor desc, fecha desc

select * from vendedores

--3. Emitir un reporte con los datos de la factura del cliente y del vendedor de aquellas facturas confeccionadas entre el
--primero de febrero del 2008 y el primero de marzo del 2010 y que el apellido del cliente no contenga “C”.

select f.nro_factura,f.fecha, c.ape_cliente, f.cod_vendedor
from facturas f, clientes c, vendedores v
where f.cod_cliente=c.cod_cliente
and f.cod_vendedor=v.cod_vendedor
and fecha between '1/2/2008' and '1/3/2010' and ape_cliente not like '%c%'

--4. Listar los datos de la factura, los del artículo y el importe (precio por cantidad); para las facturas emitidas en el 2009,
--2010 y 2012 y la descripción no comience con “R”. Ordene por número de factura e importe, este en forma
--descendente. Rotule.
select f.nro_factura, f.fecha, a.descripcion, stock_minimo, d.pre_unitario*d.cantidad 'importe'
 from facturas f, articulos a, detalle_facturas d
 where f.nro_factura = d.nro_factura
 and d.cod_articulo = a.cod_articulo
 and year(fecha) in (2009,2010,2012)
 and descripcion not like 'r%'
 order by f.nro_factura, importe desc 


--5. Se quiere saber qué artículos se vendieron, siempre que el precio al que fue vendido no esté entre $10 y $50. Rotule
--como: Código de Artículo, Descripción, Cantidad e Importe (El importe es el precio por la cantidad). 
select a.cod_articulo 'cod.articulo', a.descripcion 'descripcion', d.cantidad 'cantidad',d.pre_unitario 'precio', d.pre_unitario*cantidad 'importe' from detalle_facturas d, articulos a
where d.cod_articulo=a.cod_articulo
and d.pre_unitario*cantidad not between 10 and 50



--6. Liste todos los datos de la factura (vendedor, cliente, artículo, incluidos los datos de la venta); emitidas a clientes con
--teléfonos o direcciones de e-mail conocidas de aquellas facturas cuyo importe haya sido superior a $250. Agregue
--rótulos presentación y ordene el listado para darle mejor presentación.
select f.nro_factura, f.fecha, c.nom_cliente, a.descripcion, v.nom_vendedor, d.pre_unitario, d.cantidad, d.pre_unitario*d.cantidad importe
from facturas f, detalle_facturas d, clientes c, vendedores v, articulos a
where f.nro_factura=d.nro_factura
and f.cod_cliente=c.cod_cliente
and f.cod_vendedor=v.cod_vendedor
and d.cod_articulo=a.cod_articulo
and (c.[e-mail] is not null or c.nro_tel is not null) and d.pre_unitario*d.cantidad > 250
order by 1


--7. Se quiere saber a qué cliente, de qué barrio, vendedor y en qué fecha se les vendió con los siguientes nros. de factura:
--12, 18, 1, 3, 35, 26 y 29.
select c.cod_cliente, c.nom_cliente, b.barrio, v.cod_vendedor, v.nom_vendedor, f.fecha 
from clientes c, barrios b, facturas f, vendedores v
where c.cod_cliente = f.cod_cliente
and b.cod_barrio = c.cod_barrio
and f.cod_vendedor=v.cod_vendedor
and f.nro_factura in (12,18,1,3,35,26,29) 


select * from facturas

--8. Emitir un reporte para informar qué artículos se vendieron, en las facturas cuyos números no esté entre 17 y 136. Liste la
--descripción, cantidad e importe. Ordene por descripción y cantidad. No muestre las filas con valores duplicados

select distinct a.descripcion, d.cantidad, d.pre_unitario*d.cantidad importe --hacerlo asi muestra los mismos resultados obtenidos en el word
from facturas f, detalle_facturas d, articulos a
where f.nro_factura=d.nro_factura
and d.cod_articulo=a.cod_articulo
and f.nro_factura not like '[17-136]'
order by a.descripcion, d.cantidad


--9. Listar los datos de las facturas (cliente, artículo, incluidos los datos de la venta incluido el importe) emitidas a los clientes
--cuyos apellidos comiencen con letras que van de la “l” a “s” o los artículos vendidos que tengan descripciones que
--comiencen con las mismas letras. Ordenar el listado.
select f.nro_factura, c.nom_cliente, a.descripcion, d.pre_unitario*d.cantidad importe
from facturas f, clientes c, articulos a, detalle_facturas d
where f.nro_factura=d.nro_factura
and f.cod_cliente=c.cod_cliente
and d.cod_articulo=a.cod_articulo
and (c.ape_cliente like '[l-s]%'
or a.descripcion like '[l-s]%')
order by 1

--10. Realizar un reporte de los artículos que se vendieron en lo que va del año. (Muestre los datos que sean significativos
--para el usuario del sistema usando rótulos para que sea más legible y que los artículos no se muestren repetidos).
select distinct a.descripcion 'descripcion', f.fecha, d.pre_unitario 'precio', d.cantidad 'cantidad', d.pre_unitario*d.cantidad 'importe'
from facturas f, detalle_facturas d, articulos a
where f.nro_factura=d.nro_factura
and d.cod_articulo=a.cod_articulo
and year(fecha)= year (getdate()) --en lo que va de ese año q marca year(fecha)

select * from detalle_facturas


--11. Se quiere saber a qué clientes se les vendió el año pasado, qué vendedor le realizó la venta, y qué artículos compró,
--siempre que el vendedor que les vendió sea menor de 35 años.
select a.descripcion 'articulo comprado', c.nom_cliente 'cliente', v.nom_vendedor 'vendedor',  (year(GETDATE())-year(v.fec_nac)) 'edad' --listo la edad dentro de una columna con calculo
from facturas f, clientes c, vendedores v, detalle_facturas d, articulos a
where f.cod_cliente=c.cod_cliente
and f.cod_vendedor=v.cod_vendedor
and f.nro_factura=d.nro_factura
and d.cod_articulo=a.cod_articulo
and year(f.fecha)=(year(GETDATE())-1) --para obtener la f.fecha del año pasado
and (year(getdate())-year(v.fec_nac))>35 --calcula el año de hoy menos el año del vendedor.fecha de nacimiento > 35

select * from facturas


--12. El usuario de este sistema necesita ver el listado de facturas, de aquellos artículos cuyos precios unitarios a los que
--fueron vendidos estén entre 50 y 100 y de aquellos vendedores cuyo apellido no comience con letras que van de la “l” a
--la “m”. Ordenado por vendedor, fecha e importe.
select f.fecha, f.nro_factura, a.descripcion, a.pre_unitario, v.ape_vendedor, d.pre_unitario*d.cantidad importe
from facturas f, articulos a, vendedores v, detalle_facturas d
where f.nro_factura=d.nro_factura
and d.cod_articulo=a.cod_articulo
and f.cod_vendedor=v.cod_vendedor
and d.pre_unitario between 50 and 100
and v.ape_vendedor not like '[l-m]%'
order by v.ape_vendedor,f.fecha, importe



--13. Se desea emitir un listado de clientes que compraron en enero, además saber qué compraron cuánto gastaron (mostrar
--los datos en forma conveniente)
select f.nro_factura, f.fecha, c.nom_cliente, a.descripcion, d.pre_unitario, d.cantidad, d.pre_unitario*cantidad importe
from facturas f, detalle_facturas d, clientes c, articulos a
where f.nro_factura=d.nro_factura
and f.cod_cliente=c.cod_cliente
and d.cod_articulo=a.cod_articulo
and (month(f.fecha)=01)


--14. Emitir un reporte de artículos vendidos en el 2010 a qué precios se vendieron y qué precio tienen hoy.
select f.fecha, a.descripcion, a.pre_unitario 'precio actual', d.pre_unitario 'precio de venta'
from articulos a, detalle_facturas d, facturas f
where a.cod_articulo=d.cod_articulo
and f.nro_factura=d.nro_factura
and year(f.fecha)=2010


--15. Listar los vendedores que hace 10 años le vendieron a clientes cuyos nombres o apellidos comienzan con "C"

select f.fecha, v.nom_vendedor, c.nom_cliente + ' ' + c.ape_cliente
from facturas f, vendedores v, clientes c
where f.cod_cliente=c.cod_cliente
and f.cod_vendedor=v.cod_vendedor
and YEAR(F.FECHA) = year(getdate()) - 10
and (c.nom_cliente like 'c%' or c.ape_cliente like '%c')

select * from facturas 
where year(fecha) in (2010) --ver las facturas del año 2010

--16. El encargado de la librería necesita tener información sobre los artículos que se vendían a menos de $ 10 antes del 2015.
--Mostrar los datos que se consideren relevantes para el encargado, rotular y ordenar.

select f.nro_factura, f.fecha, d.cantidad, d.pre_unitario, a.cod_articulo
from facturas f, detalle_facturas d, articulos a
where f.nro_factura=d.nro_factura
and d.cod_articulo=a.cod_articulo
and d.pre_unitario<10 and year(f.fecha) < 2015
order by 1
