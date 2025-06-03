-- Preppin' Data 2023 Week 06

-- Reshape the data so we have 5 rows for each customer, with responses for the Mobile App and Online Interface being in separate fields on the same row
-- Clean the question categories so they don't have the platform in from of them
--     - e.g. Mobile App - Ease of Use should be simply Ease of Use
-- Exclude the Overall Ratings, these were incorrectly calculated by the system
-- Calculate the Average Ratings for each platform for each customer 
-- Calculate the difference in Average Rating between Mobile App and Online Interface for each customer
-- Catergorise customers as being:
--     - Mobile App Superfans if the difference is greater than or equal to 2 in the Mobile App's favour
--     - Mobile App Fans if difference >= 1
--     - Online Interface Fan
--     - Online Interface Superfan
--     - Neutral if difference is between 0 and 1
-- Calculate the Percent of Total customers in each category, rounded to 1 decimal place

WITH unpivot_mobile_app AS (
    SELECT
        customer_id,
        AVG(rating_mobile) AS avg_rating_mobile
    FROM pd2023_wk06_dsb_customer_survey
    UNPIVOT (
        rating_mobile FOR mobile_app IN (
            MOBILE_APP___EASE_OF_USE, 
            MOBILE_APP___EASE_OF_ACCESS,
            MOBILE_APP___NAVIGATION,
            MOBILE_APP___LIKELIHOOD_TO_RECOMMEND
        )
    )
    GROUP BY customer_id
), 
unpivot_online_interface AS (
    SELECT
        customer_id,
        AVG(rating_online) AS avg_rating_online
    FROM pd2023_wk06_dsb_customer_survey
    UNPIVOT (
        rating_online FOR online_interface IN (
            ONLINE_INTERFACE___EASE_OF_USE, 
            ONLINE_INTERFACE___EASE_OF_ACCESS,
            ONLINE_INTERFACE___NAVIGATION,
            ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND
        )
    )
    GROUP BY customer_id
), 
diff_avg_rating AS (
    SELECT
        m.customer_id,
        m.avg_rating_mobile,
        o.avg_rating_online,
        (m.avg_rating_mobile - o.avg_rating_online) AS diff_avg_rating
    FROM unpivot_mobile_app AS m
    INNER JOIN unpivot_online_interface AS o 
        ON m.customer_id = o.customer_id
        
), 
category AS (
    SELECT
        *,
        CASE
            WHEN diff_avg_rating >= 2 THEN 'Mobile App Superfans'
            WHEN diff_avg_rating >= 1 THEN 'Mobile App Fans'
            WHEN diff_avg_rating <= -2 THEN 'Online Interface Superfans'
            WHEN diff_avg_rating <= -1 THEN 'Online Interface Fans'
            ELSE 'Neutral'
        END AS fan_category
    FROM diff_avg_rating
)

SELECT 
    fan_category AS preference,
    round ((COUNT(customer_id) / (SELECT COUNT(customer_id) FROM category))*100, 1) AS percent_of_total
FROM category
GROUP BY fan_category;
