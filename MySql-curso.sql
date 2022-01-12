create table cargo(
pk_id int(11) not null auto_increment,
nombre varchar(25),
primary key (pk_id)
)engine=innodb;

insert into cargo(nombre) values('Jefe');
insert into cargo(nombre) values('Gerente');

create table persona(
pk_id int(11) not null auto_increment,
dni varchar(8),
nombre varchar(25),
edad int(3),
fk_cargo int(11),
primary key (pk_id),
foreign key (fk_cargo) references cargo (pk_id)
)engine=innodb;

--insert into persona values(1,'12345678','Linux',22);

insert into persona(dni,nombre,edad) values ('11223344','Tux',25);
insert into persona(dni,nombre,edad,fk_cargo) values ('87654321','Admin',17,4);
insert into persona(dni,nombre,edad,fk_cargo) values ('000412','Admin02',19,4);
select * from persona;

select nombre from persona;

-- Eliminar Tabla:

drop table persona;

-- Inner join.

select p.nombre,p.dni,c.nombre from persona p inner join cargo c on p.fk_cargo=c.pk_id

-- Left Join    
select p.nombre as persona,p.dni as identificacion,c.nombre as 'nombre cargo' from persona p left join cargo c on p.fk_cargo=c.pk_id




select 
insert
update
delete 

update persona set nombre='Debian',dni='123',fk_cargo=1 where pk_id=1;

delete from persona where pk_id=1;

delete from persona;




create table ingreso_planta(
pk_id int(11) not null auto_increment,
nombre_puerta varchar(25),
dia_ingreso date,
hora_ingreso datetime,
fk_persona int(11) not null,
primary key (pk_id),
foreign key (fk_persona) references persona(pk_id)
)engine=innodb;


insert into ingreso_planta values(1,'Puerta 01',curdate(),now(),11);
insert into ingreso_planta values(2,'Puerta 01',curdate(),now(),12);

insert into ingreso_planta values(3,'Puerta 01',curdate(),now(),12);
insert into ingreso_planta values(4,'Puerta 01',curdate(),now(),12);
insert into ingreso_planta values(5,'Puerta 01',curdate(),now(),12);





delimiter //
create function contar_registros()
returns integer
begin
declare resultado int;

select count(pk_id) into resultado  from ingreso_planta where dia_ingreso=curdate();
return  resultado;
end//
delimiter ;




delimiter //
create procedure filtro(IN f_inicio date, IN f_fin date)
begin
select * from ingreso_planta where dia_ingreso between  f_inicio and f_fin ;
end//
delimiter ;


-- Llamando al Stored procedure :  call filtro('2020-10-01','2020-10-03');




alter table ingreso_planta add column dia_semana varchar(15) after hora_ingreso;


delimiter //
create trigger inserta_dia_semana
before insert on ingreso_planta 
for each row
begin
declare dia_insertar varchar(15);
select dayname(curdate()) into dia_insertar;
set new.dia_semana = dia_insertar;
end//

delimiter ;




insert into ingreso_planta(nombre_puerta,dia_ingreso,hora_ingreso,fk_persona) values('Puerta 02',curdate(),now(),11);

insert into ingreso_planta(nombre_puerta,dia_ingreso,hora_ingreso,fk_persona) values('Puerta 02',curdate(),now(),11);
insert into ingreso_planta(nombre_puerta,dia_ingreso,hora_ingreso,fk_persona) values('Puerta 02',curdate(),now(),12);





/*

create table cargo(
pk_id int(11) not null auto_increment,
nombre varchar(25),
primary key (pk_id)
)engine=innodb;

create table persona(
pk_id int(11) not null auto_increment,
dni varchar(8),
nombre varchar(25),
edad int(3),
fk_cargo int(11),
primary key (pk_id),
foreign key (fk_cargo) references cargo (pk_id)
)engine=innodb;

create table ingreso_planta(
pk_id int(11) not null auto_increment,
nombre_puerta varchar(25),
dia_ingreso date,
hora_ingreso datetime,
fk_persona int(11) not null,
primary key (pk_id),
foreign key (fk_persona) references persona(pk_id)
)engine=innodb;

alter table ingreso_planta add column dia_semana varchar(15) after hora_ingreso;

*/



create view reporte as (
select per.nombre as persona ,per.dni as documento, car.nombre as cargo,ip.nombre_puerta as puerta,ip.dia_semana as dia,ip.hora_ingreso as hora from persona per inner join cargo car on per.fk_cargo = car.pk_id
inner join  ingreso_planta ip on ip.fk_persona = per.pk_id
);

select per.nombre,per.dni, car.nombre,ip.nombre_puerta,ip.dia_semana,ip.hora_ingreso from persona per inner join cargo car on per.fk_cargo = car.pk_id
inner join  ingreso_planta ip on ip.fk_persona = per.pk_id









delimiter //
create procedure convertir_fechas()
begin
declare x int(11);
declare id_ int(11);
declare dia_ date;
declare err_no_more_records condition for 1329;
declare c cursor for 
select pk_id,dia_ingreso from ingreso_planta where isnull(dia_semana);
declare exit handler for err_no_more_records
begin
end;

open c;
set x = 0;
size: loop
fetch c into id_,dia_;
update ingreso_planta set dia_semana = concat('N° ',x,' ',dayname(dia_)) where 
pk_id=id_;
set x=x+1;
end loop size;
close c;


end//
delimiter ;
















