DROP DATABASE IF EXISTS edx;

CREATE DATABASE edx;

USE edx;

DROP TABLE IF EXISTS records;

CREATE TABLE records (
course_id VARCHAR(300) DEFAULT NULL,
Course_Short_Title VARCHAR(300) DEFAULT NULL,
Course_Long_Title VARCHAR(300) DEFAULT NULL,
userid_DI VARCHAR(300) DEFAULT NULL,
registered INT(1) DEFAULT NULL,
viewed INT(1) DEFAULT NULL,
explored INT(1) DEFAULT NULL,
certified INT(1) DEFAULT NULL,	
Country VARCHAR(300) DEFAULT NULL,
LoE_DI VARCHAR(300) DEFAULT NULL,
YoB INT(4) DEFAULT NULL,
Age INT(3) DEFAULT NULL,
gender VARCHAR(5) DEFAULT NULL,
grade DOUBLE DEFAULT NULL,	
nevents INT(4) DEFAULT NULL,
ndays_act INT(4) DEFAULT NULL,
nplay_video VARCHAR(300) DEFAULT NULL,
nchapters INT(4) DEFAULT NULL,
nforum_posts BIGINT DEFAULT NULL,
roles VARCHAR(300) DEFAULT NULL,
incomplete_flag VARCHAR(300) DEFAULT NULL
);

truncate records;
set global local_infile = 1;
show variables like 'local_infile';
show variables like 'secure_file_priv';
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/EdX_Enrollment.csv'
INTO TABLE records

FIELDS TERMINATED BY ','

LINES terminated by '\n'

ignore 1 lines;

select * from records limit 10;
describe records;
show table status like 'records';

select * from records where grade = NULL;

select * from records where grade <=> NULL;
select * from records where grade IS NULL;

select * from records where grade <> NULL;
select * from records where grade IS NOT NULL;  

USE edx;
select count(*) from records;

alter table records
add institution VARCHAR(50),
ADD course_number VARCHAR(50),
ADD course_term VARCHAR(50);

select * from records limit 5;
select course_id from records limit 3;

SELECT course_id, SUBSTRING_INDEX(`course_id`, '/', 1) 
AS institution 
FROM records;

SELECT course_id, SUBSTRING_INDEX(SUBSTRING_INDEX(`course_id`, '/', 2), '/', - 1) 
AS course_number 
FROM records;

SELECT course_id, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(`course_id`, '/', 3), '/', - 1), '/', - 2)  
AS course_term 
FROM records;

SET SQL_SAFE_UPDATES = 0;

UPDATE records
SET
   institution = SUBSTRING_INDEX(`course_id`, '/', 1),
   course_number = SUBSTRING_INDEX(SUBSTRING_INDEX(`course_id`, '/', 2), '/', - 1),
   course_term = SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(`course_id`, '/', 3), '/', - 1), '/', - 2);
   
   select * from records limit 10;
   
   select distinct institution, course_number, course_term from edx.records;
   
   select distinct country from edx.records order by country;
   
   select distinct country from edx. records where LoE_DI = 'Doctorate' order by country;
   
   select distinct country, userid_DI from edx. records where LoE_DI = 'Doctorate';
   
   select distinct Course_Long_Title from edx.records order by country;
   
   select count(*) from edx.records where country = 'Germany';
   
   use edx;
CREATE TABLE course (
course_id VARCHAR(300) not NULL,
institution VARCHAR(300) DEFAULT NULL,
course_number VARCHAR(300) DEFAULT NULL,
course_term VARCHAR(300) DEFAULT NULL,
Course_Short_Title VARCHAR(300) DEFAULT NULL,
Course_Long_Title VARCHAR(300) DEFAULT NULL
)

select distinct
course_id, 
institution,
course_number,
course_term,
Course_Short_Title,
Course_Long_Title
FROM 
records;

select * from course limit 10;

create table users
select userid_DI, Country AS Country, LoE_DI, YoB AS 'Birth Year', Age AS Age, gender AS Gender
FROM records group by userid_DI;

select * from users limit 10;
select * from users order by Country limit 300;

create table course_users
select 
	course_id,
	userid_DI,
	registered,
	viewed,
	explored,
	certified,	
	grade,	
	nevents,
	ndays_act,
	nplay_video,
	nchapters,
	nforum_posts,
    roles,
	incomplete_flag
    from 
    records;
    
    show tables from edx;
    select * from course;
    
    alter table course
    add primary key (course_id);
    
    select * from users;
    alter table users
    add primary key (userid_DI);
    
    alter table course_users
    add constraint fk_course_id
    foreign key (course_id)
    references edx.course (course_id),
    add constraint fk_userid_DI
    foreign key (userid_DI)
    references edx.users (userid_DI);
    
    select * from course_users limit 10;
    select * from users limit 10;
    select * from course limit 10;
    
	select count(*) from course_users;
    select count(*) from users;
    select count(*) from course;
    
#PART 1
#Q1
select count(*) from course_users where
course_id = 'MITx/6.00x/2012_Fall'
AND registered = 1;

#Q2
select course_id, count(*) from course_users
where course_id = 'MITx/6.00x/2013_Spring'AND registered = 1;

