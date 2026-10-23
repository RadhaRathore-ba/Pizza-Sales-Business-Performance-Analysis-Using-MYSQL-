Create DATABASE Pizza;

select * from pizza_orders_table;
SELECT * FROM order_details;
select* from pizza_types;
select* from pizzas;


##--------------------BAIC QUESTIONS------------------------------------
#Q1-------Total number of order placed--------------------------

SELECT count(order_id)AS totalorderplaced from order_details;

#Q2------Total revenue generated from pizza sales------------------- 

select 
Round(SUM( od.quantity*p.price),0)AS Total_Revenue 
from order_details od Join Pizzas p 
On od.pizza_id = p.pizza_id;


#Q3---Highest priced pizza----------------

Select 
pt.name, p.price 
from pizzas p
join pizza_types pt
On p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

#Q4------Most common pizza size ordered--------------------

SELECT 
p.size, count(od.order_details_id) as Total_orders
from order_details od
join pizzas p
ON od.pizza_id = p.pizza_id
GROUP BY p.size
Order by Total_orders DESC;

SELECT 
size,
count(*) as Total_orders
from pizzas
GROUP BY size
Order by Total_orders;

#Q5--------Top 5 most ordered pizza types along with their quantities-----

SELECT
Pt.name,
sum(od.quantity)AS quantity_ordered
from order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
join pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY quantity_ordered DESC 
LIMIT 5;

#-------------------INTERMEDIATE--------------------------------
#Q6-------Find the total quantity of each Pizzas category ordered--------

SELECT 
pt.category,
SUM(od.quantity)AS Total_quantity
FROM order_details od
Join pizzas p
ON od.pizza_id = p.pizza_id
join pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY Total_quantity;

#Q7------Distribution of orders by hours od the day -------------

SELECT
hour(time) AS Order_hour,
COUNT(order_id) AS Total_orders 
from pizza_orders_table
GROUP BY Order_hour
ORDER BY Total_orders;

#Q8---Find the ceatogry wise distribution of pizzas-------

select category,COUNT(name) AS Pizza_count from pizza_types
GROUP BY category
ORDER BY pizza_count DESC;


#Q9-------The averge number of pizzas ordered per day--------------

Select
round(AVG (total_pizzas) ,2)AS avg_pizzas_per_day from 
( select
pot.date,
sum(od.quantity)as total_pizzas
from pizza_orders_table pot
Join order_details od
on pot.order_id = od.order_id
group by pot.date
) daily_orders;


#Q10----Top 3 most pizzas types based on revenue-----------

select
pt.name,
round(SUM(od.quantity*p.price),2) AS Total_revenue
from order_details od
join pizzas p On od.pizza_id = p.pizza_id 
join pizza_types pt On pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
Order by Total_revenue DESC
limit 3;


#Q11----- Calculate The Percentage contribution of each pizzas type to total revenue-------------

select pt.category,
round(sum(od.quantity*p.price)  / (select 
Round(SUM( od.quantity*p.price),2)AS Total_Revenue 
from order_details od Join Pizzas p 
On od.pizza_id = p.pizza_id) *100,2)as revenue 
from pizza_types pt join pizzas p 
on pt.pizza_type_id = p.pizza_type_id
join order_details od
On od.pizza_id = p.pizza_id
group by pt.category Order by revenue desc;

-- Q12 Analyze the cumulative revenue generated over time 

select date,
sum(revenue) over(order by date ) as cum_revenue 
from
(select pizza_orders_table.date,
sum(order_details.quantity * pizzas.price)as revenue 
from order_details join pizzas 
on order_details.pizza_id = pizzas.pizza_id
join pizza_orders_table
on pizza_orders_table.order_id = order_details.order_id
group by pizza_orders_table.date) as sales ;

-- Q13 Determine the top 3 most ordered Pizza Types Based On revenue for each pizza category--------

select category,name,revenue,
rank() over (partition by category order by revenue desc) as rn
from 
(select pt.category, pt.name,
sum((od.quantity)*p.price)as revenue
from pizza_types pt join pizzas p 
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.category, pt.name)as a;


