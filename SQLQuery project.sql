create Database SQLPROJECT

use SQLPROJECT

CREATE TABLE Trainee (
  trainee_id INT PRIMARY KEY,
  name VARCHAR(60),
  gender VARCHAR(10),
  email VARCHAR(100),
  background VARCHAR(80)
);

CREATE TABLE Trainer (
  trainer_id INT PRIMARY KEY,
  name VARCHAR(60),
  specialty VARCHAR(90),
  phone VARCHAR(20),
  email VARCHAR(100)
);

CREATE TABLE Course (
  course_id INT PRIMARY KEY,
  title VARCHAR(90),
  category VARCHAR(90),
  dur_hrs INT,
  level VARCHAR(20)
);

CREATE TABLE Schedule (
  schedule_id INT PRIMARY KEY,
  course_id INT,
  trainer_id INT,
  time_slot VARCHAR(20),
  st_date DATE,
  end_date DATE,
  FOREIGN KEY (course_id) REFERENCES Course(course_id),
  FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id)
);

CREATE TABLE Enrollment (
  enrollment_id INT PRIMARY KEY,
  trainee_id INT,
  course_id INT,
  enrollment_date DATE,
  FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id),
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

select * from Trainee
select * from Trainer
select * from Course

INSERT INTO Trainee VALUES
(1, 'Aisha Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'Female', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'Female', 'fatma@example.com', 'Data Science');


insert into Trainer VALUES
(1, 'Khalid Al-Maawali', 'Databases','96891234567','khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development','96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789' , 'salim@example.com')


insert INTO Course VALUES
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced')

select * from Schedule
insert INTO Schedule VALUES
(1, 1, 1,'Morning', '2025-07-01', '2025-07-10'),
(2, 2, 2,'Evening', '2025-07-05', '2025-07-20'),
(3, 3, 3,'Weekend', '2025-07-10', '2025-07-25'),
(4, 4, 1,'Morning', '2025-07-15', '2025-07-22');

select * from Enrollment
insert INTO Enrollment VALUES
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');


--#Trainee Perspective 

--1. ( Show all available courses (title, level, category))

SELECT title, level, category
FROM Course 


--2. View beginner-level Data Science courses ( Filter the course list to only show beginner-level courses in the “Data Science”  category).
--
select * from Course
--
SELECT title
from Course 
WHERE level = 'Beginner-level' and category = 'Data science'


--3. Show courses this trainee is enrolled in (Display the titles of the courses the logged-in trainee has registered for using their trainee ID. 

SELECT C.title, C.category, C.level
from Course C join Enrollment E
on C.course_id = E.course_id
where E.trainee_id = 4

-- to check 
SELECT * FROM Enrollment WHERE trainee_id = 4;
SELECT * FROM Course;
----

--4. View the schedule (start_date, time_slot) for the trainee's enrolled courses 
--Show the scheduled start dates and time slots for all the courses the trainee is enrolled in. 


SELECT S.st_date, S.time_slot
FROM Schedule S JOIN Course C 
ON S.course_id = C.course_id JOIN Enrollment E 
ON C.course_id = E.course_id
WHERE E.trainee_id = 1

--5. Count how many courses the trainee is enrolled in

SELECT COUNT(*) As course_num
FROM Enrollment 
where trainee_id =1

--6. Show course titles, trainer names, and time slots the trainee is attending 

SELECT c.title, t.name AS trainer, s.time_slot
FROM Enrollment e, Course c, Schedule s, Trainer t
WHERE e.course_id = c.course_id
  AND c.course_id = s.course_id
  AND s.trainer_id = t.trainer_id
  AND e.trainee_id = 1

--#Trainer Perspective 


--1. List all courses the trainer is assigned to
--➤ Show all course titles where the trainer is responsible for teaching, using the trainer’s ID.
-- ILL BE USING The (DISTINCT) SELECT DISTINCT statement is used to return only distinct (different) values.

SELECT DISTINCT c.title
FROM Course c JOIN Schedule s 
ON c.course_id = s.course_id
WHERE s.trainer_id = 1



--2. Show upcoming sessions (with dates and time slots) 
--➤ Display future sessions this trainer is conducting, 
--including start and end dates, and the time slot (Morning, Evening, etc.). 

--note:
--GETDATE() allows the query to be dynamic and time-aware. Each time the query is run, 
--it fetches the most up-to-date schedule information relevant to the present moment.
--To filter schedules based on the current date and time.


SELECT st_date, end_date, time_slot
FROM Schedule
WHERE trainer_id = 1 AND st_date >= GETDATE()



--3. See how many trainees are enrolled in each of your courses 
--➤ Count and display how many trainees are registered in each of the trainer’s courses. 

SELECT c.title, COUNT(e.trainee_id) AS totalnumof_trainees
FROM Course c JOIN Schedule s 
ON c.course_id = s.course_id JOIN Enrollment e 
ON c.course_id = e.course_id
WHERE s.trainer_id = 1
GROUP BY c.title



--4. List names and emails of trainees in each of your courses 
--➤ Join Enrollment and Trainee tables to list trainee details for each course taught by the trainer. 

SELECT t.name, t.email
FROM Trainee t JOIN Enrollment e 
ON t.trainee_id = e.trainee_id JOIN Schedule s 
ON e.course_id = s.course_id
WHERE s.trainer_id = 1



--5. Show the trainer's contact info and assigned courses 
--➤ Return the trainer’s phone and email along with a list of their assigned courses. 

SELECT trner.phone, trner.email, c.title
FROM Trainer trner JOIN Schedule s 
ON trner.trainer_id = s.trainer_id JOIN Course c
ON s.course_id = c.course_id
WHERE trner.trainer_id = 1




--6. Count the number of courses the trainer teaches 
--➤ Write a query to find how many different courses the trainer is teaching. 

SELECT COUNT(DISTINCT course_id) AS taught_course
FROM Schedule
WHERE trainer_id = 2


--#Admin Perspective 

--1. Add a new course (INSERT statement) 
--➤ Write an SQL INSERT command to add a new course to the Course table with details like title, category, duration, and level. 

INSERT INTO Course VALUES 
(5, 'AI Basics', 'AI', 24, 'Beginner')



--2. Create a new schedule for a trainer 
--➤ Write an INSERT statement to schedule a course by assigning a trainer, course, start/end dates, and time slot in the Schedule table. 

INSERT INTO Schedule VALUES
(5, 5, 3, 'Evening', '2025-08-01', '2025-08-10')



--3. View all trainee enrollments with course title and schedule info 
--➤ Create a joined query across Enrollment, Course, and Schedule to display which trainees are enrolled in which courses, along with scheduling info. 


SELECT t.name, c.title, s.st_date, s.time_slot
FROM Enrollment e JOIN Trainee t
ON e.trainee_id = t.trainee_id JOIN Course c
ON e.course_id = c.course_id JOIN Schedule s
ON c.course_id = s.course_id


--4. Show how many courses each trainer is assigned to 
--➤ Write a query that counts the number of courses assigned to each trainer. 

SELECT trner.name, COUNT(DISTINCT s.course_id) AS total_courses
FROM Trainer trner LEFT JOIN Schedule s 
ON trner.trainer_id = s.trainer_id
GROUP BY trner.name



--5. List all trainees enrolled in "Data Basics" 
--➤ Retrieve trainee names and emails for those enrolled in the course titled "Data Basics". 

SELECT t.name, t.email
FROM Trainee t JOIN Enrollment e 
ON t.trainee_id = e.trainee_id JOIN Course c 
ON e.course_id = c.course_id
WHERE c.title = 'Data Basics'





--6. Identify the course with the highest number of enrollments 
--➤ Write a query that ranks courses by enrollment count and displays the one with the highest number. 

SELECT TOP 1 c.title, COUNT(*) AS enrollment_count
FROM Course c JOIN Enrollment e 
ON c.course_id = e.course_id
GROUP BY c.title
ORDER BY enrollment_count DESC


--The DESC command is used to sort the data returned in descending order.



--7. Display all schedules sorted by start date 
--➤ Select all rows from the Schedule table and sort them in ascending order based on start date.

SELECT * 
FROM Schedule 
ORDER BY st_date 