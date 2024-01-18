################################################################################
##                          HOMEWORK ASSIGNMENT 2                             ##
################################################################################
# NAME: ANASUYA SIKDAR
# STUDENT_ID: 2114173
# SUBMISSION DATE: 01/27/2023
# This homework assignment is to test your knowledge on Database design

################################################################################
##                           Atazon Database                                  ##
################################################################################
options(warn=-1) # R function to turn off warnings
library(sqldf)

# Please note that it is required to checkin with the instructor in Week 3-4 to ensure
# you are on the correct path to submit Assignment 2
# Please see the instructions for checkin on D2L

# This script is based on the Atazon scenario!
# Use the caselet description from Assignment 1 and questions from Assignment 2 (on D2L) 
# to write queries using SQL

################################################################################
#                            Step 1: CREATE DATABASE
################################################################################

# Step 1: Create a new database in SQL (using R). Name the database as ATAZONdb.sqlite.

# Use dbConnect() to create a new database connection
# syntax: db <- dbconnect(SQLite(), dbname = "<databasename>.sqlite")

db <- dbConnect(SQLite(), dbname="ATAZONdb.sqlite") # fill in the missing second argument

################################################################################
#                            Step 2: CREATE TABLES
################################################################################

# Step 2: Create all the tables in your relational database using CREATE
# TABLE statement. Include all the constraints included in the relational schema.

# Next, specify your table name, i.e., CUSTOMER, PRODUCT, CUSTOMER_PRODUCT, TRANSACTION, CONTAINS 
# CONTAINS table is the table for M:N relationship between PRODUCT and TRANSACTION
# CUSTOMER_PRODUCT table is for multi-value attribute {customer_id} in PRODUCT table

############################# CREATE TABLE STATEMENTS ###########################

# Syntax: CREATE TABLE <TABLE NAME>
#            (<column name 1> <datatype> <constraint1> <constraint2>,
#             <column name 2> <datatype> <constraint3>,
#             <column name 3> <datatype> <constraint4>)

# ****************************** Q1: CUSTOMER table ****************************

# Start with CUSTOMER table, as it has no foreign key 

# CUSTOMER table has customer_id (INTEGER), name (TEXT), age (INTEGER), gender 
#   (TEXT) and zipcode (INTEGER) as its columns
# Note the following constraints-
# 1. Primary key for CUSTOMER table is customer_id
# 2. Default value for age is 99
# 3. Name and zipcode are not null


