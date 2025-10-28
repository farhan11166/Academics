# Lab 8: Python PostgreSQL DBMS Integration

This project is a Python application built for the "Programming Language with DBMS" lab. It provides a command-line interface (CLI) menu to interact with a PostgreSQL database running in a Docker container.

The program allows a user to perform full CRUD (Create, Read, Update, Delete) operations on a `studentdb` database, including table creation (DDL), data manipulation (DML), and various query operations.

## Prerequisites

Before you begin, ensure you have the following software installed on your local machine:

- **Python 3.x**
- **Docker** (Docker Desktop for Windows/Mac or Docker Engine for Linux)

## Setup Instructions

Follow these steps to set up the environment and run the application.

### 1. Start the PostgreSQL Docker Container

First, you need to pull the `postgres` image and run the container.

```bash
# 1. Pull the official PostgreSQL image
docker pull postgres

# 2. Run the container
# We use --name pg_lab to match the lab sheet's exec command
# This sets the password to "admin123" and maps the port
docker run --name pg_lab -e POSTGRES_PASSWORD=admin123 -p 5432:5432 -d postgres
# 1. Access the PostgreSQL shell (Lab Step 3)
docker exec -it pg_lab psql -U postgres

# 2. Once inside the psql shell, create the new database (Lab Step 4)
CREATE DATABASE studentdb;

# 3. (Optional) You can verify creation by listing databases
\l

# 4. Exit the psql shell
\q
# 1. (Optional) Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# 2. Install the required packages from requirements.txt
pip install -r requirements.txt
# Run the main Python script
python LAB8_FarhanAlam.py

Database Operations Menu:
1. Create Students Table
2. Insert Student
3. Update Student Department
4. Delete Student
5. Query Data
6. Exit
Enter your choice:
```
