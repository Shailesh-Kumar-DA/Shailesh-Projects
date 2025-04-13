create  database insurance_p819;
use insurance_p819;
select * from meeting;
select * from brokerage;
select * from fees;
select * from `individual budgets`;
select * from invoice;
alter table invoice change column `Account Executive` accnt_exec varchar(20);
select * from opportunity;
select * from `individual budgets`;

#Q-No.1-No.of invoice by acount executive--------------------------------------------------------------

SELECT 
    accnt_exec,
    COUNT(CASE
        WHEN income_class IN ('Cross Sell') THEN 1
    END) AS cross_sell,
    COUNT(CASE
        WHEN income_class IN ('New') THEN 1
    END) AS `New`,
    COUNT(CASE
        WHEN income_class IN ('Renewal') THEN 1
    END) AS Renewal,
    COUNT(﻿invoice_number) AS total_invoice
FROM
    invoice
GROUP BY 1
ORDER BY 5 DESC; 

#Q-No.2-Yearly meeting count----------------------------------------------

SELECT 
    YEAR(STR_TO_DATE(meeting_date, '%d-%m-%Y')) AS meeting_year,
    COUNT(meeting_date) AS meeting_count
FROM
    meeting
GROUP BY 1;

#Q-No.3.1-Cross Sell--Target, Achieve, new------------------------------------------------------------------------

SELECT 
	CONCAT(ROUND(Target/1000000,2),"M") Target,
	CONCAT(ROUND(Achive/1000000,2),"M") Achive,
    CONCAT(ROUND(Invoice/1000000,2),"M") Invoice
FROM (
	SELECT
		SUM(`Cross sell bugdet`) Target
	FROM
		`individual budgets`
	)as a ,
    (
    SELECT 
		SUM(Amount) invoice
	FROM
		invoice
	WHERE
		income_class = 'Cross sell'
	) as b ,
    (
		SELECT
			SUM(fees_amount+brok_amount) Achive
		FROM (
			SELECT
				SUM(b.amount) brok_amount,
				fees_amount
			FROM(
				SELECT
					SUM(amount) fees_amount
				FROM
					fees
				WHERE
					income_class= "Cross Sell"
				) as fee, brokerage as b
			WHERE b.income_class = "Cross Sell"
			GROUP BY 2
		) as brok
    ) as c;

#Cross sell plcd achvmnt%------------------------------------------------------------------------------------------------------------------------------------

  select concat(round(cross_sell/Target * 100,2),'%') as `Cross_sell_plcd_achvmnt%` from 
        (select sum(brok+fee) as cross_sell from 
        (select sum(amount) as brok from brokerage where income_class = 'Cross Sell') as e,
        (select sum(amount) as fee from fees where income_class='Cross sell')as r) as w,
        (select sum(`Cross sell bugdet`) as Target from `individual budgets`) as q;
        
 #cross sell invoice achvmnt% -----------------------------------------------------------------------------------------------------------------------------  -    

SELECT 
    CONCAT(ROUND(Invoice / Target * 100, 2), '%') as `cross_sell_invoioce_achvmnt%`
FROM
    (SELECT 
        SUM(Amount) AS Invoice
    FROM
        invoice
    WHERE
        income_class = 'Cross Sell') AS a,
    (SELECT 
        SUM(`Cross sell bugdet`) as Target
    FROM
        `individual budgets`) as b;
        
        #Q-No.3.2-New-Target,Achive,new-------------------------------------------------------------------------------------------------
        
                SELECT 
	CONCAT(ROUND(Target/1000000,2),"M") Target,
	CONCAT(ROUND(Achive/1000000,2),"M") Achive,
    CONCAT(ROUND(Invoice/1000000,2),"M") Invoice
FROM (
	SELECT
		SUM(`New budget`) Target
	FROM
		`individual budgets`
	)as a ,
    (
    SELECT 
		SUM(Amount) invoice
	FROM
		invoice
	WHERE
		income_class = 'New'
	) as b ,
    (
		SELECT
			SUM(fees_amount+brok_amount) Achive
		FROM (
			SELECT
				SUM(b.amount) brok_amount,
				fees_amount
			FROM(
				SELECT
					SUM(amount) fees_amount
				FROM
					fees
				WHERE
					income_class= "New"
				) as fee, brokerage as b
			WHERE b.income_class = "New"
			GROUP BY 2
		) as brok
    ) as c;

#New sell plcd achvmnt%---------------------------------------------------------------------------------------------------------------------------

