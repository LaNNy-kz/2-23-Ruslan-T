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
    status boolean not null default true  
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