-- Preppin' Data 2023 Week 01

-- Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction 
    -- Rename the new field with the Bank code 'Bank'. 
-- Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
-- Change the date to be the day of the week
-- Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways:
    -- 1. Total Values of Transactions by each bank
    -- 2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
    -- 3. Total Values by Bank and Customer Code

select
  split_part (transaction_code, '-', 1) as "Bank" ,
  iff (online_or_in_person = 1, 'Online', 'In-Person') as "Online or In-Person" ,
  dayname (to_date (transaction_date, 'dd/mm/yyyy hh:mi:ss')) as "Transaction Date" ,
  sum (value) as "Value"

from pd2023_wk01
group by split_part (transaction_code, '-', 1),
    online_or_in_person ,
    dayname (to_date (transaction_date, 'dd/mm/yyyy hh:mi:ss'))
;
