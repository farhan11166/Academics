import sqlite3
import time
import random

DB_FILE = "university.db"
NUM_INSERTS = 500

con = sqlite3.connect(DB_FILE)
cur = con.cursor()

for idx_name in ["idx_enrollments_student_id", "idx_enrollments_course_id"]:
    try:
        cur.execute(f"DROP INDEX {idx_name}")
        print(f"Index {idx_name} dropped.")
    except sqlite3.OperationalError:
        print(f"Index {idx_name} did not exist.")

cur.execute("SELECT student_id FROM Students")
student_ids = [row[0] for row in cur.fetchall()]

cur.execute("SELECT course_id FROM Courses")
course_ids = [row[0] for row in cur.fetchall()]

def random_grade():
    return round(random.uniform(0, 10), 2)

start_time = time.time()

for _ in range(NUM_INSERTS):
    student_id = random.choice(student_ids)
    course_id = random.choice(course_ids)
    grade = random_grade()
    cur.execute(
        "INSERT INTO Enrollments (student_id, course_id, grade) VALUES (?, ?, ?)",
        (student_id, course_id, grade)
    )

con.commit()
end_time = time.time()
print(f"Time to insert {NUM_INSERTS} rows without indexes: {end_time - start_time:.6f} seconds")

con.close()