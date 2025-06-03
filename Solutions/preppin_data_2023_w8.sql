-- Preppin' Data 2023 Week 08

-- Create a 'file date' using the month found in the file name
--     - The Null value should be replaced as 1
-- Clean the Market Cap value to ensure it is the true value as 'Market Capitalisation'
--     - Remove any rows with 'n/a'
-- Categorise the Purchase Price into groupings
    -- 0 to 24,999.99 as 'Low'
    -- 25,000 to 49,999.99 as 'Medium'
    -- 50,000 to 74,999.99 as 'High'
    -- 75,000 to 100,000 as 'Very High'
-- Categorise the Market Cap into groupings
    -- Below $100M as 'Small'
    -- Between $100M and below $1B as 'Medium'
    -- Between $1B and below $100B as 'Large' 
    -- $100B and above as 'Huge'
-- Rank the highest 5 purchases per combination of: file date, Purchase Price Categorisation and Market Capitalisation Categorisation.
-- Output only records with a rank of 1 to 5

with unioned_table as (
        select
            * ,
            to_date('01/01/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_01
        union all
        select
            * ,
            to_date('01/02/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_02
        union all
        select
            * ,
            to_date('01/03/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_03
        union all
        select
            * ,
            to_date('01/04/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_04
        union all
        select
            * ,
            to_date('01/05/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_05
        union all
        select
            * ,
            to_date('01/06/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_06
        union all
        select
            * ,
            to_date('01/07/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_07
        union all
        select
            * ,
            to_date('01/08/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_08
        union all
        select
            * ,
            to_date('01/09/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_09
        union all
        select
            * ,
            to_date('01/10/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_10
        union all
        select
            * ,
            to_date('01/11/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_11
        union all
        select
            * ,
            to_date('01/12/2023', 'dd/mm/yyyy') as date 
        from pd2023_wk08_12        
) ,
    market_cap_clean as (
        select 
            * ,
            case
            when right(market_cap, 1) = 'M' then to_decimal (regexp_replace (market_cap, '[^0-9.]', '')) * 1000000
            when right(market_cap, 1) = 'B' then to_decimal (regexp_replace (market_cap, '[^0-9.]', '')) * 1000000000
            else to_decimal (regexp_replace (market_cap, '[^0-9.]', ''))
            end as market_cap_convert
        from unioned_table
        where market_cap <> 'n/a'
) ,
    categories as (
        select
            * ,
            case
            when to_decimal (replace (purchase_price, '$', '')) < 25000 then 'Low'
            when to_decimal (replace (purchase_price, '$', '')) >= 25000 and to_decimal (replace (purchase_price, '$', '')) <50000 then 'Medium'
            when to_decimal (replace (purchase_price, '$', '')) >= 50000 and to_decimal (replace (purchase_price, '$', '')) < 75000 then 'High'
            else 'Very High'
            end as purchase_price_category ,
            case
            when market_cap_convert < 100000000 then 'Small'
            when market_cap_convert >= 100000000 and market_cap_convert < 1000000000 then 'Medium'
            when market_cap_convert >= 1000000000 and market_cap_convert < 100000000000 then 'Large'
            else 'Huge'
            end as market_cap_category
        from market_cap_clean
) ,
    ranked as (
        select 
            market_cap_category as market_capitalisation_categorisation ,
            purchase_price_category as purchase_price_categorisation ,
            date as file_date ,
            ticker ,
            sector ,
            market ,
            stock_name ,
            market_cap as market_capitalisation ,
            purchase_price ,
            RANK() OVER(PARTITION BY date, purchase_price_category, market_cap_category ORDER BY SUM(to_decimal (replace (purchase_price, '$', ''))) DESC) as rnk
        from categories
        group by  market_cap_category, purchase_price_category, date, ticker, sector, 
        market, stock_name, market_cap, purchase_price
)

select
    *
from ranked
where rnk <= 5
;
