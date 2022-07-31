use mavenfuzzyfactory;
-- 8. qualify the impact of billing test 
 
 select
 billing_version_seen,
 count(distinct website_session_id) as sessions,
 sum(price_usd)/count(distinct website_session_id) as revenue_per_billing_page
 from(
 select website_pageviews.website_session_id,
 website_pageviews.pageview_url as billing_version_seen,
 orders.order_id,
 orders.price_usd
 from website_pageviews left join orders using(website_session_id) 
 where website_pageviews.created_at>'2012-09-10' and website_pageviews.created_at<'2012-11-10'
 and website_pageviews.pageview_url in('/billing','/billing-2')) x
 group by 1;
 
 /* per_revenue for billing-2 is 31.339297 and for billing is 22.826484
 so there is a major lift at 8.51$ per billing page for the test*/
 select count(website_session_id) as billing_sessions_past_month,
 count(website_session_id)*8.51 as billing_revenue
 from website_pageviews
 where website_pageviews.pageview_url in("/billing","/billing-2") 
 and created_at between '2012-10-27' and '2012-11-27';
 