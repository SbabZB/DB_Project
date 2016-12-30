
delimiter |

drop trigger if exists calcp;
create trigger calcp before insert on cliche
	for each row
	begin
	declare pcm1 decimal(5,2);
	declare pcm2 decimal(5,2);
	set pcm2=0;
	if(not(isnull(new.MF)))then
	select prezzocmq into pcm2 from materiale where ID=new.materiale2;
	end if;
	select prezzocmq into pcm1 from materiale where ID=new.materiale1;
	set new.prezzo= (((new.lunghezza+1)*(new.larghezza+1))*pcm1)+(0.9*((new.lunghezza+1)*(new.larghezza+1))*pcm2);
	end|

drop function if exists metodopag;
create function metodopag (cod int) returns varchar(10)
	begin 
	declare num int; 
	declare num2 int;
	declare pag varchar(10);
	declare dc date;
	select count(*) into num from ordine where cliente=cod; 
	select max(o.datacomm) into dc from ordine as o where o.cliente=cod;
	select count(*) into num2 from ordine where cliente=cod AND EXTRACT(YEAR FROM  dc)=EXTRACT(YEAR FROM DATE_SUB(CURDATE(),INTERVAL 1 MONTH)) AND EXTRACT(MONTH FROM dc)=EXTRACT(MONTH FROM DATE_SUB(CURDATE(),INTERVAL 1 MONTH)); 
	if num = 0 then set pag='consegna';  
	elseif num2 > 2 then set pag='60gg'; 
	else set pag= '30gg';
	end if;
	return pag;
	end |

drop trigger if exists checknew;
create trigger checknew before insert on ordine for each row
	begin
	declare c tinyint(1);
	if(isnull(new.datacomm)) then set new.datacomm=curdate();
	end if;
	if(new.dataconsegna<new.datacomm) then
	set c=0;
	elseif(not(isnull(new.vettore))and not(isnull(new.corriere))) then
	set c=0;
	end if;
	if(not(isnull(new.corriere))and new.data_sped>new.datacomm) then
	set c=0;
	end if;
	if(new.consegnato='si' and isnull(new.dataconsegna)) then 
	set new.dataconsegna=CURDATE();
	end if;
	if (c=0) then
	SIGNAL SQLSTATE VALUE '45000'
	SET MESSAGE_TEXT = '[table:ordine] - inconsistent data';
	end if;
	end |

drop trigger if exists checkupdate;
create trigger checkupdate before update on ordine for each row
	begin
	if(new.consegnato='si' and isnull(new.dataconsegna)) then 
	set new.dataconsegna=CURDATE();
	elseif (new.data_sped<new.datacomm or (isnull(new.corriere) and new.data_sped<>null))then 
	SIGNAL SQLSTATE VALUE '45000'
	SET MESSAGE_TEXT = '[table:ordine] - inconsistent data';
	end if;
	if(new.consegnato='si')
	then set new.impiegato=null;
	end if;
	end |

drop trigger if exists calcps;
create trigger calcps before insert on stampa
	for each row
	begin
	declare pm decimal(6,4);
	declare molt tinyint(1);
	declare pr decimal(5,2);
	set molt=0;
	if(new.colore='si') then
	set molt=1;
	end if;
	select m.prezzocmq into pm from materiale as m where m.ID=new.materiale;
	set pr=(pm*(new.lunghezza+1)*(new.larghezza+1));
	set new.prezzo = ceil(pr *(1+(0.12*molt)));
	end |

drop function if exists saldo;
create function saldo (ordine int) returns decimal(7,2)
	begin
	declare ris decimal (7,2);
	select coalesce(sum(cl.prezzo*cl.quantità),0)+coalesce(sum(s.prezzo*s.copie),0) into ris from (cliche as cl right join ordine as o on o.numero=cl.ordine)
	left join stampa as s on s.ordine=o.numero 
	where o.numero=ordine
	group by o.numero;
	return ris;
	end|

drop procedure if exists Guad_tot;
create procedure Guad_tot (IN g decimal(9,2))
begin 
select year(o.datacomm)as Anno, sum(f.saldo) as Guadagno from Fattura as f join ordine as o on f.numOrdine=o.numero
group by year(o.datacomm)
having sum(f.saldo)>=g;
end|

