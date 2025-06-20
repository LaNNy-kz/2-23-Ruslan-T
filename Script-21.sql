--CREATE database "PO4.4"
--
--
--CREATE TABLE IF NOT EXISTS departments (
--    dept_id SERIAL PRIMARY KEY,
--    dept_name VARCHAR(100) NOT NULL UNIQUE
--);
--
---- Check if the 'employees' table exists before creating
--CREATE TABLE IF NOT EXISTS employees (
--    emp_id SERIAL PRIMARY KEY,                     -- Primary Key
--    first_name VARCHAR(30) NOT NULL,               -- Text column
--    last_name VARCHAR(30) NOT NULL,                -- Text column
--    email VARCHAR(40) UNIQUE,                      -- Unique constraint
--    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,  -- Default value
--    salary DECIMAL(10, 2) CHECK (salary > 0),      -- Check constraint
--    dept_id INT,                                   -- Foreign Key column
--    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)  -- FK constraint
--);



---- Insert fake data into departments
--INSERT INTO departments (dept_name) VALUES
--('Human Resources'),
--('Finance'),
--('Engineering'),
--('Marketing'),
--('Sales');

---- Insert fake data into employees
--INSERT INTO employees (first_name, last_name, email, hire_date, salary, dept_id) VALUES
--('Alice', 'Johnson', 'alice.johnson@example.com', '2022-01-15', 55000.00, 1),
--('Bob', 'Smith', 'bob.smith@example.com', '2021-11-03', 72000.00, 3),
--('Charlie', 'Brown', 'charlie.brown@example.com', '2020-06-10', 68000.00, 3),
--('Diana', 'Lopez', 'diana.lopez@example.com', '2023-02-20', 60000.00, 2),
--('Ethan', 'Wang', 'ethan.wang@example.com', '2022-07-01', 75000.00, 3),
--('Fiona', 'Garcia', 'fiona.garcia@example.com', '2023-10-05', 48000.00, 4),
--('George', 'Lee', 'george.lee@example.com', '2024-03-18', 51000.00, 5),
--('Hannah', 'Kim', 'hannah.kim@example.com', '2021-09-25', 47000.00, 1),
--('Ivan', 'Petrov', 'ivan.petrov@example.com', '2020-01-09', 82000.00, 2),
--('Julia', 'Martinez', 'julia.martinez@example.com', '2022-12-30', 59000.00, 4);


--ALTER TABLE employees ADD age DATE;
--
--select * from departments
--select * from employees


--drop table departments,employees
---------------------------------------------


create schema  if not exists food_delivery


----Table food_delivery----

--1.Users
--2.Restaurants
--3.Menu_Items
--4.Orders
--5.Order_Items 
--6.Payments 
--7.Delivery 
--8.Reviews 


-- 1. user
create table if not exists food_delivery.user (
    user_id serial primary key,
    first_name varchar(30) not null,
    last_name varchar(30) not null,
    email varchar(40) unique,
    phone varchar(20) not null,
    address varchar(100) not null,
    gender varchar(10) check (gender in ('male', 'female', 'other')),
    created_at timestamp not null default current_timestamp check (created_at > '2024-01-01')
);

-- 2. restaurant
create table if not exists food_delivery.restaurant (  
    restaurant_id serial primary key,
    name varchar(30) not null, 
    category varchar(30) not null,
    address varchar(100) not null,
    phone varchar(20) not null,
    rating numeric(2,1) check (rating >= 0),
    status boolean not null   default true  
);

-- 3. menu_item
create table if not exists food_delivery.menu_item (
    item_id serial primary key,
    restaurant_id int not null references food_delivery.restaurant(restaurant_id),
    name varchar(50) not null,
    description text,
    price numeric(6,2) not null check (price >= 0),
    available boolean not null default true,
    category varchar(30) not null
);

-- 4. order
create table if not exists food_delivery.order (
    order_id serial primary key,
    user_id int not null references food_delivery.user(user_id),
    restaurant_id int not null references food_delivery.restaurant(restaurant_id),
    order_date timestamp not null default current_timestamp check (order_date > '2024-01-01'),
    total_amount numeric(8,2) not null check (total_amount >= 0),
    status varchar(20) not null
);

-- 5. order_item
create table if not exists food_delivery.order_item (
    order_item_id serial primary key,
    order_id int not null references food_delivery.order(order_id),
    item_id int not null references food_delivery.menu_item(item_id),
    quantity int not null check (quantity >= 1),
    price numeric(6,2) not null check (price >= 0)
);

