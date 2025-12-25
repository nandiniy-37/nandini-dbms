create database bank;
use bank;
create table branch(Branch_name varchar(30),Branch_city varchar(25),assets int,PRIMARY KEY (Branch_name));
create table BankAccount(Accno int,Branch_name varchar(30),Balance int,PRIMARY KEY(Accno),foreign key (Branch_name) references branch(Branch_name));
create table BankCustomer(Customername varchar(20),Customer_street varchar(30),CustomerCity varchar (35),PRIMARY KEY(Customername));
create table Depositer(Customername varchar(20),Accno int,PRIMARY KEY(Customername,Accno),foreign key (Accno) references BankAccount(Accno),foreign key (Customername) references BankCustomer(Customername));
create table Loan(Loan_number int,Branch_name varchar(30),Amount int,PRIMARY KEY(Loan_number),foreign key (Branch_name) references branch(Branch_name));
insert into branch(Branch_name,Branch_city,assets) values("SBI_Chamrajpet","Bangalore",50000),("SBI_ResidencyRoad","Bangalore",10000),("SBI_ShivajiRoad","Bombay",20000),("SBI_ParlimentRoad","Delhi",10000),("SBI_Jantarmantar","Delhi",20000);
insert into BankAccount(Accno,Branch_name,Balance) values(1,"SBI_Chamrajpet",2000),(2,"SBI_ResidencyRoad",5000),(3,"SBI_ShivajiRoad",6000),(4,"SBI_ParlimentRoad",9000),(5,"SBI_Jantarmantar",8000),(6,"SBI_ShivajiRoad",4000),(8,"SBI_ResidencyRoad",4000),(9,"SBI_ParlimentRoad",3000),(10,"SBI_ResidencyRoad",5000),(11,"SBI_Jantarmantar",2000);
insert into BankCustomer(Customername,Customer_street,CustomerCity) values("Avinash","Bull_Temple_Road","Bangalore"),("Dinesh","Bannergatta_Road","Bangalore"),("Mohan","NationalCollege_Road","Bangalore"),("Nikil","Akbar_Road","Delhi"),("Ravi","Prithviraj_Road","Delhi");
insert into Depositer values("Avinash",1);
insert into Depositer values("Dinesh",2);
insert into Depositer values("Nikil",4);
insert into Depositer values("Ravi",5);
insert into Depositer values("Avinash",8);
insert into Depositer values("Nikil",9);
insert into Depositer values("Dinesh",10);
insert into Depositer values("Nikil",11);
insert into Loan values(1,"SBI_Chamrajpet",1000);
insert into Loan values(2,"SBI_ResidencyRoad",2000);
insert into Loan values(3,"SBI_ShivajiRoad",3000);
insert into Loan values(4,"SBI_ParlimentRoad",4000);
insert into Loan values(5,"SBI_Jantarmantar",5000);
select * from branch;
select * from BankAccount;
select * from BankCustomer;
select * from Depositer;
select * from Loan;
select Branch_name, CONCAT(assets/100000,'  lakhs')assets_in_lakhs from branch;
select d.Customername from Depositer d, BankAccount b where  b.Branch_name='SBI_ResidencyRoad' and d.Accno=b.Accno group by d.Customername having count(d.Accno)>=2;
create view sum_of_loans as select Branch_name, SUM(Amount) from loan group by Branch_name;
select * from sum_of_loans;
select bc.Customername, CONCAT(Balance+1000,'  rupees') UPDATED_BALANCE from BankAccount b, BankCustomer bc, Depositer d where bc.Customername=d.Customername and b.Accno=d.Accno and bc.Customercity='Bangalore';
select Customername from BankCustomer where Customercity='Delhi';
select * from loan order by amount desc;
CREATE VIEW BRANCH_TOTAL_LOAN (BRANCH_NAME, TOTAL_LOAN) AS SELECT BRANCH_NAME, SUM(AMOUNT) FROM LOAN GROUP BY BRANCH_NAME;
select * from branch_total_loan;
UPDATE BankAccount SET BALANCE=BALANCE *1.05;
desc Loan;
SELECT DISTINCT S.Customername
FROM depositer S
WHERE NOT EXISTS (
    SELECT B.branch_name
    FROM branch B
    WHERE B.branch_city = 'Delhi'
      AND NOT EXISTS (
          SELECT 1
          FROM depositer T
          JOIN bankaccount R
            ON T.accno = R.accno
          WHERE T.customername = S.customername
            AND R.branch_name = B.branch_name
      )
);
select branch_name from branch where assets >
all (select assets from branch where branch_city
= 'Bangalore')

create table borrower(customername varchar(50),loan_number int,
primary key(customername,loan_number),
foreign key(customername) references bankcustomer(customername) on update cascade,
foreign key(loan_number) references loan(loan_number)on update cascade);
desc borrower;
insert into borrower values('Avinash',1),('Dinesh',2),('Mohan',3),('Nikil',4),('Ravi',5);
select * from borrower;
insert into branch values('SBI_MantriMarg','Delhi',200000);
insert into bankaccount values(12,'SBI_MantriMarg',2000);
insert into depositer values('Nikil',12);

select distinct customername from borrower where customername in (select customername from depositer);

select customername
from borrower, loan
where borrower.loan_number=loan.loan_number
and loan.branch_name in(select branch_name
from depositer, bankaccount
where depositer.accno=bankaccount.branch_name in(select branch_name from branch where branch.branch_city="Bangalore"));
select branch_name from branch where assets>(select sum(assets) from branch where branch_city='Bangalore');
delete from bankaccount where branch_name =(select branch_name from branch where branch_city='Bombay');
update bankaccount set balance=((5/100)*balance+balance);
