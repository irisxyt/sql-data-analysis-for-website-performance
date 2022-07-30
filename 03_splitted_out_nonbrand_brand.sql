use mavenfuzzyfactory;
-- 2.splitting out nonbrand brand campaigns separately

select 
year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as mo,
count(distinct case when utm_campaign="nonbrand" then orders.order_id else null end) as count_order_nonbrand, 
count(distinct case when utm_campaign="nonbrand" then website_sessions.website_session_id else null end) as count_sessions_nonbrand,
count(distinct case when utm_campaign="brand" then orders.order_id else null end) as count_order_brand, 
count(distinct case when utm_campaign="brand" then website_sessions.website_session_id else null end) as count_sessions_brand
from orders right join website_sessions using(website_session_id) 
where website_sessions.created_at<'2012-11-27'  
and utm_source='gsearch'
group by 1,2;

/*dramatically increase in the past 8 month for brand sessions number shows that there 
 is a good sign for investors to use this website page organization
*/