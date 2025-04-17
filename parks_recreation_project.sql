select  s.employee_id, s.first_name, s.last_name, s.occupation, pd.department_id
from employee_demographics d
right join employee_salary s
on d.employee_id = s.employee_id
inner join parks_departments pd
on s.dept_id = pd.department_id
;

select first_name, last_name
from employee_demographics

UNION distinct
select first_name, last_name
from employee_salary 
;

select first_name, length(first_name), upper(last_name), lower(first_name), 
                    trim('    chaimaa'), substring(birth_date, 6,2),
                    replace(first_name, "Tom", "Jerry"), locate("An", first_name),
                    concat(first_name, ' ' , last_name),
case
	when age < 30 then 'Young'
    when age between 30 and 50 then "Old"
    when age >= 50 then "Death's on door"
end As Age_brackets
from employee_demographics
;


select first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07
    
END as New_salary,
 
CASE 
	WHEN dept_id = 6 THEN salary * 1.1
END AS Bonus
from employee_salary
;
# common table expressions CTEs
WITH CTE_EXAMPLE AS
( select employee_id, gender, birth_date
from employee_demographics
where birth_date > '1986-01-01'
)
select * 
from CTE_EXAMPLE
;

create temporary table salary_over_50k
select *
from employee_salary
where salary >= 50000
;
select *
from salary_over_50k
;

# Store Procedures
create procedure large_salaries()
select *
from employee_salary
where salary >= 50000
;

CALL parks_and_recreation.large_salaries() 

