# Тестовое задание Finstar

## Задание №1

Запрос к базе данных для вывода сотрудников у кого в работе менее 3 задач
```
select emp_name, temp.tasks_in_work from employee
left join (select assignee_id, COUNT(id) as count_t
from tasks
group by assignee_id) as test on employee.id=test.assignee_id
cross apply
(select ISNULL(count_t,0)) temp(tasks_in_work)
where tasks_in_work<3
```
Результат:

| Employee Name | Tasks in work |
| ------------- | ------------- |
| Igor  | 0  |

## Задание №2

Для начала найдем на каком этапе произошло падение конверсии. Для этого выведем значения количества и конверсию к предыдущему этапу. Основные параметры, на которые мы обратим внимание, это количество заявок в статусе  завершено "is_complited" и "page_status" в статусе "Completed page". 

```
select day_all, 
all_count,
completed_status,
(completed_status/CAST(all_count AS DEC(12,2)))*100  as conversion_completed_status_by_all,
completed_page,
(completed_page/CAST(completed_status AS DEC(12,2)))*100  as conversion_completed_page_by_status
from (
select DAY(rep_date) as day_all, 
count(page_status) as all_count 
from task2
group by rep_date) all_status
left join 
(select DAY(rep_date) as day_comp, 
count(page_status) as completed_page 
from task2
where page_status='Completed page'
group by rep_date) comp_status 
on comp_status.day_comp=all_status.day_all
left join 
(select DAY(rep_date) as day_comp, 
count(page_status) as completed_status 
from task2
where is_completed=1
group by rep_date) is_comp_status
on is_comp_status.day_comp=all_status.day_all
order by day_all
```

| Day | Count all | Count "is_completed" | Conversion "is_completed" by all | Count "completed page" | Conversion "Completed page by status" |
| :-: | :-------: | :------------------: | :------------------------------: | :------------: | :---------------------------------: |
| 17 | 18211 | 12852 | 71% | 3368 | 26% |
| 18 | 18541 | 13017 | 70% | 3502 | 27% |
| 19 | 16611 | 10724 | 65% | 2842 | 27% |
| 20 | 15128 | 4059 | 27% | 930 | 23% |
| 21 | 7834 | 2325 | 30% | 502 | 22% |
| 22 | 6845 | 2326 | 34% | 466 | 20% |
| 23 | 7464 | 5350 | 72% | 1390 | 26% |
| 24 | 16341 | 11938 | 73% | 2277 | 19% |
| 25 | 14608 | 10342 | 71% | 2169 | 21% |

В этой таблице мы видим что конверсия значительно снизилась для заявок со статусом "is_completed", но при этом конверсия поподания на "Completed page" не имела большого снижения или повышения. При этом количество заявок за 20-23 мая снизилось сушествено. Вероятно что-то произошло, что по данным нет возможности отследить. При этом конверсия заявок с 65% до 27%. Для этого мы посмотрим этапы завок с каким статутсами они находятся. Начнем с "up_stage"






