create database pizza
use pizza

select * from order_details 
select * from orders 
select * from pizza_types 
select * from pizzas

-- list of pizza name with types 
select name, pizza_type_id,
(select count(distinct pizza_type_id) from pizza_types) as total_types
from pizza_types
group by name, pizza_type_id

-- list of pizza with there category 
select name, category
from pizza_types

-- avable of size for each pizza
select distinct  size
from pizzas
order by size



select pizza_types.name as pizza_name, 
pizzas.size, pizzas.price
from pizzas 
join pizza_types 
on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by pizza_types.name, pizzas.size

-- cheapest piza
SELECT pizza_types.name, pizzas.price
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by  pizzas.price asc
limit 1

-- pizzas available in Classic category
select name 
from pizza_types 
where category = 'Classic'

-- pizzas available in Supreme category
select name 
from pizza_types 
where category = 'Supreme'

-- pizzas available in Veggie category
select name 
from pizza_types 
where category = 'Veggie'

-- pizzas available in Chicken category
select name 
from pizza_types 
where category = 'Chicken'


-- A] Basic

-- 1. Retrieve the total number of orders placed
select count(order_id) as total 
from orders

-- 2. Calculate the total revenue generated from pizza sales.

select sum(order_details.quantity * pizzas.price) as revenue
from order_details 
join 
pizzas
on pizzas.pizza_id = order_details.pizza_id

-- 3. Identify the highest-priced pizza
select * from pizzas

select max(price) from pizzas

SELECT pizza_types.name, pizzas.price
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by  pizzas.price DESC
limit 1

-- 4. Identify the most common pizza size ordered.

select count(size) from pizzas

select pizzas.size, count(order_details.order_details_id) as size
from pizzas 
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by  pizzas.size order by size

-- 5. List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by quantity desc 
limit 5


-- B]Intermediate

-- 1. Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,
sum(order_details.quantity) as total_quantity
from pizza_types 
join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by total_quantity desc

-- 2. Determine the distribution of orders by hour of the day.

select
hour(time) as order_hour,
count(order_id) as total_orders
from orders
group by hour(time)
order by order_hour

-- 3. Join relevant tables to find the category-wise distribution of pizzas.

select category,
count(name) 
from pizza_types
group by category 
order by category

-- 4. Group the orders by date and calculate the average number of pizzas ordered per day.


select avg(quantity) from 
(select orders.date, sum(order_details.quantity) as quantity
from orders
join order_details 
on orders.order_id = order_details.order_id
group by orders.date) as orde_qunatity

-- 5. Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name  as pizza_type,
sum(order_details.quantity * pizzas.price) as revenue
from order_details
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
join pizza_types  
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by revenue desc
limit 3

-- C] Advanced

-- 1. Calculate the percentage contribution of each pizza type to total revenue.

select
pizza_types.category as pizza_category,
round(
(sum(order_details.quantity * pizzas.price) / 
(select sum(order_details.quantity * pizzas.price)
from order_details 
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
join pizza_types 
on pizzas.pizza_type_id = pizza_types.pizza_type_id)
) * 100, 2
)as revenue_percentage
from order_details 
join pizzas  
on order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types 
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC

-- 2. Analyze the cumulative revenue generated over time.

select
sales.order_date,
sum(sales.revenue) over (order by sales.order_date) as total_revenue
from (
select 
str_to_date(orders.`date`, '%m/%d/%Y') as order_date,
sum(order_details.quantity * pizzas.price) as revenue 
from order_details 
join pizzas 
on order_details.pizza_id = pizzas.pizza_id
join orders 
on orders.order_id = order_details.order_id
group by order_date
) as sales
order by sales.order_date


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, revenue, 
rank() over(partition by category order by revenue desc) as rn
from 
(select  pizza_types.category, pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a


-- Daily sales trend
select o.date, sum(od.quantity) as pizzas_sold
from order_details od
join orders o on od.order_id = o.order_id
group by o.date
order by o.date


























