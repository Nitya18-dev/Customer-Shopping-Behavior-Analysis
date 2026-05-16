select * from data;

-- male vs female Revenue Generated 
select Gender,sum(purchase_amount) from data 
group by Gender;

-- customer who purchased more than avg purchase amount after disc
select * from data
where discount_applied="Yes" and purchase_amount >= (select avg(purchase_amount) from data);

-- top 5 products based on reviews
select item_purchased as Product, round(avg(review_rating),2) as Avg_Rating from data
group by item_purchased 
Order by avg(review_rating) desc limit 5;

-- avg amount between standard and express shipping 
Select shipping_type, Round(avg(purchase_amount),2) from data 
where shipping_type in ('Standard', 'Express')
group by shipping_type;

-- avg and total spend subscriber and non subscriber
select  subscription_status, count(customer_id), sum(purchase_amount), avg(purchase_amount) from data 
group by subscription_status;


-- Top 5 products that have highest percent of purchases with discount applied
select item_purchased, 
round(100 * Sum(Case when discount_applied= "Yes" then 1 else 0 End)/Count(*),2) as Disc_Rate
from data 
group by item_purchased
order by Disc_Rate Desc
limit 5;


-- New, Ruturning, Loyal Customer Segmentation
with Customer_type as (
select customer_id, previous_purchases,
Case
	When previous_purchases = 1 then 'New'
    When previous_purchases between 2 and 10 then 'returning'
    Else 'Loyal'
    End As Customer_Segment
from Data 
)
Select Customer_Segment, Count(*) as "Number of Customers" 
from Customer_type
group by Customer_Segment




-- top 3 most purchased products by categroy
with Item as(
Select item_purchased , category , count(*) as countofitem,
Row_Number() over(partition by category order by Count(*) Desc ) as Item_Rank
from data 
group by category,item_purchased
)
Select Item_Rank,item_purchased, category, countofitem
from Item
WHERE Item_rank <= 3;


--  customer that are repeat buyers(more than 5) are likely to subscribe?
Select subscription_status, Count(Customer_id) as Repeat_Buyers from data 
where previous_purchases > 5
group by subscription_status;

-- revenue contri by age group
Select age_Group, Sum(purchase_amount) from data
group by age_Group
order by Sum(purchase_amount) Desc;