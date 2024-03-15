/* Display ToyId, ToyName, Stock of those toys whose stock lies within 10 and 
15(both inclusive) and toyname contains more than 6 characters */
select ToyId,ToyName ,stock from  toys where  stock between 10 and 15  and length(toyname)>6;

/*Identify and display CustId, CustName, CustType of those customers whose name ends 
with ‘y’. For the selected records, if the customer type is NULL display CustType as 
‘N’.Do case insensitive comparison */
UPDATE customers t
SET t.custtype = 'N'
WHERE t.CustName LIKE '%y' AND t.custtype IS NULL;
/*Display CustName and total transaction cost as TotalPurchase for those customers
whose total transaction cost is greater than 1000.*/
select c.CustName,sum(t.TxnCost) as  Totalpurchase 
from transactions as t inner  join  customers as c
on t.CustId=c.CustId  group by c.CustId,c.custname having  Totalpurchase>1000;

/*For each customer display transactionid, customerid and cost of the transaction that
has the maximum cost among all transactions made by that customer.*/
with cte as  (select *,rank() over(partition by custid order  by  txncost desc ) as r
 from transactions)
 select custid ,txnid,txncost from cte where  r=1; 
 # 2nd method
 select * from transactions where (custid ,txncost) in (select  custid ,max(txncost) from transactions
 group by custid);
 /*List all the toyid, total quantity purchased as 'total quantity' irrespective of 
 the customer. Toys that have not been sold  should also appear in the result with 
 total units as 0*/
 (select toyid ,0 as  total_quantity   from toys where  toyid  not  in
 (select toyid   from transactions))
 union  all 
(SELECT toyid ,sum(quantity) as total_quantity FROM transactions as t group by toyid)


/*List all the ToyId, ToyName, Price of those toys which have the same price*/
select t1.toyid,t1.toyname ,t1.price from toys t1 join toys t2 on t1.price =t2.price 
and  t1.toyid!=t2.ToyId;
/*The CEO of Toys corner wants to know which toy has the highest total Quantity sold.
 Display CName, ToyName, total Quantity sold of this toy*/
 select  a.toyid,b.toyname ,c.cname,a.total_quantity from (select toyid,sum(Quantity)  as   total_quantity from transactions group by toyid order
 by total_quantity desc limit 1) a inner  join toys b on a.toyid=b.ToyId
 inner  join category as c on  b. cid=c.cid