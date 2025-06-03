-- Preppin' Data 2023 Week 07

-- For the Transaction Path table:
--     - Make sure field naming convention matches the other tables
--         - i.e. instead of Account_From it should be Account From
-- For the Account Information table:
--     - Make sure there are no null values in the Account Holder ID
--     - Ensure there is one row per Account Holder ID
--         - Joint accounts will have 2 Account Holders, we want a row for each of them
-- For the Account Holders table:
--     - Make sure the phone numbers start with 07
-- Bring the tables together
-- Filter out cancelled transactions 
-- Filter to transactions greater than £1,000 in value 
-- Filter out Platinum accounts

with account_information as (
        select
            account_number ,
            account_type ,
            value as correct_account_holder_id ,
            balance_date ,
            balance
        from pd2023_wk07_account_information, lateral split_to_table (account_holder_id, ', ')
        where account_holder_id is not null
        and account_type <> 'Platinum'
) ,
    account_holder_information as (
        select
            ah.account_holder_id ,
            ah.name ,
            ah.date_of_birth ,
            '07' || contact_number as correct_contact_number ,
            ah.first_line_of_address ,
            ai.account_number ,
            ai.account_type ,
            ai.balance_date ,
            ai.balance
        from pd2023_wk07_account_holders as ah 
        inner join account_information as ai 
            on ah.account_holder_id = correct_account_holder_id
) ,
    transaction_path_detail as (
        select
            *
        from pd2023_wk07_transaction_path as p
        inner join pd2023_wk07_transaction_detail as d
            on p.transaction_id = d.transaction_id
        where cancelled_ = 'N'
)

select
    *
from account_holder_information as a 
inner join transaction_path_detail as t
 on account_number = account_from
where value > 1000
;