drop procedure if exists Archivio;
create procedure Archivio (IN dt date)
begin
select o.numero as Num_ordine, o.dataconsegna as Data_Consegna, o.datacomm as Data_commissione, cl.nome as Cliente, c.ID as Clicheid, c.descr as Descr_cliche, s.ID as Stampaid, s.descr as Descr_stampa
from ((ordine as o join cliente as cl on o.cliente= cl.codice)left join cliche as c on c.ordine=o.numero)left join stampa as s on s.ordine=o.numero
where o.datacomm<dt and o.consegnato='si'
group by o.numero
order by o.dataconsegna;
end |

drop function if exists pacchi;
create function pacchi (id_param int) returns int
	begin 
	declare pac int;
	declare l decimal (5,2);
	declare w decimal(5,2);
	declare cp int;
	if(not(isnull(id_param))) then
	select s.lunghezza, s.larghezza, s.copie into w ,l ,cp from stampa as s where s.ID= id_param;
	if(l*w>=7000) then 
	set pac = cp;
	else
	set pac= ceiling ((cp/(1500/(l*w)))/500);
	end if;
	end if;
	if(isnull(pac)) then set pac=0;
	end if;
	return pac;
	end|

delimiter ;

drop view if exists Fattura;
create view Fattura(numOrdine, cliente, cod_cliente, saldo, saldo_ivato , pagamento) as
	select o.numero, c.nome, c.codice, saldo(o.numero), saldo (o.numero)*1.22,metodopag(c.codice)
	from (((ordine as o join cliente as c on o.cliente=c.codice) left join cliche as cl on cl.ordine=o.numero) left join stampa as s on s.ordine=o.numero)
	where o.consegnato='no'
	group by o.numero;

drop view if exists spedizioni_odierne;
create view spedizioni_odierne (Corriere,Telefono,colli)as 
	select corr.nome, corr.telefono, (coalesce(sum(c.quantità),0))+(coalesce(sum(p.num_pacchi),0))
	from ((ordine as o left join cliche as c on c.ordine=o.numero)left join pack as p on o.numero =p.ordine) left join corriere as corr on o.corriere=corr.nome 
	where data_sped=CURDATE()
	group by corr.nome;

drop view if exists ClicheMagnesio;
create view ClicheMagnesio (cliche,dimensione,descr,ordine,cliente,impiegato) as 
	select c.ID, concat(c.lunghezza,' x ',c.larghezza), c.descr, o.numero, cl.nome ,concat(i.cognome,' ',i.nome)
	from ((((cliche as c join ordine as o on c.ordine=o.numero) join impiegato as i on o.impiegato=i.interno) join cliente as cl on o.cliente=cl.codice) join materiale as m1 on c.materiale1=m1.ID) left join materiale as m2 on c.materiale2=m2.ID
	where o.consegnato='no' and m1.nome='magnesio' and (m2.nome='magnesio' or ISNULL(m2.ID));

drop view if exists pack;
create view pack (ordine, id_stampa, num_pacchi) as 
	select o.numero, s.id, pacchi(s.id) 
	from stampa as s join ordine as o on s.ordine=o.numero;


SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

drop view if exists Guadagno_annuale;
create view Guadagno_annuale (Guadagno,Anno,Cliente_migliore) as
select g.guad, g.anno ,cl.cliente
from 
(select year(o.datacomm)as anno, sum(saldo(o.numero)) as guad from ordine as o
group by year(o.datacomm)) as g
join 
(select c.nome as cliente, year(o1.datacomm) as anno
from cliente as c join ordine as o1 on c.codice=o1.cliente
group by year(o1.datacomm)
having max(saldo(o1.numero))) as cl on g.anno=cl.anno;



select f.cliente, YEAR(o.datacomm)
from fattura as f join ordine as o on o.numero=f.numOrdine
group by Year(o.datacomm),f.cliente;

drop view if exists prezzo_ordini;
create view prezzo_ordini as 
select o.numero, c.codice, saldo(o.numero), o.datacomm
	from (((ordine as o join cliente as c on o.cliente=c.codice) left join cliche as cl on cl.ordine=o.numero) left join stampa as s on s.ordine=o.numero;










drop view if exists ordini_stampa;
create view ordini_stampa (Numero_ordine, Codice_cliente, Nome_cliente, Saldo)as 
select o.numero, cl.codice, cl.nome, sum(s.prezzo*s.copie)
from (ordine as o join stampa as s on s.ordine=o.numero) join cliente as cl on  cl.codice=o.cliente
where not exists (
	select *
	from cliche as c where o.numero=c.ordine
) and year(o.datacomm)= year (curdate()) 
group by o.numero;



