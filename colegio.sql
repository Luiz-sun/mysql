create database colegio;
use colegio;

-- criação tabela aluno

create table aluno(
id_aluno int unsigned not null auto_increment primary  key,
nome varchar(200),
idade int
) engine = InnoDB;

create table disciplina(
id_disciplina int unsigned not null auto_increment primary  key,
nome varchar(200)
) engine = InnoDB;

create table aluno_disciplina(
fk_aluno int unsigned not null,
fk_disciplina int unsigned not null,
ano int,

foreign key (fk_aluno) references aluno (id_aluno ) ON Delete restrict,
foreign key (fk_disciplina) references disciplina (id_disciplina) On Delete cascade
) engine = InnoDB;

insert into aluno (id_aluno, nome, idade) values (default, 'Bernado', 100);
insert into disciplina (id_disciplina, nome) 
values (default, 'BD2'),
		(default, 'Matemática'),
		(default, 'Portugues'),
        (default, 'Quimica');

select*from aluno;
select*from disciplina;

insert into aluno_disciplina(fk_aluno, fk_disciplina, ano) values (1,1,2025);

select*from aluno_disciplina;

alter table  disciplina add column status int default 0;

delete from aluno where id_aluno  = 1;
delete from disciplina where id_disciplina  = 1;