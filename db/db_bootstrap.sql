-- This file is to bootstrap a database for the CS3200 project. 

-- Creates database
CREATE DATABASE grocery_store;
GRANT ALL PRIVILEGES ON grocery_store.* to 'webapp'@'%';
FLUSH PRIVILEGES;

USE grocery_store;

/*
Store: Has an ID and location, as well as a count of that store's total number of staff members and total net sales.
*/
CREATE TABLE Store (
    storeId integer NOT NULL,
    storeLocation varchar(100),
    staffCount integer,
    netSales DECIMAL(12, 2),
    PRIMARY KEY (storeId)
);

/*
Manager: Has a first and last name and a salary in USD. Managers do not have their own ID but instead are associated with a certain 
store ID, since each store can only have one manager.
*/
CREATE TABLE Manager (
    storeId integer NOT NULL,
    firstName varchar(20),
    lastName varchar(50),
    salary DECIMAL(9, 2),
    PRIMARY KEY (storeId),
    FOREIGN KEY (storeId) REFERENCES Store(storeId) ON UPDATE cascade ON DELETE restrict
);

/*
Employee: Has an ID, first and last name, birth date, position title, wage in USD, hours (per week), and a store ID that represents
the store they work at.
*/
CREATE TABLE Employee (
    employeeId integer NOT NULL,
    firstName varchar(20),
    lastName varchar(50),
    birthDate date,
    positionTitle varchar(100),
    wage DECIMAL(4, 2),
    hoursPerWeek integer,
    storeId integer,
    PRIMARY KEY (employeeId),
    FOREIGN KEY (storeId) REFERENCES Store(storeId) ON UPDATE cascade ON DELETE restrict
);

/*
Vehicle: Has an ID, year, make, and model. Each vehicle is associated with a store employee, and so also contains the ID of the
employee it is paired with. Since an employee can technically have multiple vehicles, both the vehicle ID and employee ID make
up this table's primary key.
*/
CREATE TABLE Vehicle (
    vehicleId integer NOT NULL,
    employeeId integer NOT NULL,
    year integer,
    make varchar(50),
    model varchar(50),
    PRIMARY KEY (vehicleId, employeeId),
    FOREIGN KEY (employeeId) REFERENCES Employee(employeeId) ON UPDATE cascade ON DELETE restrict
);

/*
Store Item: Has a name, price, and stock (if the stock is 0, the item is out of stock). Since you can have the same item at multiple
different stores, it also contains the ID of the store this particular item is at, and the item name and the store ID make up the 
primary key.
*/
CREATE TABLE Item (
    itemName varchar(100) NOT NULL,
    storeId integer NOT NULL,
    price DECIMAL(5, 2),
    stock integer,
    PRIMARY KEY (itemName, storeId),
    FOREIGN KEY (storeId) REFERENCES Store(storeId) ON UPDATE cascade ON DELETE restrict
);

/*
Credit Card Info: Has a credit card #, a card type (visa, mastercard, etc.), a first and last name associated with the card, and a
CVC (the 3-digit security code on the back).
*/
CREATE TABLE CreditCard (
    cardNumber BIGINT NOT NULL,
    cardType varchar(20),
    firstName varchar(20),
    lastName varchar(50),
    cvc integer,
    PRIMARY KEY (cardNumber)
);

/*
Customer: Has an ID, first and last name, email, and street address (street #, street name, city, state, zip code). Additionally,
a customer can link up to 3 payment methods: a bank account #, a link to their account on a payment app like PayPal or Venmo, and
a credit card #. A customer does not have to have all of these and any of them can be null, but they should have at least one linked
if they want to pay for anything. They also are linked with an employee representative who handles their order.
*/
CREATE TABLE Customer (
    customerId integer NOT NULL,
    firstName varchar(20),
    lastName varchar(50),
    email varchar(100),
    addressNum integer,
    street varchar(50),
    city varchar(50),
    addressState varchar(50),
    zip integer,
    bankAcctNum BIGINT,
    paymentApp varchar(20),
    creditCard BIGINT,
    employeeRepId integer,
    PRIMARY KEY (customerId),
    FOREIGN KEY (creditCard) REFERENCES CreditCard(cardNumber) ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (employeeRepId) REFERENCES Employee(employeeId) ON UPDATE cascade ON DELETE restrict
);

