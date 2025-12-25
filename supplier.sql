create database supplier;
use supplier;  
create table supplier(sid int,sname varchar(20),city varchar(20), primary key(sid));
create table parts(pid int,pname varchar(20),color varchar(20),primary key(pid));
create table catalog(sid int,pid int,cost int,primary key(sid,pid),foreign key(sid)references supplier(sid),foreign key(pid) references parts(pid));
desc catalog;
insert into supplier values (10001,'Amce Widget','Bangalore'),(10002,'Johns','Kolkata'),(10003,'Vimal','Mumbai'),(10004,'Reliance','Delhi');
select * from supplier;
insert into parts values(20001,'Book','Red'),(20002,'Pen','Red'),(20003,'Pencil','Green'),(20004,'Mobile','Green'),(20005,'Charger','Black');
select * from parts;
insert into catalog values(10001,20001,10),(10001,20002,10),(10001,20003,30),(10001,20004,10),(10001,20005,10),(10002,20001,10),(10002,20002,20),(10003,20003,30),(10004,20003,40);
select * from catalog;
select distinct pname from parts where pid in(select pid from catalog);
select S.sname from supplier S join catalog C on S.sid=C.sid group by S.sid,S.sname having count(distinct C.pid)= (select count(distinct pid) from parts);
select sname from supplier where sid  in (select sid from catalog where pid in(select pid from parts where color='Red'));
select p.pname from parts p join catalog c on p.pid=c.pid join supplier s on c.sid=s.sid where s.sname='Acme Widget' and not exists(select * from catalog c2 where c2.pid=p.pid and c2.sid!=s.sid);
SELECT p.pname FROM parts p
JOIN catalog c ON p.pid = c.pid
JOIN supplier s ON c.sid = s.sid
WHERE s.sname = 'Amce Widget'
AND p.pid NOT IN (SELECT c2.pid FROM catalog c2 JOIN supplier s2 ON c2.sid = s2.sid
    WHERE s2.sname <> 'Amce Widget');
select distinct c.sid from catalog c join(select pid,avg(cost) as avg_cost from catalog group by pid) A on c.pid=A.pid where c.cost>a.avg_cost;
select c.pid,s.sname from catalog c join supplier s on c.sid=s.sid where c.cost=(select max(cost) from catalog where pid=c.pid);
select p.pname, s.sname,c.cost from catalog c join parts p on c.pid=p.pid join supplier s on c.sid=s.sid order by c.cost desc limit 1;
select sname from supplier where sid not in (select sid from catalog where pid in(select pid from parts where color='Red'));
select s.sname,sum(c.cost) as total_value from supplier s join catalog c on s.sid=c.sid group by s.sname;
select sname from supplier where sid in(select c.sid from catalog c where c.cost<20 group by c.sid having count(*)>=2);
select p.pid,p.pname,s.sname,c.cost from parts p join catalog c on p.pid=c.pid join supplier s on c.sid=s.sid where c.cost=(select min(cost) from catalog where pid=p.pid);
create view supplierpartcount as select s.sname,count(c.pid) as total_parts from supplier s join catalog c on s.sid=c.sid group by s.sname;
select * from supplierpartcount;
create view mostExpensiveSupplier as select p.pid,p.pname,s.sname, c.cost from parts p join catalog c on p.pid=c.pid join supplier s on c.sid=s.sid where c.cost=(select max(cost) from catalog where pid=p.pid);
select * from mostExpensiveSupplier;
DELIMITER $$
CREATE TRIGGER costcheck
BEFORE INSERT ON catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cost cannot be less than 1';
    END IF;
END$$
DELIMITER ;
insert into catalog value ( 10004,20001,0);
DELIMITER $$
create trigger defaultcost
before insert on catalog
for each row
begin
if new.cost is null then
set new.cost=50;
end if;
end;
