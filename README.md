# Term1

## The Aim of The Project
In this project, it is aimed to find answers to some analytical questions about employee performance and car sales upon the request of a automobile company in 2023. For this purpose, a relational database consisting of **7 tables** was created and the analyzes were created with MYSQL, a relational data base management system. The project consists of **3 main headings** in total. The first part is related to creating tables, associating them and loading data. While the second part seeks answers to the analytical questions requested by the HR department, the third part aims to answer the analytical questions requested by the sales department. Please note that since I think this dataset was created randomly, logical meanings should not be attributed to the data contents.

## PART 1: Creating The Relational Tables and Loading The Dataset
In the first step of this section, a database named **Term1** was created. Then, tables named **category, customer, employee, orders, cars, provider and store** were created. Columns in the tables are assigned according to their data types (VARCHAR, INT etc.) and character lengths. In order to upload data securely from the local computer, the `secure_file_priv` command is set to `NOT NULL` and the `local_infile` command is set to `ON`. The data set to be uploaded to MYSQL Workbench was downloaded to the local computer in .csv format from [kaggle website](https://www.kaggle.com/datasets/grncode/automotive-sector-compherensive-business-data-2023/data). The tables were created one by one and in order to avoid receiving an error code, the foreing key was deactivated with the command `SET FOREIGN_KEY_CHECKS=0;` and after the data was loaded, it was reactivated with `SET FOREIGN_KEY_CHECKS=1;`. After all the tables were created, the **EER Diagram** in the picture below was obtained by using the MYSQL>Database>Reverse Engineer commands to see the relationships between the tables (Primary Keys, Foreign Keys, common columns, etc.) and to check the data types. In this way, we create our Online Transaction Processing Systems (OLTP) for the project.

![Term1_EER_Diagram](https://github.com/ab-dum/Term1/assets/141356115/9e44246c-f6f7-4352-8776-424f2564c6ed)


## PART 2: Employee Performance Analysis
In this section, answers are sought to the following questions that the HR department generally requests answers to.

**1.** What is the list of employees who have sold more than 8 vehicles and are actively working in the company?

**2.** What is the number and list of Polish employees whose sales return to the company is more than $10000?

**3.** What are the cities and countries of the employees who have sold sports cars worth more than 20000 dollars?

### Creating Data Warehouse With ETL Process
First, a store procedure named **EmployeePerformanceStore** was created to pull the data into the data warehouse. This also means implementing the **ETL** (Extract, Transform and Load) process. The `SELECT` section in the code block represents the **Extract**, `cars.car_price * orders.order_quantity AS EmployeeTotalReturn` represents the transform, and 'CREATE TABLE employee_performance AS' represents the load process. This information drawn into the data warehouse is combined in the table named **employee_performance.** In this table, the columns `EmployeeId, EmployeeFirstName, EmployeeLastName, EmployeeStatus, EmployeeCity and EmployeeCountry` which contain the personal information of the employees, represent the **fact part**, and the other columns represent the **dimensions** of the table. By means of this table, we collect only the information we will need in the analytical part in a single table. We run the store procedure with the `CALL EmployeePerformanceStore();` command. The employee performance table created in Data Warehouse can be seen below.

![Screenshot 2023-11-12 at 16 35 37](https://github.com/ab-dum/Term1/assets/141356115/24278f6f-cd8c-421a-b448-349e3ebad7cb)

### Event to schedule ETL jobs
In order not to call this stored procedure in every transaction we make, an **Event Scheduler** named **EmployeePerformanceStoreEvent** has been created to call this procedure every 1 minute within 1 hour. Additionally, a **message table** named **messages_HR** was created in order to track the history of this event.

### Trigger as Event
A trigger named **new_employee_insert** was created to prevent subsequent operations such as INSERT, DELETE on the data set from updating the data in the data warehouse. Thus, every change made in the employee table will keep the employee performance table in the data warhouse updated. To check this, when we make random inserts into the employee, category, cars and orders tables and call the EmployeePerformanceStore procedure. As can be seen in the table below, when we insert the new data with the 
```INSERT INTO employee VALUES(3, 534, 'Okan', 'Buruk', '2013-07-04','328-098-48', 'okanburuk@example.com', 'Off', 43567, 'Istanbul', 'Turkey');
INSERT INTO category  VALUES('XBD', 3, 'Hatch Back', 28, 45895, 5803477);
INSERT INTO cars VALUES(12605, 'Pr7078', 'XBD', 'Tesla', 'X90', '1995', 'Red', 4356459, 320985);
INSERT INTO orders VALUES('O32456', 4689, 12605, 534, 3,'2014-11-06','2018-10-12', '2020-06-24', 'Completed', 9);```
code block, the employee_performance table in the data warehose will also be updated.

DATA MARTS
This is the part where we can find answers to our analytical questions with the VIEW command. The sections that are requested to be analyzed from the employee_performance table we created with ETL are added to the Views section in MYSQL Workbench. The first created ActiveEmp_UnitMoreThan_8 view lists the employees who have sold more than 8 vehicles and are actively working in the company, the Emp_Poland_Return10000 view lists the Polish employees whose sales return to the company is more than 10000 dollars, the CitiesCountires_Sold_SportsCar_Price20000 view lists the cities and towns of the employees who have sold sports vehicles with a price of more than 20000 dollars. shows their countries. The tables obtained with these views can be seen in the pictures below, respectively.

TESTING
In this section, the number of rows of emp_poland_return10000 views is tested, which is currently 6. Any change in the number of rows returns False.

PART 3: CAR SALES
In this section, answers to the following questions that the Sales department generally requests answers to are sought.

1. What are the Ford vehicles sold that cost more than $20,000?

2. What is the number and list of electric vehicles sold between 2016-2019?

3. In which countries are the stores that sold more than 8 vehicles between January and March located?

As in Part 2, first a store procedure called CarSalesStore was created to pull the data into the data warehouse. This also means implementing the ETL (Extract, Transform and Load) process. The 'SELECT' section in the code block represents the Extract, 'MONTH(orders.order_date) as MonthOfYear' represents the transform, and 'CREATE TABLE car_sales AS' represents the load process. This information drawn into the data warehouse is combined in the table named car_sales. In this table, the SalesId, ,Price, and Unit columns, which contain information about the orders, represent the fact part, and the other columns represent the dimensions of the table. By means of this table, we collect only the information we will need in the analytical part in a single table. We run the store procedure with the `CALL CarSalesStore();` command.

EVENT SCHEDULER
However, in order not to call this stored procedure in every transaction we make, an Event named CarSalesStoreEvent has been created to call this procedure every 1 minute within 1 hour. Additionally, a message table named messages_sales was created in order to track the history of this event.

TRIGGERS
A trigger named new_order_insert was created to prevent subsequent operations such as INSERT, DELETE on the data set from updating the data in the data warehouse. Thus, every change made in the employee table will keep the car_sales table in the data warhouse updated. To check this, when we make random inserts into the orders, cars, category and store tables and call the CarSalesStore procedure, it can be seen that the car_sales table is updated with the `SELECT * FROM car_sales ORDER BY SalesId;` command.

DATA MARTS
This is the part where we can find answers to our analytical questions with the VIEW command. The sections that need to be analyzed from the car_sales table we created with ETL are added to the Views section in MYSQL Workbench. The first created Price_Ford_More_Than_20000 view shows the Ford vehicles sold with a price of more than 20000 dollars, the Electric_Car_Btw_2016and2019 view shows the number and list of electric vehicles sold between 2016-2019, and the Countries_SoldMoreThan8_JanuarytoMarch view shows the stores that sold more than 8 vehicles between January and March. shows that it is. The tables obtained with these views can be seen in the pictures below, respectively.