-- 6. payment
create table if not exists food_delivery.payment (
    payment_id serial primary key,
    order_id int not null references food_delivery.order(order_id),
    payment_method varchar(30) not null,
    paid_at timestamp not null default current_timestamp check (paid_at > '2024-01-01'),
    amount numeric(8,2) not null check (amount >= 0),
    status varchar(20) not null
);

-- 7. delivery
create table if not exists food_delivery.delivery (
    delivery_id serial primary key,
    order_id int not null references food_delivery.order(order_id),
    courier_name varchar(50),
    courier_phone varchar(20),
    estimated_time interval,
    delivery_status varchar(30) not null
);

-- 8. review
create table if not exists food_delivery.review (
    review_id serial primary key,
    user_id int not null references food_delivery.user(user_id),
    restaurant_id int not null references food_delivery.restaurant(restaurant_id),
    rating int not null check (rating between 1 and 5),
    comment text,
    created_at timestamp not null default current_timestamp check (created_at > '2024-01-01')
);

-- 1 
with new_users as (
    select 'Ruslan' as first_name, 'Tauken' as last_name, 'ruslan.barysya@gmail.com' as email, 
           '87019991122' as phone, 'ул. Баймуханова, 25, Атырау' as address, 'male' as gender
    union all
    select 'Utemis', 'Adilet', 'adilet.utemis@gmail.com', '87004445566', 'мкр. Нурсая, 8, Атырау', 'male'
    union all
    select 'Dias', 'Nurlybek', 'dias.nur@gmail.com', '87012223344', 'ул. Азаттык, 50, Атырау', 'male'
    union all
    select 'Tanya', 'Kim', 'tanya.kim@gmail.com', '87016667788', 'ул. Сатпаева, 13, Атырау', 'female'
    union all
    select 'Aigerim', 'Zhaksylyk', 'eva.green@gmail.com', '87018889900', 'ул. Авангард, 1, Атырау', 'female'
    union all
    select 'Nauryzbaev', 'Serik', 'serik_aboba.m@gmail.com', '87017776655', 'ул. Геолог, 9, Атырау', 'male'
)
insert into food_delivery.user (first_name, last_name, email, phone, address, gender)
select first_name, last_name, email, phone, address, gender
from new_users nu
where not exists (
    select 1 from food_delivery.user u where u.email = nu.email
)
returning user_id, first_name, last_name, email;

-- 2
with new_restaurants as ( 
    select 'Pizza La Roma' as name, 'Italian' as category, 'ул. Абая, 18А, Атырау' as address, '+7 (7122) 31-91-91' as phone, 4.7 as rating, true as status
    union all
    select 'Pizza La Roma', 'Italian', 'ул. Курмангазы, 5, Атырау', '+7 (701) 684-79-07', 4.7, true
    union all 
    select 'Sancak Restaurant', 'Turkish', 'пр. Абая, 1Б, Атырау', '+7 (778) 499-33-01', 4.2, true
    union all 
    select 'Djama Halal Fusion', 'Halal Fusion', 'пр. Султана Бейбарыса, 260, Атырау', '+7 (775) 777-00-97', 4.8, true
    union all 
    select 'Aroma Food', 'Fast Food', 'мкр. Авангард, 4/15, Атырау', '+7 (778) 333-44-43', 4.3, true
    union all
    select 'Koryshka', 'Seafood', 'набережная р. Урал, Атырау', '+7 (702) 707-74-44', 4.5, true
)
insert into food_delivery.restaurant (name, category, address, phone, rating, status)
select name, category, address, phone, rating, status
from new_restaurants nr
where not exists (
    select 1 from food_delivery.restaurant r where r.name = nr.name and r.address = nr.address
)
returning restaurant_id, name, category;

-- 3 


with new_menu_items as (
    select 1 as restaurant_id, 'sichuan chicken' as name, 'spicy chinese chicken with vegetables' as description, 2800.00 as price, 'main' as category
    union all
    select 'double cheeseburger', 'juicy burger with two patties', 1900.00, 'main'
    union all
    select 3, 'margherita pizza', 'classic italian pizza with tomato and mozzarella', 2400.00, 'main'
    union all
    select 4, 'xxl shawarma', 'large shawarma with chicken and sauce', 1700.00, 'main'
    union all
    select 5, 'philadelphia roll', 'roll with salmon, cheese, and cucumber', 2300.00, 'main'
    union all
    select 6, 'quinoa bowl', 'healthy bowl with vegetables and quinoa', 2600.00, 'main'
)
insert into food_delivery.menu_item (restaurant_id, name, description, price, category)
select restaurant_id, name, description, price, category
from new_menu_items nmi
where not exists (
    select 1 from food_delivery.menu_item mi
    where mi.restaurant_id = nmi.restaurant_id and mi.name = nmi.name
)
returning item_id, restaurant_id, name;


