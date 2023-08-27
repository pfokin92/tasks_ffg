use FFG
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
