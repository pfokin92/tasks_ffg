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

Полный SQL файл с запросом [SQL-task_1](task_1/task_1_query.sql) 

## Задание №2_1

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
| **20** | 15128 | 4059 | **27%** | 930 | 23% |
| **21** | 7834 | 2325 | **30%** | 502 | 22% |
| **22** | 6845 | 2326 | **34%** | 466 | 20% |
| 23 | 7464 | 5350 | 72% | 1390 | 26% |
| 24 | 16341 | 11938 | 73% | 2277 | 19% |
| 25 | 14608 | 10342 | 71% | 2169 | 21% |

В этой таблице мы видим что конверсия значительно снизилась для заявок со статусом "is_completed", но при этом конверсия попадания на "Completed page" не имела большого снижения или повышения. При этом количество заявок за 20-22 мая снизилось существенно. Вероятно что-то произошло, что по данным нет возможности отследить. При этом конверсия заявок с 65% до 27%. Для этого мы посмотрим этапы заявок с каким статусами они находятся. Начнем с "up_stage" и разделим на is_completed=0 и на is_completed=1

```
select day_17.up_stage, count_17, count_18,count_19,count_20,count_21,count_22,count_23, count_24, count_25
from (select up_stage, count(page_status) as count_17 from task2
where DAY(rep_date)=17 and is_completed=0
group by up_stage) day_17
join (select up_stage, count(page_status) as count_18 
from task2
where DAY(rep_date)=18  and is_completed=0
group by up_stage) day_18
on day_18.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_19 
from task2
where DAY(rep_date)=19  and is_completed=0
group by up_stage) day_19
on day_19.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_20 
from task2
where DAY(rep_date)=20  and is_completed=0
group by up_stage) day_20
on day_20.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_21 
from task2
where DAY(rep_date)=21  and is_completed=0
group by up_stage) day_21
on day_21.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_22
from task2
where DAY(rep_date)=22
group by up_stage) day_22
on day_22.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_23
from task2
where DAY(rep_date)=23  and is_completed=0
group by up_stage) day_23
on day_23.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_24
from task2
where DAY(rep_date)=24  and is_completed=0
group by up_stage) day_24
on day_24.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_25
from task2
where DAY(rep_date)=25  and is_completed=0
group by up_stage) day_25
on day_25.up_stage=day_17.up_stage
```

| up_stage | Day 17 | Day 18 | Day 19 | Day 20 | Day 21 | Day 22 | Day 23 | Day 24 | Day 25 |
| -------- | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: |
| KYC Details | 4303 | 4422 | 3366 | 728 | 330 | 539 | 893 | 3640 | 3518 |
| Personal Details | 1005 | 1056 | 2487 | **10336** | **5179** | **4178** | 1216 | 747 | 748 |

В таблице в которой is_completed=0 мы видим, что 20 мая резко увеличивается количество отказов с этапом "Personal Details" и 21 и 22 держится на высоком уровне. 
В таблице is_completed=1 нет сильных отличий по распределению этапов.

```
select day_17.up_stage, count_17, count_18,count_19,count_20,count_21,count_22,count_23, count_24, count_25
from (select up_stage, count(page_status) as count_17 from task2
where DAY(rep_date)=17 and is_completed=1
group by up_stage) day_17
join (select up_stage, count(page_status) as count_18 
from task2
where DAY(rep_date)=18  and is_completed=1
group by up_stage) day_18
on day_18.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_19 
from task2
where DAY(rep_date)=19  and is_completed=1
group by up_stage) day_19
on day_19.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_20 
from task2
where DAY(rep_date)=20  and is_completed=1
group by up_stage) day_20
on day_20.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_21 
from task2
where DAY(rep_date)=21  and is_completed=1
group by up_stage) day_21
on day_21.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_22
from task2
where DAY(rep_date)=22
group by up_stage) day_22
on day_22.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_23
from task2
where DAY(rep_date)=23  and is_completed=1
group by up_stage) day_23
on day_23.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_24
from task2
where DAY(rep_date)=24  and is_completed=1
group by up_stage) day_24
on day_24.up_stage=day_17.up_stage
join (select up_stage, count(page_status) as count_25
from task2
where DAY(rep_date)=25  and is_completed=1
group by up_stage) day_25
on day_25.up_stage=day_17.up_stage
```

| up_stage | Day 17 | Day 18 | Day 19 | Day 20 | Day 21 | Day 22 | Day 23 | Day 24 | Day 25 |
| -------- | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: |
| KYC Details | 1211 | 1123 | 1200 | 416 | 222 | 539 | 536 | 1242 | 1331 |
| Application Summary | 1729 | 1701 | 1324 | 240 | 131 | 171 | 616 | 631 | 493 |
| e-Nach | 571 | 579 | 499 | 285 | 154 | 125 | 256 | 820 | 733 |
| e-Sign | 738 | 790 | 566 | 359 | 172 | 138 | 325 | 850 | 695 |
| Bank Verification | 8603 | 8824 | 7135 | 2759 | 1646 | 1693 | 3617 | 8395 | 7090 |

**Вывод:** падение конверсии 20-22 связано с тем, что очень много заявок не прошли этап Personal Details.

Полный SQL файл с запросом [SQL-task_2](task_2/task_2_query.sql) 

## Задание №2_2

Задание опубликовано в [Power BI](https://app.powerbi.com/view?r=eyJrIjoiYTY5YTE3ZjctOTEwOS00MGY4LWFmMWQtZGM0MTYxZjU0Mzc1IiwidCI6IjM3ZGNhMjc0LWNkYjMtNDA5ZS1iMTE2LWViNjAyNTM5NmIwMiIsImMiOjl9)


## Задание №3_1 Конверсия

**Трафик во время сезонной распродажи**=9600 поситителей

**Стоимость одной позиции в чеке**=712 рублей

**Количество проданого товара в день** = 2 001 000/712 = 2810

**Количество покупателей в день** = 2810,39/3,129 = 898

**Конверсия необходимая** = 898/9600 = 0,0935 = 9,35%


## Задание №3_2 График

### Выводы: 
- 4, 11, 18 сентября процент повторного взятия микрозайзаймов близок к 0. Вероятнее всеого это связано с выходным днем. 

- Постепенно увеличивается количество возврата микрозаймов.

- 20 сентября странно выглядят проценты по взятию повторного кредита день в день больше, чем суммарные проценты за 2 дня

- 19 сентября проценты не вернулись на позиции до еженедельного падения. 
