
/*
Charlie's Chocolate Factory company produces chocolates. 
The following product information is stored: product name, product ID, and quantity on hand. 
These chocolates are made up of many components. Each component can be supplied by one or more suppliers. 
The following component information is kept: component ID, name, description, quantity on hand, 
suppliers who supply them, when and how much they supplied, and products in which they are used. 
On the other hand following supplier information is stored: supplier ID, name, and activation status.

Assumptions

A supplier can exist without providing components.
A component does not have to be associated with a supplier. It may already have been in the inventory.
A component does not have to be associated with a product. Not all components are used in products.
A product cannot exist without components. 

Do the following exercises, using the data model.

     a) Create a database named "Manufacturer"

     b) Create the tables in the database.

     c) Define table constraints.


*/


CREATE DATABASE Manufacturer;

Use Manufacturer;

CREATE SCHEMA Product;

CREATE SCHEMA Component;

CREATE TABLE Product.Product
      (Product_ID INT PRIMARY KEY,
	   Product_name NVARCHAR(100) NOT NULL,
	   QuantityOnHand INT
	  );

CREATE TABLE Component.Supplier
     (Supplier_ID INT PRIMARY KEY,
	  Supplier_name NVARCHAR(100) NOT NULL,
	  Activation_status BIT NOT NULL
     ); 

CREATE TABLE Component.Component
     (Component_ID INT PRIMARY KEY,
	  Component_name NVARCHAR(100) NOT NULL,
	  Description NVARCHAR(MAX),
	  QuantityOnHand INT,
	  Supplier_ID INT,
	  FOREIGN KEY (Supplier_ID) REFERENCES Component.Supplier(Supplier_ID)
	 );

CREATE TABLE Component.ComponentSupplier
     (Component_ID INT,
	  Supplier_ID INT,
	  QuantitySupplied INT,
	  SupplyDate DATE,
	  PRIMARY KEY (Component_ID, Supplier_ID),
	  FOREIGN KEY (Component_ID) REFERENCES Component.Component(Component_ID),
	  FOREIGN KEY (Supplier_ID) REFERENCES Component.Supplier(Supplier_ID)
	 );

CREATE TABLE Product.ProductComponent
     (Product_ID INT,
	  Component_ID INT,
	  QuantityUsed INT,
	  PRIMARY KEY (Product_ID, Component_ID),
	  FOREIGN KEY (Product_ID) REFERENCES Product.Product(Product_ID),
	  FOREIGN KEY (Component_ID) REFERENCES Component.Component(Component_ID)
	 );