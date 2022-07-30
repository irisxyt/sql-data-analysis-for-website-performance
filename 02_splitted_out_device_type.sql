use mavenfuzzyfactory;
-- 3.Pull monthly sessions and orders split by device type
select year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as mo,
count(distinct case when device_type="mobile" then orders.order_id else null end) as count_order_mobile, 
count(distinct case when device_type="mobile" then website_sessions.website_session_id else null end) as count_sessions_mobile,
count(distinct case when device_type="desktop" then orders.order_id else null end) as count_order_desktop, 
count(distinct case when device_type="desktop" then website_sessions.website_session_id else null end) as count_sessions_desktop
from orders right join website_sessions using(website_session_id) 
where website_sessions.created_at<'2012-11-27' 
and utm_source='gsearch'
group by 1,2;