#Q3
select avg(grade) from course_users
where course_id = 'MITx/6.00x/2013_Spring'; 

select avg(grade) from course_users
where course_id='MITx/6.00x/2012_Fall';
    
 #Q4
select avg(grade) from course_users
where course_id = 'MITx/6.00x/2013_Spring' 
and grade>0;

select avg(grade) from course_users
where course_id = 'MITx/6.00x/2012_Fall'
and grade>0;

#Q5
select count(*) from course_users
where course_id = 'MITx/6.00x/2013_Spring'or course_id='MITx/6.00x/2012_Fall';

#Q6
select userid_DI, count(*) from course_users
where course_id in ('MITx/6.00x/2013_Spring' , 'MITx/6.00x/2012_Fall')
group by userid_DI
having count(course_id) > 1;

#PART 2
#Q1
select count(course_id),course_id from course_users group by course_id;

#Q2
select course_id, count(*) as enrollees from course_users group by course_id;

#Q3
select course_id, count(*) as enrollees from course_users group by course_id order by enrollees desc;

#PART 3
#Q1
SELECT course.Course_Long_Title, count(*) AS enrollees
FROM course_users INNER JOIN course ON course_users.course_id = course.course_id
GROUP BY course.Course_Long_Title
ORDER BY enrollees DESC;

#Q2
select course_id, count(*) as enrollees from course_users
group by course_id
having enrollees>4000
order by enrollees desc;

#PART 4
#Q1
select
course_id,
sum(registered) Registered,
sum(viewed) Viewed,
sum(explored) Explored,
sum(certified) Certified
from course_users
group by course_id
order by sum(registered) desc;

#Q2
SELECT
course.Course_Long_Title,
sum(registered) Registered,
sum(viewed) Viewed,
sum(explored) Explored,
sum(certified) Certified
FROM course_users INNER JOIN course ON course_users.course_id = course.course_id
GROUP BY course.Course_Long_Title
ORDER BY COUNT(*) DESC;


#Q3
SELECT 
course_id, sum(viewed)/count(*) as fractionviewed,
sum(explored)/count(*) as fractionexplored, 
sum(certified)/count(*) as fractioncertified
from course_users
group by course_id;

#Q4
SELECT 
course.Course_Long_Title,
sum(viewed)/sum(registered) as fractionviewed,
sum(explored)/sum(registered) as fractionexplored, 
sum(certified)/sum(registered)as fractioncertified
from course_users INNER JOIN course ON course_users.course_id = course.course_id
group by course.Course_Long_Title;

#PART 5
#Q1
SELECT course.course_id, count(*) AS enrollees
FROM course join course_users on course.course_id=course_users.course_id
WHERE institution = 'HarvardX'
GROUP BY course_id
HAVING enrollees > 4000
ORDER BY enrollees DESC;

#Q2
SELECT 
users.userid_DI,
users.Age,
users.Country,
users.LoE_DI,
count(course_users.registered) AS Registered
from users JOIN course_users ON (users.userid_DI=course_users.userid_DI)
GROUP by userid_DI
having registered > 3
order by Registered DESC;

#Q3
SELECT Country, count(*) as enrollees
from edx.users
where Country NOT LIKE ('Unknown/Other')
group by Country
order by enrollees DESC;

#Q4
select Country, avg(Grade) as AverageGrade
from course_users join users on (course_users.userid_DI=users.userid_DI)
where certified=1
group by Country
order by AverageGrade desc;

#Q5
(select Country, avg(grade) as AverageGrade
from course_users join users on (course_users.userid_DI=users.userid_DI)
where course_users.certified=1
group by users.Country
order by AverageGrade desc limit 1)
union
(select users.Country, avg(grade) as AverageGrade
from course_users join users on (course_users.userid_DI=users.userid_DI)
where course_users.certified=1
group by users.Country
order by AverageGrade limit 1);


#PART 6
#Q1
select Country, AVG(grade) as AverageGrade
from course join course_users on (course.course_id=course_users.course_id)
join users on (course_users.userid_DI=users.userid_DI)
where institution='HarvardX' and certified=1
group by Country
order by AverageGrade desc;

#Q2
(select Country, AVG(grade) as AverageGrade
from course join course_users on (course.course_id=course_users.course_id)
join users on (course_users.userid_DI=users.userid_DI)
where institution='HarvardX' and certified=1
group by Country
order by AverageGrade desc limit 1)
union
(select Country, AVG(grade) as AverageGrade
from course join course_users on (course.course_id=course_users.course_id)
join users on (course_users.userid_DI=users.userid_DI)
where institution='HarvardX' and certified=1
group by Country
order by AverageGrade limit 1);

#Q3
(select Country, AVG(grade) as AverageGrade
from course join course_users on (course.course_id=course_users.course_id)
join users on (course_users.userid_DI=users.userid_DI)
where institution='MITx' and certified=1
group by Country
order by AverageGrade desc limit 1)
union
(select Country, AVG(grade) as AverageGrade
from course join course_users on (course.course_id=course_users.course_id)
join users on (course_users.userid_DI=users.userid_DI)
where institution='MITx' and certified=1
group by Country
order by AverageGrade limit 1);