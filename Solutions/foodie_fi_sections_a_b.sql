Solutions to the Case Study #3 Foodie-Fi, sections A and B
https://8weeksqlchallenge.com/case-study-3/

-- A. Customer Journey
-- Based off the 8 sample customers provided in the sample from the subscriptions 
-- table, write a brief description about each customer’s onboarding journey.

-- Try to keep it as short as possible - you may also want to run 
-- some sort of join to make your explanations a bit easier!

select
    customer_id ,
    plan_name , start_date
from plans as p
inner join subscriptions as s
    on p.plan_id = s.plan_id
having customer_id <= 19
order by customer_id, start_date asc
;

// B. Data Analysis Questions

// 1. How many customers has Foodie-Fi ever had?

select
    count (distinct cast (customer_id as text)) as count_of_customers
from subscriptions
;

// 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

select 
    date_trunc ('month', start_date) as truncated_month ,
    count (plan_id) as total_trials
from subscriptions
where plan_id = 0
group by date_trunc ('month', start_date)
order by date_trunc ('month', start_date) asc
;

// 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

select
    plan_name ,
    count (*) as count_of_events
from plans as p
inner join subscriptions as s
    on p.plan_id = s.plan_id
where date_part ('year', start_date) > 2020
group by plan_name
;

// 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

select
    round (count (distinct customer_id) / (select count (distinct customer_id) from subscriptions) * 100, 1) as count_of_customers_churned
from subscriptions
where plan_id = 4
;

// 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

with cte as (
    select
        customer_id ,
        plan_id ,
        start_date ,
        row_number() over(partition by customer_id order by start_date asc) as rnk 
    from subscriptions
)
select
    customer_id ,
    plan_id ,
    start_date ,
    rnk ,
    iff (rnk = 1 and plan_id = 0, true, false) as trial_plan ,
    iff (rnk = 2 and plan_id = 4, true, false) as churned
from cte
where trial_plan = true and churned = true 
;
// The way I interpret the question is that we are looking for customers who first had trial subscription (plan_id = 0)
// and right after the trial subscription churned (plan_id = 4).
// There is no record meeting those requirements. Let's broaden the scope to any subscription with a subsequent churn.

with cte as (
    select
        customer_id ,
        plan_id ,
        start_date ,
        row_number() over(partition by customer_id order by start_date asc) as rnk 
    from subscriptions
)
select
    count (distinct customer_id) as number_churned ,
    round (count (distinct customer_id) / (select count (distinct customer_id) from cte) * 100) as percentage_churned
from cte
where plan_id = 4 and rnk = 2
;

// 6. What is the number and percentage of customer plans after their initial free trial?

with cte as (
    select
        customer_id ,
        plan_id ,
        start_date ,
        row_number() over(partition by customer_id order by start_date asc) as rnk 
    from subscriptions
)
select
    plan_name as plan,
    count (distinct customer_id) as count_of_customers_per_plans ,
    round (count ( distinct customer_id) / (select count (distinct customer_id) from cte) * 100, 1) as percentage_total_customers
from cte as c 
inner join plans as p
    on c.plan_id = p.plan_id
where rnk = 2
group by plan_name
;

// 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

with cte as (
    select
        customer_id ,
        plan_id ,
        start_date ,
        row_number() over(partition by customer_id order by start_date desc) as rnk 
    from subscriptions
    where start_date <= '2020-12-31'
)
select
    plan_name as plan,
    count (customer_id) as count_of_customers_per_plans ,
    round (count (customer_id) / (select count (distinct customer_id) from cte) * 100, 1) as percentage_total_customers
from cte as c 
inner join plans as p
    on c.plan_id = p.plan_id
where rnk = 1
group by plan_name
;

// 8. How many customers have upgraded to an annual plan in 2020?

select
    count (distinct customer_id) as count_of_customers_with_annual_subs
from subscriptions
where date_part ('year', start_date) = 2020 and plan_id = 3
;

// 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

with trial as (
    select
        customer_id ,
        start_date  as trial_start_date
    from subscriptions
    where plan_id = 0
), 
    annual as (
    select
        customer_id ,
        start_date as annual_start_date
    from subscriptions
    where plan_id = 3
)
select
    round (avg (datediff ('days', trial_start_date, annual_start_date)), 0) as avg_days_from_trial_to_annual
from trial as t
inner join annual as a
on t.customer_id = a.customer_id
;

// 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

with trial as (
    select
        customer_id ,
        start_date  as trial_start_date
    from subscriptions
    where plan_id = 0
), 
    annual as (
    select
        customer_id ,
        start_date as annual_start
    from subscriptions
    where plan_id = 3
)
select
    CASE
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=30  THEN '0-30'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=60  THEN '31-60'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=90  THEN '61-90'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=120  THEN '91-120'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=150  THEN '121-150'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=180  THEN '151-180'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=210  THEN '181-210'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=240  THEN '211-240'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=270  THEN '241-270'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=300  THEN '271-300'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=330  THEN '301-330'
        WHEN DATEDIFF('days',trial_start_date,annual_start)<=360  THEN '331-360'
    END as bin ,
    count (t.customer_id) as count_of_customers
from trial as t
inner join annual as a
    on t.customer_id = a.customer_id
group by bin 
;

// 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

with pro_monthly as (
    select
        customer_id ,
        plan_id ,
        start_date as pro_start_date
    from subscriptions
    where plan_id = 2
),
    basic_monthly as (
    select
        customer_id ,
        plan_id ,
        start_date as basic_start_date
    from subscriptions
    where plan_id = 1
)
select
    count (distinct b.customer_id) as count_of_customers
from pro_monthly as p 
inner join basic_monthly as b 
    on p.customer_id = b.customer_id
where pro_start_date < basic_start_date and date_part ('year', pro_start_date) = 2020
; 
