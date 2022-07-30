use mavenfuzzyfactory;

-- 6.estimate the revenue that earned us 
select min(website_pageview_id) as min_pv
from website_pageviews
where pageview_url='/lander-1';

-- min_pv is 23504
create temporary table first_time_view
select website_pageviews.website_session_id,
min(website_pageviews.website_pageview_id)as min_pv_id
from website_pageviews join  website_sessions using(website_session_id)
where website_pageviews.website_pageview_id>='23504' 
and website_sessions.created_at<'2012-07-28'
and utm_source='gsearch' and utm_campaign='nonbrand' 
group by website_pageviews.website_session_id;

-- bring in the landing page to each session,but restrict to home to lander-1 

create temporary table nonbrand_test_landing_page
select first_time_view.website_session_id,
website_pageviews.pageview_url as landing_page
from first_time_view left join website_pageviews on website_pageviews.website_pageview_id 
=first_time_view.min_pv_id
where website_pageviews.pageview_url in('/home','/lander-1');
-- bring in orders 
create temporary table nonbrand_test_orders
select nonbrand_test_landing_page.website_session_id,
nonbrand_test_landing_page.landing_page,
orders.order_id
from nonbrand_test_landing_page
left join orders using(website_session_id);

-- count conversion rates
select 
landing_page,
count(distinct website_session_id) as sessions,
count(distinct order_id) as orders,
count(distinct order_id) /count(distinct website_session_id) as conversion_rate
from nonbrand_test_orders
group by 1;
/* 0.0318 for /home and 0.0406 for lander-1 
the lift is from 0.0318 to 0.0406 */


-- find the most recent pageview for gsearch nonbrand to /home 
select max(website_sessions.website_session_id) as most_recent_pageview
from website_pageviews join website_sessions using(website_session_id)
where utm_source='gsearch' 
and utm_campaign='nonbrand' 
and website_sessions.created_at<'2012-11-27'
and pageview_url='/home';
-- 17145 
-- see how many session since we have tested
select count(website_session_id) as sessions
from website_sessions 
where created_at <"2012-11-27" 
and website_session_id >17145
and utm_source="gsearch" 
and utm_campaign="nonbrand";
-- 22972
/* 22972 * incremental conversion=202 incremental orders 
202/4, roughly increases 50 orders per month
*/

