use mavenfuzzyfactory;
-- 1.pull monthly trends for gsearch sessions and orders show the growth 

select year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as mo,
count(distinct order_id) as count_orders ,
count(distinct website_sessions.website_session_id) as count_sessions,
count(distinct order_id)/count(distinct website_sessions.website_session_id) as conv_rate
from website_sessions left join orders using(website_session_id) 
where website_sessions.created_at<'2012-11-27'  
and utm_source='gsearch'
group by 1,2;

/* there is increase for both orders and sessions in the past 8 month, 
and based on conversion_rate we can conclude that the website has got a gradually good customers converted performance.
*/