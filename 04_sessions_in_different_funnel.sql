use mavenfuzzyfactory;
-- 4.monthly trends for gsearch, alongside monthly trends for each of other channel 
select distinct 
utm_source,
utm_campaign,
http_referer
from website_sessions 
where website_sessions.created_at<'2012-11-22';

/* we can know differenct paid_campaign
 there are gsearch_paid,bsearch_paid, organic_search,direct type*/
 
select year(website_sessions.created_at) as yr,
month(website_sessions.created_at) as mo,
count(distinct case when utm_source='gsearch' then website_session_id else null end) as gsearch_paid,
count(distinct case when utm_source='bsearch' then website_session_id else null end) as bsearch_paid,
count(distinct case when utm_source is null and http_referer is not null then website_session_id else null end) as organic_search,
count(distinct case when utm_source is null and http_referer is null then website_session_id else null end)as direct_search
from website_sessions
where website_sessions.created_at<'2012-11-27' 
group by 1,2;