/*
Order Info: Has an ID, total price in USD, status ('processing', 'on the way', 'delivered', etc.), payment status (paid for or not),
pickup status (yes or no), and any additional details the customer may want to leave to the deliverer. It is also linkd with the ID of
the customer who ordered it, and the employee who is delivering it.
*/
CREATE TABLE Orders (
    orderId BIGINT NOT NULL,
    total DECIMAL(6, 2),
    orderStatus varchar(20),
    paid boolean,
    pickup boolean,
    details varchar(200),
    orderedBy integer,
    fulfilledBy integer,
    PRIMARY KEY (orderId),
    FOREIGN KEY (orderedBy) REFERENCES Customer(customerId) ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (fulfilledBy) REFERENCES Employee(employeeId) ON UPDATE cascade ON DELETE restrict
);

/*
This table contains additional information about the items within a specific order, and connects the Order and Item tables.
In addition to being linked with an order ID and an item name, it specifies the quantity of that item to order, as well as 
whether the item(s) have been retrieved by the delivery employee.
*/
CREATE TABLE OrderItem (
    orderId BIGINT NOT NULL,
    itemName varchar(100) NOT NULL,
    quantity integer,
    retrieved boolean,
    PRIMARY KEY (orderId, itemName),
    FOREIGN KEY (orderId) REFERENCES Orders(orderId) ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (itemName) REFERENCES Item(itemName) ON UPDATE cascade ON DELETE restrict
);

-- Sample data
insert into Store (storeId, storeLocation, staffCount, netSales) values ('39563310', 'Nailung', 69, 142134.95);
insert into Store (storeId, storeLocation, staffCount, netSales) values ('90135794', 'Kalodu', 63, 562654.74);
insert into Store (storeId, storeLocation, staffCount, netSales) values ('91554106', 'Leopoldina', 75, 703751.21);

insert into Manager (storeId, firstName, lastName, salary) values ('39563310', 'Gregoire', 'Croom', 76830.25);
insert into Manager (storeId, firstName, lastName, salary) values ('90135794', 'Waylen', 'Hussell', 83857.15);
insert into Manager (storeId, firstName, lastName, salary) values ('91554106', 'Una', 'Kerans', 81867.92);

insert into Employee (employeeId, firstName, lastName, birthDate, positionTitle, wage, hoursPerWeek, storeId) 
    values ('34495148', 'Leighton', 'Falls', '1951-07-26', 'Safety Technician I', 21.81, 20, '39563310');
insert into Employee (employeeId, firstName, lastName, birthDate, positionTitle, wage, hoursPerWeek, storeId) 
    values ('84536010', 'Daniele', 'Lumber', '1963-09-01', 'Senior Financial Analyst', 21.34, 47, '90135794');
insert into Employee (employeeId, firstName, lastName, birthDate, positionTitle, wage, hoursPerWeek, storeId) 
    values ('85107380', 'Chevy', 'Holmes', '1988-02-08', 'Executive Secretary', 21.78, 26, '91554106');
insert into Employee (employeeId, firstName, lastName, birthDate, positionTitle, wage, hoursPerWeek, storeId) 
    values ('31141736', 'Madlen', 'Vallentin', '1960-02-04', 'Help Desk Technician', 23.49, 20, '91554106');

insert into Vehicle (vehicleId, employeeId, year, make, model) values ('239433', '34495148', 1992, 'Mitsubishi', 'Diamante');
insert into Vehicle (vehicleId, employeeId, year, make, model) values ('754445', '84536010', 2010, 'Volkswagen', 'GTI');
insert into Vehicle (vehicleId, employeeId, year, make, model) values ('885416', '85107380', 1990, 'Ford', 'Taurus');

insert into Item (itemName, storeId, price, stock) values ('Veal - Heart', '39563310', 8.97, 13);
insert into Item (itemName, storeId, price, stock) values ('Pumpkin - Seed', '91554106', 5.17, 54);
insert into Item (itemName, storeId, price, stock) values ('Soup - Campbells Pasta Fagioli', '90135794', 0.55, 62);
insert into Item (itemName, storeId, price, stock) values ('Quail - Whole, Boneless', '91554106', 3.38, 3);
insert into Item (itemName, storeId, price, stock) values ('Beef - Tender Tips', '90135794', 9.50, 73);

