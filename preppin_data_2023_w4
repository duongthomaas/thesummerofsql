-- Preppin' Data 2023 Week 04

-- We want to stack the tables on top of one another, since they have the same fields in each sheet. We can do this one of 2 ways:
    -- Drag each table into the canvas and use a union step to stack them on top of one another
    -- Use a wildcard union in the input step of one of the tables
-- Some of the fields aren't matching up as we'd expect, due to differences in spelling. Merge these fields together
-- Make a Joining Date field based on the Joining Day, Table Names and the year 2023
-- Now we want to reshape our data so we have a field for each demographic, for each new customer (help)
-- Make sure all the data types are correct for each field
-- Remove duplicates (help)
    -- If a customer appears multiple times take their earliest joining date

with unioned_table as (
    select * , 'January' as joining_month
    from pd2023_wk04_january 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 
    
    union all 
    select * , 'February' as joining_month
    from pd2023_wk04_february 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'March' as joining_month
    from pd2023_wk04_march
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'April' as joining_month
    from pd2023_wk04_april 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'May' as joining_month
    from pd2023_wk04_may 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'June' as joining_month
    from pd2023_wk04_june 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'July' as joining_month
    from pd2023_wk04_july 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'August' as joining_month
    from pd2023_wk04_august 
    pivot (max (value) for demographiic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'September' as joining_month
    from pd2023_wk04_september 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'October' as joining_month
    from pd2023_wk04_october 
    pivot (max (value) for demagraphic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'November' as joining_month
    from pd2023_wk04_november 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 

    union all
    select * , 'December' as joining_month
    from pd2023_wk04_december 
    pivot (max (value) for demographic in ('Ethnicity', 'Account Type', 'Date of Birth')) 
)

select
    ID ,
    to_date (joining_day || '/' || MONTH(TO_DATE(joining_month, 'MMMM')) || '/' || '2023', 'dd/mm/yyyy') as joining_date ,
    'Account Type' as account_type ,
    'Date of Birth' as date_of_birth ,
    'Ethnicity' as ethnicity

from unioned_table
;
