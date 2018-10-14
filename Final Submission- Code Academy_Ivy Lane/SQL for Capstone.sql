--How many campaigns and sources does CoolTShirts use? Which source is used for each campaign? Use three queries: one for the number of distinct campaigns, one for the number of distinct sources, one to find how they are related:

select count (distinct utm_campaign) 'Campaigns'
from page_visits;

select count (distinct utm_source) 'Sources'
from page_visits;

select distinct utm_campaign as 'Campaign List',
    utm_source as 'Source List'
from page_visits; 

--What pages are on the CoolTShirts website? Find the distinct values of the page_name column

select distinct page_name
from page_visits;

--How many first touches is each campaign responsible for?

with first_touch as 
  (select user_id,
        MIN(timestamp) as first_touch_at
    from page_visits
    group by user_id),
first_touch_expanded as 
(select ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign
from first_touch ft
join page_visits pv
    on ft.user_id = pv.user_id
    and ft.first_touch_at = pv.timestamp)
select first_touch_expanded.utm_campaign as 'Campaign Name',
        count (*) as 'Total First Touches'
from first_touch_expanded
  group by utm_campaign
  order by 2 desc;

--How many last touches is each campaign responsible for?

with last_touch as 
  (select user_id,
        MAX(timestamp) as last_touch_at
    from page_visits
    group by user_id),
last_touch_expanded as 
(select lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
from last_touch lt
join page_visits pv
    on lt.user_id = pv.user_id
    and lt.last_touch_at = pv.timestamp)
select last_touch_expanded.utm_campaign as 'Campaign Name',
        count (*) as 'Total Last Touches'
from last_touch_expanded
  group by utm_campaign
  order by 2 desc;
  
--How many distinct visitors make a purchase?

select count(distinct user_id) as 'Distinct User Purchases'  
from page_visits
    where page_name is '4 - purchase';

--How many last touches on the purchase page is each campaign responsible for?

with last_touch as 
  (select user_id,
        MAX(timestamp) as last_touch_at
    from page_visits
    where page_name is '4 - purchase'
     group by user_id),
last_touch_expanded as 
(select lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
from last_touch lt
join page_visits pv
    on lt.user_id = pv.user_id
    and lt.last_touch_at = pv.timestamp)
select last_touch_expanded.utm_campaign as 'Campaign Name',
        count (*) as 'Purchases From Last Touches'
from last_touch_expanded
  group by utm_campaign
  order by 2 desc;

--What is the typical user journey? 

--first touches by source: 

with first_touch as 
  (select user_id,
        MIN(timestamp) as first_touch_at
    from page_visits
    group by user_id),
first_touch_expanded as 
(select ft.user_id,
    ft.first_touch_at,
    pv.utm_source
from first_touch ft
join page_visits pv
    on ft.user_id = pv.user_id
    and ft.first_touch_at = pv.timestamp)
select first_touch_expanded.utm_source as 'Source Name',
        count (*) as 'First Touches'
from first_touch_expanded
  group by utm_source
  order by 2 desc;
  
--distinct users by page
select count (distinct user_id) as 'User Total',
  page_name as 'Page'
from page_visits
group by page_name
order by 1 desc;

--earliest & latest visit to CoolTShirts website

select min(timestamp) as 'Earliest Visit' 
from page_visits;
    
 select max(timestamp) as 'Most Recent Visit' 
from page_visits;

--which five campaigns should CoolTShirts reinvest in and why? 

--first touches with source 

with first_touch as 
  (select user_id,
        MIN(timestamp) as first_touch_at
    from page_visits
    group by user_id),
first_touch_expanded as 
(select ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
     pv.utm_campaign
from first_touch ft
join page_visits pv
    on ft.user_id = pv.user_id
    and ft.first_touch_at = pv.timestamp)
select first_touch_expanded.utm_campaign as 'Campaign Name',
       first_touch_expanded.utm_source as 'Source Name',
        count (*) as 'First Touches'
from first_touch_expanded
  group by utm_campaign
  order by 2 desc;

--How many first touches on the purchase page is each campaign responsible for?

with first_touch as 
  (select user_id,
        MIN(timestamp) as first_touch_at
    from page_visits
    where page_name is '4 - purchase'
    group by user_id),
first_touch_expanded as 
(select ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
     pv.utm_campaign
from first_touch ft
join page_visits pv
    on ft.user_id = pv.user_id
    and ft.first_touch_at = pv.timestamp)
select first_touch_expanded.utm_campaign as 'Campaign Name',
       first_touch_expanded.utm_source as 'Source Name',
        count (*) as 'Purchases from First Touch'
from first_touch_expanded
  group by utm_campaign
  order by 2 desc;

--How many total purchases are made (not distinct customers, total purchases)

select count(distinct timestamp) as 'Total Purchases'  
from page_visits
    where page_name is '4 - purchase';
