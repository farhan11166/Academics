import psycopg2

def connect_db():
    try:
        conn = psycopg2.connect(
            host="localhost",
            port=5432,
            database="studentdb",
            user="postgres",
            password="admin123"
        )
        print("✅ Connected to the database successfully!")
        return conn
    except Exception as e:
        print("❌ Connection failed:", e)
        exit(1)


# Task 1: Create Table (DDL)
def create_table(conn):
    cur = conn.cursor()
    table_name = input("Enter table name: ")
    print("Example: id SERIAL PRIMARY KEY, name VARCHAR(50), age INT, department VARCHAR(50)")
    columns = input("Enter column definitions: ")
    try:
        cur.execute(f"CREATE TABLE {table_name} ({columns});")
        conn.commit()
        print(f"✅ Table '{table_name}' created successfully!")

        # Confirm creation
        cur.execute(f"SELECT table_name FROM information_schema.tables WHERE table_schema='public';")
        print("\n📋 Tables in database:")
        for t in cur.fetchall():
            print("-", t[0])
    except Exception as e:
        print("❌ Error creating table:", e)
        conn.rollback()
    cur.close()


# Task 2: Insert / Update / Delete
def insert_student(conn):
    cur = conn.cursor()
    try:
        n = int(input("How many students do you want to insert? "))
        for _ in range(n):
            name = input("Name: ")
            age = int(input("Age: "))
            dept = input("Department: ")
            cur.execute("INSERT INTO Students (name, age, department) VALUES (%s, %s, %s)", (name, age, dept))
        conn.commit()
        print("✅ Students inserted successfully!")
    except Exception as e:
        print("❌ Error inserting students:", e)
        conn.rollback()
    cur.close()


def update_student(conn):
    cur = conn.cursor()
    try:
        name = input("Enter student name to update department: ")
        new_dept = input("Enter new department: ")
        cur.execute("UPDATE Students SET department=%s WHERE name=%s", (new_dept, name))
        conn.commit()
        print("✅ Department updated successfully!")
    except Exception as e:
        print("❌ Error updating:", e)
        conn.rollback()
    cur.close()


def delete_student(conn):
    cur = conn.cursor()
    try:
        sid = int(input("Enter student ID to delete: "))
        cur.execute("DELETE FROM Students WHERE id=%s", (sid,))
        conn.commit()
        print("✅ Student deleted successfully!")
    except Exception as e:
        print("❌ Error deleting student:", e)
        conn.rollback()
    cur.close()


# Task 3: Queries
def query_data(conn):
    cur = conn.cursor()
    print("""
Query Options:
1. Show all students
2. Show students by department
3. Average age by department
4. Students whose names start with a letter
""")
    choice = input("Enter your choice: ")

    try:
        if choice == '1':
            cur.execute("SELECT * FROM Students;")
        elif choice == '2':
            dept = input("Enter department: ")
            cur.execute("SELECT * FROM Students WHERE department=%s;", (dept,))
        elif choice == '3':
            cur.execute("SELECT department, AVG(age) FROM Students GROUP BY department;")
        elif choice == '4':
            letter = input("Enter starting letter: ")
            cur.execute("SELECT * FROM Students WHERE name LIKE %s;", (letter + '%',))
        else:
            print("❌ Invalid option")
            return

        rows = cur.fetchall()
        print("\n📊 Results:")
        for row in rows:
            print(row)
    except Exception as e:
        print("❌ Error executing query:", e)
    cur.close()


# Task 4 & 5: Menu + Cleanup
def main():
    conn = connect_db()

    while True:
        print("""
========= MENU =========
1. Create Table
2. Insert Student
3. Update Student
4. Delete Student
5. Query Data
6. Exit
========================
""")
        choice = input("Enter your choice: ")

        if choice == '1':
            create_table(conn)
        elif choice == '2':
            insert_student(conn)
        elif choice == '3':
            update_student(conn)
        elif choice == '4':
            delete_student(conn)
        elif choice == '5':
            query_data(conn)
        elif choice == '6':
            print("👋 Exiting... Closing connection.")
            conn.close()
            break
        else:
            print("❌ Invalid choice, try again.")


if __name__ == "__main__":
    main()
