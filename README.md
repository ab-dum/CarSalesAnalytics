# Term1

## The Aim of The Project
In this project, it is aimed to find answers to some analytical questions about employee performance and car sales upon the request of a automobile company in 2023. For this purpose, a relational database consisting of **7 tables** was created and the analyzes were created with MYSQL, a relational data base management system. The project consists of **3 main headings** in total. The first part is related to creating tables, associating them and loading data. While the second part seeks answers to the analytical questions requested by the HR department, the third part aims to answer the analytical questions requested by the sales department. Please note that since I think this dataset was created randomly, logical meanings should not be attributed to the data contents.

## PART 1: Creating The Relational Tables and Loading The Dataset (Operational Layer)
In the first step of this section, a database named **Term1** was created. Then, tables named **category, customer, employee, orders, cars, provider and store** were created. Columns in the tables are assigned according to their data types (VARCHAR, INT etc.) and character lengths. In order to upload data securely from the local computer, the `secure_file_priv` command is set to `NOT NULL` and the `local_infile` command is set to `ON`. The data set to be uploaded to MYSQL Workbench was downloaded to the local computer in .csv format from [kaggle website](https://www.kaggle.com/datasets/grncode/automotive-sector-compherensive-business-data-2023/data). The tables were created one by one and in order to avoid receiving an error code, the foreing key was deactivated with the command `SET FOREIGN_KEY_CHECKS=0;` and after the data was loaded, it was reactivated with `SET FOREIGN_KEY_CHECKS=1;`. After all the tables were created, the **EER Diagram** in the picture below was obtained by using the MYSQL>Database>Reverse Engineer commands to see the relationships between the tables (Primary Keys, Foreign Keys, etc.) and to check the data types. In this way, we create our Online Transaction Processing Systems (OLTP) for the project.

![Term1_EER_Diagram](https://github.com/ab-dum/Term1/assets/141356115/9e44246c-f6f7-4352-8776-424f2564c6ed)


## PART 2: Employee Performance Analysis (Analytical Layer I)
In this section, answers are sought to the following analytic questions that the HR department generally requests answers to.

**1.** What is the list of employees who have sold more than 8 vehicles and are actively working in the company?

**2.** What is the number and list of Polish employees whose sales return to the company is more than $10000?

**3.** What are the cities and countries of the employees who have sold sports cars worth more than 20000 dollars?

### Creating Data Warehouse With ETL Process For Employee Performance Analysis
To answer these questions, firstly, a store procedure named **EmployeePerformanceStore** was created to pull the data into the data warehouse. This also means implementing the **ETL** (Extract, Transform and Load) process. The `SELECT` section in the code block represents the **Extract**, `cars.car_price * orders.order_quantity AS EmployeeTotalReturn` represents the transform, and 'CREATE TABLE employee_performance AS' represents the load process. This information drawn into the data warehouse is combined in the table named **employee_performance.** In this table, the columns `EmployeeId, EmployeeFirstName, EmployeeLastName, EmployeeStatus, EmployeeCity and EmployeeCountry` which contain the personal information of the employees, represent the **fact part**, and the other columns represent the **dimensions** of the table. By means of this table, we collect only the information we will need in the analytical part in a single table. We run the store procedure with the `CALL EmployeePerformanceStore();` command. The employee performance table created in Data Warehouse can be seen below.

![Screenshot 2023-11-12 at 16 35 37](https://github.com/ab-dum/Term1/assets/141356115/85e46446-3b68-4498-a229-0dcc9b40a72b)

### Event Scheduler for EmployeePerformanceStore
In order not to call this stored procedure in every transaction we make, an **Event Scheduler** named **EmployeePerformanceStoreEvent** has been created to call this procedure every 1 minute within 1 hour. Additionally, a **message table** named **messages_HR** was created in order to track the history of this event.

### Trigger as Event For EmployeePerformanceStore
A trigger named **new_employee_insert** was created to prevent subsequent operations such as INSERT, DELETE on the data set from updating the data in the data warehouse. Thus, every change made in the employee table will keep the employee_performance table in the data warhouse updated. To check this, when we make random inserts into the employee, category, cars and orders tables and call the EmployeePerformanceStore procedure. As can be seen in the table below, when we insert the new data with the code block, the **employee_performance** table in the data warehose will also be updated.

``` sql
INSERT INTO employee VALUES(3, 534, 'Okan', 'Buruk', '2013-07-04','328-098-48', 'okanburuk@example.com', 'Off', 43567, 'Istanbul','Turkey');
INSERT INTO category  VALUES('XBD', 3, 'Hatch Back', 28, 45895, 5803477);
INSERT INTO cars VALUES(12605, 'Pr7078', 'XBD', 'Tesla', 'X90', '1995', 'Red', 4356459, 320985);
INSERT INTO orders VALUES('O32456', 4689, 12605, 534, 3,'2014-11-06','2018-10-12', '2020-06-24', 'Completed', 9);
```


![Screenshot 2023-11-12 at 16 58 29](https://github.com/ab-dum/Term1/assets/141356115/30ff89fb-7d59-4fcb-a0a4-2fadd6bc68a8)


### Data Marts For Employee Performance Analysis 
This is the part where we can find answers to our analytical questions on the **Views** section in the MYSQL Workbench. The sections that are requested to be analyzed from the employee_performance table we created with ETL are added to the Views section in MYSQL Workbench. The first created **ActiveEmp_UnitMoreThan_8** view lists the employees who have sold more than 8 vehicles and are actively working in the company, the **Emp_Poland_Return10000** view lists the Polish employees whose sales return to the company is more than 10000 dollars and the **CitiesCountires_Sold_SportsCar_Price20000** view lists the cities and countries of the employees who have sold sports vehicles with a price of more than 20000 dollars. The tables obtained with these views can be seen in the pictures below, respectively.

![Screenshot 2023-11-12 at 17 11 34](https://github.com/ab-dum/Term1/assets/141356115/319f0b76-0ec7-4791-b267-93e188d6ecfe)

![Screenshot 2023-11-12 at 17 11 55](https://github.com/ab-dum/Term1/assets/141356115/740b082e-e7f2-40fc-a328-af0a4239a51b)

![Screenshot 2023-11-12 at 17 12 36](https://github.com/ab-dum/Term1/assets/141356115/27cbe5b5-4d20-4287-8a92-bce87a0bbfe2).

### Testing
Testing is one of the important parts of the project. Used to keep the analytical data set updated and checked. In this section, the number of rows of emp_poland_return10000 views is tested, which is currently **6**. Any change in the number of rows returns `False`.

## PART 3: Car Sales Analysis(Analytical Layer II)
In this section, answers to the following analytic questions that the Sales department generally requests answers to are sought.
 
**1.** What are the Ford vehicles sold that cost more than $20,000?

**2.** What is the number and list of electric vehicles sold between 2016-2019?

**3.** In which countries are the stores that sold more than 8 vehicles between January and March located?

### Creating Data Warehouse With ETL Process For Car Sales Analysis
As in Part 2, first a store procedure called **CarSalesStore** was created to pull the data into the data warehouse. This also means implementing the ETL (Extract, Transform and Load) process. The `SELECT` section in the code block represents the Extract, `MONTH(orders.order_date) as MonthOfYear` represents the Transform, and `CREATE TABLE car_sales AS` represents the Load process. This information drawn into the data warehouse is combined in the table named **car_sales**. In this table, the `SalesId, ,Price, and Unit` columns, which contain information about the orders, represent the **fact** part, and the other columns represent the **dimensions** of the table. By means of this table, we collect only the information we will need in the analytical part in a single table. We run the store procedure with the `CALL CarSalesStore();` command. The car_sales table created in Data Warehouse can be seen below.

![Screenshot 2023-11-12 at 17 30 28](https://github.com/ab-dum/Term1/assets/141356115/6e9708e3-55c9-4555-9ba1-dd6e405ac5a2).

### Event Scheduler For CarSalesStore
In order not to call this stored procedure in every transaction we make, an **Event Scheduler** named **CarSalesStoreEvent** has been created to call this procedure every 1 minute within 1 hour. Additionally, a **message table** named **messages_sales** was created in order to track the history of this event.

### Trigger as Event For CarSalesStore
A trigger named **new_order_insert** was created to prevent subsequent operations such as INSERT, DELETE on the data set from updating the data in the data warehouse. Thus, every change made in the employee table will keep the car_sales table in the data warhouse updated. To check this, when we make random inserts into the **orders, category, cars and store** tables and call the CarSalesStore procedure. As can be seen in the table below, when we insert the new data with the code block, the **car_sales** table in the data warehose will also be updated.

``` sql
INSERT INTO orders VALUES('1', 4351, 12606, 971, 24,'2019-11-06','2020-10-12', '2021-06-24', 'Completed', 5);
INSERT INTO cars VALUES(12606, 'Pr7077', 'XBC', 'Tofas', 'Kartal', '1991', 'DarkGray', 4356454, 13545);
INSERT INTO category  VALUES('XBC', 24, 'Sedan', 20, 45892, 5803478);
INSERT INTO store  VALUES(971, 24, 'Whatsons Place', '342-467-863', 'Nagazaki', 'Japan', 'whatson3427@example.com', 4921);
```


![Screenshot 2023-11-12 at 21 05 38](https://github.com/ab-dum/Term1/assets/141356115/4b2bd82a-3d2d-45bb-a058-74131b189444)

### Data Marts For Car Sales Analysis
The first created **Price_Ford_More_Than_20000** view shows the Ford brand vehicles sold with a price of more than 20000 dollars, the **Electric_Car_Btw_2016and2019** view shows the number and list of electric vehicles sold between 2016-2019, and the **Countries_SoldMoreThan8_JanuarytoMarch** view shows the stores that sold more than 8 vehicles between January and March. shows that it is. The tables obtained with these views can be seen in the pictures below, respectively.

![Screenshot 2023-11-12 at 21 13 22](https://github.com/ab-dum/Term1/assets/141356115/6b7f6653-9930-4eea-88fc-26c64b6cb2b2)

![Screenshot 2023-11-12 at 21 13 35](https://github.com/ab-dum/Term1/assets/141356115/0ff688dc-059f-4e2f-a526-1052ab453435)

![Screenshot 2023-11-12 at 21 14 14](https://github.com/ab-dum/Term1/assets/141356115/387d797e-9b3d-48cd-a812-cbb3451c077b)
