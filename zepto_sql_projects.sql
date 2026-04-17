create database zepto_project;
use zepto_project;

SELECT * FROM zepto_project.zepto_v2;

-- data exploration

-- count of rows
select count(*) from zepto_project.zepto_v2;

-- sample data
select * from zepto_project.zepto_v2
limit 10;

-- null values  
select * from zepto_project.zepto_v2
where name is null
or
Category is null
or
mrp is null
or
discountPercent is null
or
discountedSellingPrice is null
or
weightInGms is null
or
availableQuantity is null
or
outOfStock is null
or
quantity is null;

-- different product categories
select distinct category
from zepto_project.zepto_v2
order by Category;

-- product in stock vs out of stock
select outOfStock, count(category)
from zepto_project.zepto_v2
group by outOfStock;

-- product name present multiple times
select name, count(category) as "numbers of categories"
from zepto_project.zepto_v2
group by name
having count(Category) > 1
order by count(Category) desc;

-- data cleaning
-- product with price =0
select * from zepto_project.zepto_v2
where mrp = 0 or discountedSellingPrice = 0;

SET SQL_SAFE_UPDATES = 0;

delete from zepto_project.zepto_v2
where mrp = 0;

-- convert prices to rupees
update zepto_project.zepto_v2
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto_project.zepto_v2;

-- Business insight 
-- Q1 find the top 10 best-value prodeucts based on the discount percentage
select distinct name, mrp, discountedSellingPrice
from zepto_project.zepto_v2
order by discountedSellingPrice desc
limit 10;

-- Q2 wha are the product with high mrp but out of stock
select distinct name, mrp
from zepto_project.zepto_v2
where outOfStock = true and mrp > 300
order by mrp desc;

-- Q3 calculate estimated revenue for each category
select category, sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto_project.zepto_v2
group by category
order by total_revenue;

-- Q4 find all products where mrp is greater than 500 and discount is less than 10%
select distinct name, mrp, discountPercent
from zepto_project.zepto_v2
where mrp > 500 and discountPercent <10
order by mrp desc, discountPercent desc;

-- Q5 identify the top 5 category offering the highest average discount percentage
select category, round(avg(discountPercent),2) as avg_discount
from zepto_project.zepto_v2
group by Category
order by avg_discount desc
limit 5;

-- Q6 find the price per gram for products above 100g and sort by best value
select distinct name, weightInGms, discountedSellingPrice,
round((discountedSellingPrice/weightInGms),2) as price_per_gram
from zepto_project.zepto_v2
where weightInGms >= 100
order by price_per_gram;

-- Q7 group the products into categoris like low, medium, bulk
select distinct name, weightInGms,
case when weightInGms < 1000 then 'low'
     when weightInGms < 5000 then 'medium'
     else 'bulk'
     end as  weight_category
from zepto_project.zepto_v2;
     
-- Q8 what is the total inventory weight per category
select category,
sum(weightInGms * availableQuantity) as total_weight
from zepto_project.zepto_v2
group by Category
order by total_weight;