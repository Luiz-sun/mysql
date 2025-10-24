create database carro_pessoa;

use carro_pessoa;

create table pessoa(
idPessoa int unsigned not null auto_increment primary key,
nome varchar (20),
telefone varchar (30),
enderaco varchar(200),
bairro varchar (50),
idEstado int(100),
cep int(100)
) engine = InnoDB; 

create table carro (
idCarro int unsigned not null auto_increment primary key,
marca varchar(50),
modelo varchar(50),
cor varchar (10),
placa varchar (10),
chassi varchar (20)
)engine = InnoDB;

drop table pessoa;
alter table carro add column fk_pessoa varchar(20),  foreign key (fk_pessoa) references pessoa (idPessoa ) ON Delete restrict;