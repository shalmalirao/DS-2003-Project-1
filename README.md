# Healthcare Data Mart ETL Pipeline
Shalmali Rao - DS 2002 Midterm Project
## Project Overview

This project implements an ETL data pipeline.
The business process modeled is medical appointments, including interactions between patients, doctors, and clinics and transforming them into a dimensional data mart for analytical queries.

The ETL workflow extracts data from three different sources, transforms and integrates it, then loads the results into a MySQL OLAP schema (healthcare_mart) following a star schema.

## Architecture Summary
### Source Systems
1. MySQL (relational database) - `healthcare_src` - SQL scripts located in `/scripts` folder 
2. MongoDB Atlas (NoSQL database) - `doctors`, `clinics` collections - JSON files located in `/data` folder
3. CSV File - `patients.csv` - CSV file located in `/data` folder
### Destination System
MySQL Schema `healthcare_mart` containing the following dimensions:
* date
* doctors
* clinics
* patients
* fact appointments

## ETL Process

All ETL code located in `etl.ipynb`
### 1. Extract
* MongoDB Atlas --> `df_doctors`, `df_clinics` via `get_mongo_dataframe()`
* MySQL --> `df_appts` using `get_sql_dataframe()`
* CSV --> loaded into MySQL via `set_dataframe()`

### 2. Transform
* Clean and rename columns
* Join doctor → department → clinic mapping
* Generate integer `DateKey` (YYYYMMDD) from appointment timestamps
* Add surrogate `AppointmentKey`

### 3. Load
* Load all dimension and fact dataframes into `healthcare_mart` using `set_dataframe()`

## Deployment 

### Overview:
All source systems (MySQL, MongoDB Atlas, and a local CSV file) were connected through the `etl.ipynb` pipeline, which runs locally in Jupyter/Python to extract, transform, and load all data into a centralized MySQL data mart (healthcare_mart) following a star schema.

### Instructions:

1. Clone the repo and install dependencies

        git clone https://github.com/shalmalirao/DS-2003-Project-1.git
        pip install -r requirements.txt


2. Set environment variables in a `.env` file and add `.env` to `.gitignore`

        MYSQL_PWD=<your_mysql_password>
        MONGODB_USERNAME=<your_mongo_user>
        MONGODB_PWD=<your_mongo_password>


3. Ensure MySQL & MongoDB Atlas Cluster are set up and running

4. Run the SQL scripts in the `/scripts` folder in MySQL

5. Run the code in `etl.ipynb`

6. Verify results
    * Check tables in healthcare_mart
    * See output from SQL SELECT statements at the end of `etl.ipynb`