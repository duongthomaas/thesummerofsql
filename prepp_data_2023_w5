-- Preppin' Data 2023 Week 05

-- Create the bank code by splitting out off the letters from the Transaction code, call this field 'Bank'
-- Change transaction date to the just be the month of the transaction
-- Total up the transaction values so you have one row for each bank and month combination
-- Rank each bank for their value of transactions each month against the other banks. 1st is the highest value of transactions, 3rd the lowest. 
-- Without losing all of the other data fields, find:
--     - The average rank a bank has across all of the months, call this field 'Avg Rank per Bank'
--     - The average transaction value per rank, call this field 'Avg Transaction Value per Rank'

with CTE as (
    select
        monthname (to_date (transaction_date, 'dd/mm/yyyy hh:mi:ss')) as transaction_month ,
        split_part (transaction_code, '-', 1) as bank ,
        sum (value) as total_value ,
        RANK() OVER(PARTITION BY monthname (to_date (transaction_date, 'dd/mm/yyyy hh:mi:ss')) ORDER BY SUM(value) DESC) as rank_per_month
    from pd2023_wk01
    group by monthname (to_date (transaction_date, 'dd/mm/yyyy hh:mi:ss')) ,
        split_part (transaction_code, '-', 1)
) ,
    avg_transaction_value_table as (
    select
        rank_per_month ,
        avg(total_value) as avg_transaction_value_per_rank
    from CTE 
    group by rank_per_month
) ,
    avr_rank_per_bank as (
    select
        bank ,
        avg(rank_per_month) as avg_rank_per_bank
    from CTE 
    group by bank
)

select
    transaction_month ,
    c.bank ,
    total_value ,
    c.rank_per_month ,
    round (t.avg_transaction_value_per_rank, 2) as  avg_transaction_value_per_rank,
    round (r.avg_rank_per_bank, 2) as avg_rank_per_bank

from CTE as c 
inner join avg_transaction_value_table as t
on avg_transaction_value_per_rank = t.avg_transaction_value_per_rank
inner join avr_rank_per_bank as r 
on avg_rank_per_bank = r.avg_rank_per_bank
;