sqldf("CREATE TABLE CUSTOMER
        (customer_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER DEFAULT 99,
        gender TEXT,
        zipcode INTEGER NOT NULL
         )",dbname="ATAZONdb.sqlite")



# ****************************** Q2: PRODUCT table *****************************

# Now, let's create PRODUCT table

# PRODUCT table has product_id (INTEGER), product_name (TEXT) and price (REAL) as its columns
# Note the following constraints-
# 1. Primary key for PRODUCT table is product_id
# 2. Product_name and price cannot be null

sqldf("CREATE TABLE PRODUCT
        (product_id INTEGER PRIMARY KEY,
        product_name TEXT NOT NULL,
        price REAL NOT NULL
        )",dbname="ATAZONdb.sqlite")



# ****************************** Q3: CUSTOMER_PRODUCT table ********************

# Now, let's create CUSTOMER_PRODUCT table which references customer_id and product_id
# from CUSTOMER and PRODUCT tables respectively

# CUSTOMER_PRODUCT table has product_id (INTEGER), customer_id (INTEGER) as its columns
# Note the following constraints-
# 1. Primary key for CUSTOMER_PRODUCT table is product_id, customer_id
# 2. product_id is a foreign key, which references product_id of PRODUCT table
# 3. customer_id is a foreign key, which references customer_id of CUSTOMER table

# Syntax for foreign key : <column name> <datatype> REFERENCES <TABLE NAME>(<column name>) 

sqldf("CREATE TABLE CUSTOMER_PRODUCT
        (product_id INTEGER REFERENCES PRODUCT(product_id),
        customer_id INTEGER REFERENCES CUSTOMER(customer_id),
        PRIMARY KEY
        (product_id,customer_id)
        )",dbname="ATAZONdb.sqlite")



# ****************************** Q4: TRANSACTION1 table ************************

# Now, let's create TRANSACTION1 table which references customer_id and product_id
# from CUSTOMER and PRODUCT table respectively

# TRANSACTION keyword has a predefined meaning and cannot be used as a table name
# Therefore, we will use TRANSACTION1 as the tablename

# TRANSACTION1 table has purchase_id (INTEGER), customer_id (INTEGER), product_id (INTEGER),
#  date_of_purchase (TEXT) and if_returned (TEXT) as its columns
# Note the following constraints-
# 1. Primary key for TRANSACTION1 table is purchase_id
# 2. customer_id and product_id cannot be null
# 3. customer_id is a foreign key, which references customer_id of CUSTOMER table
# 4. product_id is a foreign key, which references product_id of PRODUCT table
# 5. Default value for if_returned is 'N';

sqldf("CREATE TABLE TRANSACTION1
        (purchase_id INTEGER PRIMARY KEY,
        customer_id INTEGER NOT NULL REFERENCES CUSTOMER(customer_id),
        product_id INTEGER NOT NULL REFERENCES PRODUCT(product_id),
        date_of_purchase TEXT,
        if_returned TEXT DEFAULT 'N'
        )",dbname="ATAZONdb.sqlite")


# ****************************** Q5: CONTAINS table ****************************

# Last, let's create the CONTAINS table that references purchase_id and product_id table

# CONTAINS table has contains_id (INTEGER), purchase_id (INTEGER), and product_id (INTEGER) as is columns
# Note the following constraints
# 1. Primary key for CONTAINS table is contains_id
# 2. purchase_id and product_id cannot be null
# 3. purchase_id is a foreign key, which references purchase_id of TRANSACTION1 table
# 4. product_id is a foreign key, which references product_id of PRODUCT table

sqldf("CREATE TABLE CONTAINS
        (contains_id INTEGER PRIMARY KEY,
        purchase_id INTEGER NOT NULL REFERENCES TRANSACTION1(purchase_id),
        product_id INTEGER NOT NULL REFERENCES PRODUCT(product_id)
        )",dbname="ATAZONdb.sqlite")


############################ Q6: VERIFYING RELATIONAL SCHEMA ###################

# Let's verify the structure of the database ATAZON
# fill in the missing part of the statement

# Syntax: pragma table_info(<TABLE NAME>)

# CUSTOMER table

sqldf("pragma table_info(CUSTOMER)",dbname="ATAZONdb.sqlite")

# PRODUCT table

sqldf("pragma table_info(PRODUCT)",dbname="ATAZONdb.sqlite")

# CUSTOMER_PRODUCT table

sqldf("pragma table_info(CUSTOMER_PRODUCT)",dbname="ATAZONdb.sqlite")

# TRANSACTION1 table

sqldf("pragma table_info(TRANSACTION1)",dbname="ATAZONdb.sqlite")

# CONTAINS table

sqldf("pragma table_info(CONTAINS)",dbname="ATAZONdb.sqlite")

################################################################################
#                            Step 3: INSERT DATA
################################################################################

# After creating a relational DB and tables, we are ready to insert data into our
# database 

# To insert data into the tables use INSERT INTO statement

# Syntax: INSERT INTO <table name> VALUES (<value 1>,<value 2>,<value 3>...)

# ****************************** Q7: CUSTOMER table *****************************

# Let's insert values into CUSTOMER TABLE
# use INSERT INTO statement for inserting following two rows
# 1,'Mary',28, 'F',60208
# 2,'Liz', 18, 'F',60201

sqldf(c("INSERT INTO CUSTOMER VALUES (1,'Mary',28,'F',60208)",
        "INSERT INTO CUSTOMER VALUES (2,'Liz', 18, 'F',60201)"
      ),dbname="ATAZONdb.sqlite")

sqldf("SELECT * FROM CUSTOMER",
      dbname="ATAZONdb.sqlite")

# ****************************** Q8: PRODUCT table *****************************

# Let's insert values into PRODUCT TABLE
# use INSERT INTO statement for inserting following two rows
# 1,'book',15
# 2,'pen',2


sqldf(c("INSERT INTO PRODUCT VALUES (1,'book',15)",
        "INSERT INTO PRODUCT VALUES (2,'pen',2)"
      ),dbname="ATAZONdb.sqlite")


sqldf("SELECT * FROM PRODUCT",
      dbname="ATAZONdb.sqlite")

# ****************************** Q9: CUSTOMER_PRODUCT table ********************

# Let's insert values into CUSTOMER_PRODUCT TABLE
# use INSERT INTO statement for inserting following three rows
# 1,1
# 2,1
# 2,2

sqldf(c("PRAGMA foreign_keys=on",
        "INSERT INTO CUSTOMER_PRODUCT VALUES (1,1)",
        "INSERT INTO CUSTOMER_PRODUCT VALUES (2,1)",
        "INSERT INTO CUSTOMER_PRODUCT VALUES (2,2)"
),
dbname="ATAZONdb.sqlite")

sqldf("SELECT * FROM CUSTOMER_PRODUCT",
      dbname="ATAZONdb.sqlite")

# ****************************** Q10: TRANSACTION1 table ***********************

# Let's insert values into TRANSACTION1 TABLE
# use INSERT INTO statement for inserting following three rows
# 1,1,1,'2019/01/01','N'
# 2,1,2,'2018/12/10','N'
# 3,2,2,'2018/11/11','N'

sqldf(c("PRAGMA foreign_keys=on",
        "INSERT INTO TRANSACTION1 VALUES (1,1,1,'2019/01/01','N')",
        "INSERT INTO TRANSACTION1 VALUES (2,1,2,'2018/12/10','N')",
        "INSERT INTO TRANSACTION1 VALUES (3,2,2,'2018/11/11','N')"
),
dbname="ATAZONdb.sqlite")

sqldf("SELECT * FROM TRANSACTION1",
      dbname="ATAZONdb.sqlite")

# ****************************** Q11: CONTAINS table ***************************

# Let's insert values into CONTAINS TABLE
# use INSERT INTO statement for inserting following three rows
# 1,1,1
# 2,2,2
# 3,3,2

sqldf(c("PRAGMA foreign_keys=on",
        "INSERT INTO CONTAINS VALUES (1,1,1)",
        "INSERT INTO CONTAINS VALUES (2,2,2)",
        "INSERT INTO CONTAINS VALUES (3,3,2)"
),
dbname="ATAZONdb.sqlite")

sqldf("SELECT * FROM CONTAINS",
      dbname="ATAZONdb.sqlite")

# ****************************** Q12: GROUP BY and HAVING  ***************************
# Using SELECT statement, generate a report to show number of products not 
# returned GROUPED BY customer_id, HAVING number of products not returned less 
# than 3 (see template for more details). 
# You can use the same R script of Atazon.R to generate this report.

sqldf ("SELECT customer_id , COUNT (*) AS product_kept
        FROM TRANSACTION1
        WHERE if_returned = 'N'
        GROUP BY customer_id
        HAVING product_kept < 3",
       dbname ="ATAZONdb.sqlite") 


sqldf("SELECT * FROM TRANSACTION1",
      dbname="ATAZONdb.sqlite") 

################################################################################
# Please submit your R script on D2L once you have completed the assignment
################################################################################