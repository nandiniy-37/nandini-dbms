create database employee;
use employee;
CREATE TABLE DEPT ( 
DEPTNO VARCHAR(10) PRIMARY KEY, 
DNAME VARCHAR(50) NOT NULL, 
DLOC VARCHAR(50) 
); 

CREATE TABLE PROJECT ( 
 PNO VARCHAR(10) PRIMARY KEY, 
 Pname VARCHAR(50), 
 Ploc VARCHAR(50) 
); 

CREATE TABLE EMPLOYEE ( 
EMPNO VARCHAR(10) PRIMARY KEY, 
ENAME VARCHAR(50) NOT NULL, 
MGR_NO VARCHAR(10), 
HIREDATE DATE,
SAL DECIMAL(10 , 2 ), 
 DEPTNO VARCHAR(10), 
 FOREIGN KEY (DEPTNO) 
 REFERENCES DEPT (DEPTNO) 
); 
CREATE TABLE INCENTIVES ( 
 EMPNO VARCHAR(10), 
 INCENTIVE_DATE DATE, 
 INCENTIVE_AMOUNT DECIMAL(10 , 2 ), 
 PRIMARY KEY (EMPNO , INCENTIVE_DATE),  FOREIGN KEY (EMPNO) 
 REFERENCES EMPLOYEE (EMPNO) 
); 
CREATE TABLE ASSIGNED ( 
 EMPNO VARCHAR(10),
 PNO VARCHAR(10), 
 JOB_ROLE VARCHAR(50), 
 PRIMARY KEY (EMPNO, PNO), 
 FOREIGN KEY (EMPNO) REFERENCES EMPLOYEE(EMPNO), 
 FOREIGN KEY (PNO) REFERENCES PROJECT(PNO) 
); 
desc assigned;
INSERT INTO dept VALUES (10,'ACCOUNTING','MUMBAI');
INSERT INTO dept VALUES (20,'RESEARCH','BENGALURU');
INSERT INTO dept VALUES (30,'SALES','DELHI');
INSERT INTO dept VALUES (40,'OPERATIONS','CHENNAI');
select * FROM dept;
INSERT INTO employee VALUES (7369,'Adarsh',7902,'2012-12-17','80000.00','20');
INSERT INTO employee VALUES (7499,'Shruthi',7698,'2013-02-20','16000.00','30');
INSERT INTO employee VALUES (7521,'Anvitha',7698,'2015-02-22','12500.00','30');
INSERT INTO employee VALUES (7566,'Tanvir',7839,'2008-04-02','29750.00','20');
INSERT INTO employee VALUES (7654,'Ramesh',7698,'2014-09-28','12500.00','30');
INSERT INTO employee VALUES (7698,'Kumar',7839,'2015-05-01','28500.00','30');
INSERT INTO employee VALUES (7782,'CLARK',7839,'2017-06-09','24500.00','10');
INSERT INTO employee VALUES (7788,'SCOTT',7566,'2010-12-09','30000.00','20');
INSERT INTO employee VALUES ('7839','KING',NULL,'2009-11-17','500000.00','10');
INSERT INTO employee VALUES ('7844','TURNER',7698,'2010-09-08','15000.00','30');
INSERT INTO employee VALUES ('7876','ADAMS',7788,'2013-01-12','11000.00','20');
INSERT INTO employee VALUES ('7900','JAMES',7698,'2017-12-03','9500.00','30');
INSERT INTO employee VALUES ('7902','FORD','7566','2010-12-03','30000.00','20');
select * from employee;
INSERT INTO incentives VALUES(7499,'2019-02-01',5000.00);
INSERT INTO incentives VALUES(7521,'2019-03-01',2500.00);
INSERT INTO incentives VALUES(7566,'2022-02-01',5070.00);
INSERT INTO incentives VALUES(7654,'2020-02-01',2000.00);
INSERT INTO incentives VALUES(7654,'2022-04-01',879.00);
INSERT INTO incentives VALUES(7521,'2019-02-01',8000.00);
INSERT INTO incentives VALUES(7698,'2019-03-01',500.00);
INSERT INTO incentives VALUES(7698,'2020-03-01',9000.00);
INSERT INTO incentives VALUES(7698,'2022-04-01',4500.00);
select * from incentives;
INSERT INTO project VALUES(101,'AI Project','BENGALURU');
INSERT INTO project VALUES(102,'IOT','HYDERABAD');
INSERT INTO project VALUES(103,'BLOCKCHAIN','BENGALURU');
INSERT INTO project VALUES(104,'DATA SCIENCE','MYSURU');
INSERT INTO project VALUES(105,'AUTONOMUS SYSTEMS','PUNE');
select * from project;
INSERT INTO assigned VALUES(7499,101,'Software Engineer');
INSERT INTO assigned VALUES(7521,101,'Software Architect');
INSERT INTO assigned VALUES(7566,101,'Project Manager');
INSERT INTO assigned VALUES(7654,102,'Sales');
INSERT INTO assigned VALUES(7521,102,'Software Engineer');
INSERT INTO assigned VALUES(7499,102,'Software Engineer');
INSERT INTO assigned VALUES(7654,103,'Cyber Security');
INSERT INTO assigned VALUES(7698,104,'Software Engineer');
INSERT INTO assigned VALUES(7900,105,'Software Engineer');
INSERT INTO assigned VALUES(7839,104,'General Manager');
select * from assigned;
select e.empno
 from employee e, assigned a, project p
 	where e.empno=a.empno and a.pno=p.pno and 
 p.ploc in ('Bengaluru','Hyderabad','Mysuru');
select empno from employee where empno not in(select empno from incentives);

select e.empno,e.ename,d.dname,d.dloc,a.job_role,p.ploc from employee e,dept d,assigned a,project p where e.deptno=d.deptno and e.empno=a.empno and a.pno=p.pno and d.dloc=p.ploc;
SELECT m.ename, count(*)
FROM employee e,employee m
WHERE e.mgr_no = m.empno
GROUP BY m.ename
HAVING count(*) =(SELECT MAX(mycount) 
  			       from (SELECT COUNT(*) mycount
      			       FROM employee
      			        GROUP BY mgr_no) a);
SELECT *
FROM employee m
WHERE m.empno IN
    (SELECT mgr_no
     FROM employee)
  AND m.sal >
    (SELECT avg(e.sal)
     FROM employee e
     WHERE e.mgr_no = m.empno ); 
select * 
from employee e,incentives i
where e.empno=i.empno and 2 = ( select count(*)
			from incentives j
			where i.incentive_amount <= j.incentive_amount );

 SELECT * FROM employee E WHERE E.DEPTNO = (SELECT E1.DEPTNO FROM employee E1 WHERE E1.EMPNO=E.MGR_NO);

SELECT distinct e.ename
FROM employee e,incentives i
WHERE (SELECT max(sal+incentive_amount)
     FROM employee,incentives) >= ANY
    (SELECT sal
     FROM employee e1
     where e.deptno=e1.deptno);
