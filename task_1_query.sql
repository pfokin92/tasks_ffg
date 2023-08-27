use FFG
select emp_name, temp.tasks_in_work from employee
left join (select assignee_id, COUNT(id) as count_t
from tasks
group by assignee_id) as test on employee.id=test.assignee_id
cross apply
(select ISNULL(count_t,0)) temp(tasks_in_work)
where tasks_in_work<3









