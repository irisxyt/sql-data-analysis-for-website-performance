use mavenfuzzyfactory;
-- 5.session to order conversion rates monthly 
select year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as mo,
count(distinct order_id)/count(website_sessions.website_session_id) as conversion_rate
from website_sessions left join orders using(website_session_id)  
where website_sessions.created_at<'2012-11-27' 
group by 1,2;