insert into CreditCard (cardNumber, cardType, firstName, lastName, cvc) values ('3544477625962458', 'jcb', 'Zahara', 'Long', '412');
insert into CreditCard (cardNumber, cardType, firstName, lastName, cvc) values ('3541625828738504', 'jcb', 'Rosamond', 'Fritchley', '014');
insert into CreditCard (cardNumber, cardType, firstName, lastName, cvc) values ('6767833590345462', 'solo', 'Gwenni', 'Kaemena', '392');

insert into Customer (customerId, firstName, lastName, email, addressNum, street, city, addressState, zip, bankAcctNum, paymentApp, creditCard, employeeRepId) 
    values ('06531697', 'Thornton', 'Paxton', 'tpaxton0@people.com.cn', '6', 'Heath', 'Karachi', null, '12311', '2166183595', '@LoreneMarvin', '6767833590345462', '84536010');
insert into Customer (customerId, firstName, lastName, email, addressNum, street, city, addressState, zip, bankAcctNum, paymentApp, creditCard, employeeRepId) 
    values ('42447219', 'Marena', 'Hebdon', 'mhebdon1@google.co.uk', '94134', 'Bunker Hill', 'Lipn??k nad Be??vou', null, '75701', '9070896625', null, '3544477625962458', '85107380');
insert into Customer (customerId, firstName, lastName, email, addressNum, street, city, addressState, zip, bankAcctNum, paymentApp, creditCard, employeeRepId) 
    values ('60542269', 'Serena', 'Hackett', 'shackett2@woothemes.com', '12204', 'Hollow Ridge', 'S??o Louren??o da Mata', null, '54700', '7987617660', '@SerenaHackett', null, '31141736');
insert into Customer (customerId, firstName, lastName, email, addressNum, street, city, addressState, zip, bankAcctNum, paymentApp, creditCard, employeeRepId) 
    values ('93252307', 'Glynn', 'Edgecombe', 'gedgecombe3@upenn.edu', '72', 'Blue Bill Park', 'Dashahe', 'Connecticut', '02745', null, null, null, '85107380');
insert into Customer (customerId, firstName, lastName, email, addressNum, street, city, addressState, zip, bankAcctNum, paymentApp, creditCard, employeeRepId) 
    values ('82888899', 'Biron', 'Felstead', 'bfelstead4@issuu.com', '9', 'Loeprich', 'Azogues', 'Kansas', '00001', '0790843235', null, '3541625828738504', '34495148');

insert into Orders (orderId, total, orderStatus, paid, pickup, details, orderedBy, fulfilledBy) 
    values ('531414762652', '57.23', 'vitae nisl', true, false, 'mauris lacinia sapien quis', '06531697', '34495148');
insert into Orders (orderId, total, orderStatus, paid, pickup, details, orderedBy, fulfilledBy) 
    values ('960883471731', '42.27', 'quam turpis', false, true, 'id pretium iaculis', '60542269', '34495148');
insert into Orders (orderId, total, orderStatus, paid, pickup, details, orderedBy, fulfilledBy) 
    values ('258834829965', '10.62', 'maecenas', false, true, null, '60542269', '31141736');
insert into Orders (orderId, total, orderStatus, paid, pickup, details, orderedBy, fulfilledBy) 
    values ('471042769086', '36.84', 'nam ultrices', true, false, null, '42447219', '85107380');
insert into Orders (orderId, total, orderStatus, paid, pickup, details, orderedBy, fulfilledBy) 
    values ('585153815919', '95.86', 'nisl', true, false, 'nonummy integer non velit donec diam', '82888899', '84536010');

insert into OrderItem (orderId, itemName, quantity, retrieved) values ('531414762652', 'Veal - Heart', 1, true);
insert into OrderItem (orderId, itemName, quantity, retrieved) values ('960883471731', 'Pumpkin - Seed', 40, true);
insert into OrderItem (orderId, itemName, quantity, retrieved) values ('258834829965', 'Soup - Campbells Pasta Fagioli', 40, true);
insert into OrderItem (orderId, itemName, quantity, retrieved) values ('471042769086', 'Quail - Whole, Boneless', 9, true);
insert into OrderItem (orderId, itemName, quantity, retrieved) values ('585153815919', 'Beef - Tender Tips', 28, true);