-- 4 

with new_orders as (
    select 1 as user_id, 1 as restaurant_id, 2800.00 as total_amount, 'completed' as status
    union all
    select 2, 2, 3800.00, 'delivered'
    union all
    select 3, 3, 2400.00, 'preparing'
    union all
    select 4, 4, 1700.00, 'completed'
    union all
    select 5, 5, 2300.00, 'canceled'
    union all
    select 6, 6, 2600.00, 'completed'
)
insert into food_delivery."order" (user_id, restaurant_id, total_amount, status)
select user_id, restaurant_id, total_amount, status
from new_orders no
where not exists (
    select 1 from food_delivery."order" o
    where o.user_id = no.user_id and o.restaurant_id = no.restaurant_id and o.total_amount = no.total_amount
)
returning order_id, user_id, restaurant_id;


-- 5 

with new_order_items as (
    select 1 as order_id, 1 as item_id, 1 as quantity, 2800.00 as price
    union all
    select 2, 2, 2, 1900.00
    union all
    select 3, 3, 1, 2400.00
    union all
    select 4, 4, 1, 1700.00
    union all
    select 5, 5, 1, 2300.00
    union all
    select 6, 6, 1, 2600.00
)
insert into food_delivery.order_item (order_id, item_id, quantity, price)
select order_id, item_id, quantity, price
from new_order_items noi
where not exists (
    select 1 from food_delivery.order_item oi
    where oi.order_id = noi.order_id and oi.item_id = noi.item_id
)
returning order_item_id, order_id, item_id;


-- 6 

with new_payments as (
    select 1 as order_id, 'card' as payment_method, 2800.00 as amount, 'paid' as status
    union all
    select 2, 'cash', 3800.00, 'paid'
    union all
    select 3, 'card', 2400.00, 'pending'
    union all
    select 4, 'card', 1700.00, 'paid'
    union all
    select 5, 'cash', 2300.00, 'failed'
    union all
    select 6, 'card', 2600.00, 'paid'
)
insert into food_delivery.payment (order_id, payment_method, amount, status)
select order_id, payment_method, amount, status
from new_payments np
where not exists (
    select 1 from food_delivery.payment p
    where p.order_id = np.order_id and p.amount = np.amount
)
returning payment_id, order_id;

-- 7 

with new_deliveries as (
    select 1 as order_id, 'rauan kurysh' as courier_name, '87070001111' as courier_phone, interval '25 minutes' as estimated_time, 'delivered' as delivery_status
    union all
    select 2, 'amina sarsen', '87071112233', interval '20 minutes', 'delivered'
    union all
    select 3, 'dias speed', '87072223344', interval '15 minutes', 'on the way'
    union all
    select 4, 'nurlan fast', '87073334455', interval '30 minutes', 'delivered'
    union all
    select 5, 'saltanat go', '87074445566', interval '40 minutes', 'canceled'
    union all
    select 6, 'askar jet', '87075556677', interval '18 minutes', 'delivered'
)
insert into food_delivery.delivery (order_id, courier_name, courier_phone, estimated_time, delivery_status)
select order_id, courier_name, courier_phone, estimated_time, delivery_status
from new_deliveries nd
where not exists (
    select 1 from food_delivery.delivery d
    where d.order_id = nd.order_id
)
returning delivery_id, order_id;


-- 8 

with new_reviews as (
    select 1 as user_id, 1 as restaurant_id, 5 as rating, 'delicious! the chicken was amazing.' as comment
    union all
    select 2, 2, 4, 'juicy burger and fast delivery.'
    union all
    select 3, 3, 5, 'best pizza in atyrau!'
    union all
    select 4, 4, 3, 'shawarma was okay, could be better.'
    union all
    select 5, 5, 4, 'tasty rolls, portion could be bigger.'
    union all
    select 6, 6, 5, 'loved the bowl — fresh and filling!'
)
insert into food_delivery.review (user_id, restaurant_id, rating, comment)
select user_id, restaurant_id, rating, comment
from new_reviews nr
where not exists (
    select 1 from food_delivery.review r
    where r.user_id = nr.user_id and r.restaurant_id = nr.restaurant_id 
)
returning review_id, user_id, restaurant_id, rating;



--DELETE FROM food_delivery.user;





