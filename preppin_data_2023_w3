-- Preppin' Data 2023 Week 03

-- For the transactions file:
    -- Filter the transactions to just look at DSB (help)
        -- These will be transactions that contain DSB in the Transaction Code field
    -- Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
    -- Change the date to be the quarter (help)
    -- Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person) (help)
-- For the targets file:
    -- Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter (help)
    -- Rename the fields
    -- Remove the 'Q' from the quarter field and make the data type numeric (help)
-- Join the two datasets together (help)
    -- You may need more than one join clause!
-- Remove unnecessary fields
-- Calculate the Variance to Target for each row 

with CTE as (
    select
        iff (online_or_in_person = 1, 'Online', 'In-Person') as online_in_person ,
        quarter (to_date (transaction_date, 'dd/mm/yyyy hh:mi:ss')) as quarterly_target ,
        sum(value) as total_value
    from pd2023_wk01
    where split_part (transaction_code, '-', 1) = 'DSB'
    group by online_in_person , quarterly_target
)

select
    online_or_in_person ,
    replace (t.quaterly_col, 'Q', '') as quarter ,
    c.total_value ,
    targets ,
    c.total_value - targets as variance_to_targets

from pd2023_wk03_targets as t 
    unpivot (targets for quaterly_col in (Q1, Q2, Q3, Q4))
inner join CTE as c
    on replace (t.quaterly_col, 'Q', '') = c.quarterly_target
    and t.online_or_in_person = c.online_in_person
;
