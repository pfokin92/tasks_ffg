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

 | day_all | all_count | completed_status | conversion_completed_status_by_all | completed_page | conversion_completed_page_by_status | disbursed_status | conversion_disbursed_by_completed_page |
 | 17 | 18211 | 12852 | 70,573 | 3368 | 26,20603797 | 716 | 21,25890736 |
 | 18 | 18541 | 13017 | 70,207 | 3502 | 26,90328033 | 773 | 22,07310109 |
 | 19 | 16611 | 10724 | 64,560 | 2842 | 26,50130548 | 558 | 19,63406052 |
 | 20 | 15128 | 4059 | 26,831 | 930 | 22,9120473 | 355 | 38,17204301 |
 | 21 | 7834 | 2325 | 29,678 | 502 | 21,59139785 | 167 | 33,26693227 |
 | 22 | 6845 | 2326 | 33,981 | 466 | 20,03439381 | 137 | 29,39914163 |
 | 23 | 7464 | 5350 | 71,677 | 1390 | 25,98130841 | 311 | 22,37410072 |
 | 24 | 16341 | 11938 | 73,056 | 2277 | 19,07354666 | 845 | 37,11023276 |
 | 25 | 14608 | 10342 | 70,797 | 2169 | 20,97273255 | 684 | 31,53526971 |
