----------------------------------- GROCERY_SALES_DATA_ANALYSIS_PROJECTS ------------------------------------

-- START OF THE SCHEMA --

-- CREATE TABLE CUSTOMERS --
CREATE TABLE customers (
    customerid int PRIMARY KEY,
    customername varchar(50),
    address varchar(90),
    cityid int,
    FOREIGN KEY (cityid) REFERENCES cities(cityid)
);

-- CREATE TABLE EMPLOYEES --
DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employeeid int PRIMARY KEY,
    empname varchar(50),
    birthdate date,
    gender varchar(20),
    cityid int,
    hiredate date,
    FOREIGN KEY (cityid) REFERENCES cities(cityid)
);

-- CREATE TABLE PRODUCTS --
CREATE TABLE products (
    productid int PRIMARY KEY,
    productname varchar(30),
    price decimal(4,0),
    categoryid int,
    level_type varchar(20),
    modifydate date,
    resistant varchar(20),
    isallergic varchar(20),
    vitalitydays decimal(3,0)
);

ALTER TABLE products ADD FOREIGN KEY (categoryid) REFERENCES categories(categoryid);
ALTER TABLE products ALTER COLUMN productname TYPE varchar(50);

UPDATE products SET price = 80 WHERE productname = 'Bread Crumbs - Japanese Style';
UPDATE products SET price = 67 WHERE productname = 'Apricots - Halves';
UPDATE products SET price = 75 WHERE productname = 'Pastry - Raisin Muffin - Mini';

-- CREATE TABLE CATEGORIES --
CREATE TABLE categories (
    categoryid int PRIMARY KEY,
    categoryname varchar(20)
);

-- CREATE TABLE CITIES --
CREATE TABLE cities (
    cityid int PRIMARY KEY,
    cityname varchar(50),
    zipcode decimal(5,0),
    countryid int,
    FOREIGN KEY (countryid) REFERENCES countries(countryid)
);

-- CREATE TABLE COUNTRIES --
CREATE TABLE countries (
    countryid int PRIMARY KEY,
    countryname varchar(50),
    countrycode varchar(2)
);

-- CREATE TABLE SALES --
DROP TABLE IF EXISTS sales CASCADE;

CREATE TABLE sales (
    salesid int PRIMARY KEY,
    employeeid int,
    customerid int,
    productid int,
    quantity int,
    discount decimal(10,2),
    totalprice decimal(10,2),
    salesdate date,
    transactionnumber varchar(30),
    FOREIGN KEY (employeeid) REFERENCES employees(employeeid),
    FOREIGN KEY (customerid) REFERENCES customers(customerid),
    FOREIGN KEY (productid) REFERENCES products(productid)
);

-- END OF SCHEMA --