select concat(round(`new`/Target * 100,2),'%') as `New_plcd_achvmnt%` from 
        (select sum(brok+fee) as `new` from 
        (select sum(amount) as brok from brokerage where income_class = 'New') as e,
        (select sum(amount) as fee from fees where income_class='New')as r) as w,
        (select sum(`New Budget`) as Target from `individual budgets`) as q;
        
#New invoice achvmnt%--------------------------------------------------------------------------------

    SELECT 
    CONCAT(ROUND(Invoice / Target * 100, 2), '%') as `New_invoioce_achvmnt%`
FROM
    (SELECT 
        SUM(Amount) AS Invoice
    FROM
        invoice
    WHERE
        income_class = 'new') AS a,
    (SELECT 
        SUM(`New Budget`) as Target
    FROM
        `individual budgets`) as b;

#Q-No.3.3--Renewal-Target, Achieve , new--------------------------------------------------------------------------------------------------------------------

  
      SELECT 
	CONCAT(ROUND(Target/1000000,2),"M") Target,
	CONCAT(ROUND(Achive/1000000,2),"M") Achive,
    CONCAT(ROUND(Invoice/1000000,2),"M") Invoice
FROM (
	SELECT
		SUM(`Renewal budget`) Target
	FROM
		`individual budgets`
	)as a ,
    (
    SELECT 
		SUM(Amount) invoice
	FROM
		invoice
	WHERE
		income_class = 'Renewal'
	) as b ,
    (
		SELECT
			SUM(fees_amount+brok_amount) Achive
		FROM (
			SELECT
				SUM(b.amount) brok_amount,
				fees_amount
			FROM(
				SELECT
					SUM(amount) fees_amount
				FROM
					fees
				WHERE
					income_class= "Renewal"
				) as fee, brokerage as b
			WHERE b.income_class = "Renewal"
			GROUP BY 2
		) as brok
    ) as c;
    
    #Renwal sell plcd achvmnt%---------------------------------------------------------------------------------------------------------------------------------

 
        select concat(round(`Renewal`/Target * 100,2),'%') as `Renewal_plcd_achvmnt%` from 
        (select sum(brok+fee) as `Renewal` from 
        (select sum(amount) as brok from brokerage where income_class = 'Renewal') as e,
        (select sum(amount) as fee from fees where income_class='Renewal')as r) as w,
        (select sum(`Renewal Budget`) as Target from `individual budgets`) as q;
        
        #Renewal invoice achvmnt%---------------------------------------------------------------------------------------------------------------------------
        
              SELECT 
    CONCAT(ROUND(Invoice / Target * 100, 2), '%') as `Renewal_invoioce_achvmnt%`
FROM
    (SELECT 
        SUM(Amount) AS Invoice
    FROM
        invoice
    WHERE
        income_class = 'Renewal') AS a,
    (SELECT 
        SUM(`Renewal Budget`) as Target
    FROM
        `individual budgets`) as b;
        
#Q-No.-4--Stage Funnel by Revenue---------------------------------------------------------------------------------------------------------------------

select stage, concat(round(sum(revenue_amount)/1000),'K')  as total_revenue 
from opportunity group by 1 ;

#Q-No.5--No. meeting by account executive---------------------------------------------------------------------------------------------------------------------

alter table meeting change column `Account Executive` accnt_exec varchar(20);
select accnt_exec,count(meeting_date) as no_of_meeting_attended from meeting group by 1 order by 2 desc;


#Q-No.6--Top  open opportunity-----------------------------------------------------------------------------------------------------------------------------------

SELECT 
    ﻿opportunity_name as Top_4_oppty, CONCAT(ROUND(revenue_amount / 1000), 'K') Revenue_amt
FROM
    opportunity
WHERE
    stage NOT IN ('Negotiate')
ORDER BY revenue_amount DESC
LIMIT 8;

#total opportunity vs total opne opportunity----------------------------------------------------------------------------------


SELECT 
    COUNT(﻿opportunity_name) AS total_opportunity,
    COUNT(CASE WHEN stage IN ('Qualify Opportunity', 'Propose Solution') THEN 1 END) AS open_opportunity
FROM 
   opportunity;

#top opprtunity------------------------------------------------------------
SELECT 
    ﻿opportunity_name as Top_oppty, CONCAT(ROUND(revenue_amount / 1000), 'K') Revenue_amt
FROM
    opportunity
ORDER BY revenue_amount DESC limit 5;

 

#Opportunity product distribution-----------------------------------------------------------------------------------------------

SELECT distinct product_group, COUNT(specialty) Total FROM Opportunity
GROUP BY 1
ORDER BY 2 DESC;
