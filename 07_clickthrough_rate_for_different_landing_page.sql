use mavenfuzzyfactory;
-- 7.full conversion funnel from each of two pages to orders 
-- lander page 
select website_pageviews.website_session_id,
min(website_pageviews.website_pageview_id) as min_pv
from website_pageviews left join website_sessions using(website_session_id) 
where website_sessions.created_at<"2012-07-28" 
group by website_sessions.website_session_id;

create temporary table min_pv_table
select min(website_pageviews.website_pageview_id) as min_pv,
website_session_id
from website_pageviews
where created_at<"2012-07-28" and 
created_at>"2012-06-19"
group by website_session_id;

select website_session_id
from 
(
select 
pageview_url,
count(*) as count
from min_pv_table right join website_pageviews
on min_pv_table.min_pv = website_pageviews.website_pageview_id 
where created_at<"2012-07-28" and 
created_at>"2012-06-19"
group by pageview_url
order by 2 desc;
-- landing page :/home
--  page : /home /products /the-original-mr-fuzzy /cart /shipping/billing /thank-you-for-your-order
-- get the min(time) and min(session_id) 

select min(created_at), min(website_session_id)
from website_pageviews
where pageview_url='/lander-1';
-- 2012-06-19 00:35:54	11683
-- conversion rate 
create temporary table page_count_table
select website_session_id,
max(lander_page) as lander_made,
max(home_page) as home_made,
max(products_page) as product_made,
max(original_page) as original_made,
max(cart_page) as cart_made,
max(shipping_page) as shipping_made,
max(billing_page) as billing_made,
max(thankyou_page) as ty_made
from(
select website_session_id,
case when pageview_url='/lander-1' then 1 else 0 end as lander_page,
case when pageview_url='/home' then 1 else 0 end as home_page,
 case when pageview_url='/products' then 1 else 0 end as products_page,
case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as original_page,
 case when pageview_url='/cart' then 1 else 0 end as cart_page,
case when pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when pageview_url='/billing' then 1 else 0 end as billing_page,
 case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_pageviews
where created_at >='2012-06-19' and created_at<'2012-07-28'
and website_session_id>=11683) x
group  by 1; 
-- drop table page_count_table;
-- count 

select 
case when lander_made=1 then "lander" 
when home_made=1 then "home" end as landing_index,
count(distinct website_session_id) as sessions,
count(distinct case when product_made=1 then website_session_id else null end)/count(distinct website_session_id) as home_clickthrough,
count(distinct case when original_made=1 then website_session_id else null end)/count(distinct case when product_made=1 then website_session_id else null end) as product_clickthrough,
count(distinct case when cart_made=1 then website_session_id else null end)/count(distinct case when original_made=1 then website_session_id else null end) as mrfuzzy_clickthrough,
count(distinct case when shipping_made=1 then website_session_id else null end)/count(distinct case when cart_made=1 then website_session_id else null end) as cart_clickthrough,
count(distinct case when billing_made=1 then website_session_id else null end)/count(distinct case when shipping_made=1 then website_session_id else null end) as shipping_clickthrough,
count(distinct case when ty_made=1 then website_session_id else null end)/count(distinct case when billing_made=1 then website_session_id else null end) as billing_clickthrough
from page_count_table
group by 1;

/* among all the clickthrough rates, landing_clickthrough, mrfuzzy clickthrough and billing_clickthrough 
are below the average, which should be pay attention to make a change for further profit*/
