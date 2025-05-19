-- 2) Transaction Frequency Analysis
-- 	Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
-- Calculate the average number of transactions per customer per month and categorize them:
-- "High Frequency" (≥10 transactions/month)
-- "Medium Frequency" (3-9 transactions/month)
-- "Low Frequency" (≤2 transactions/month)

-- use (CTE) user_tx_summary to calculate total transactions per customer and their active months based on transaction dates.
WITH user_tx_summary AS (
    SELECT 
        ssa.owner_id,
        COUNT(*) AS total_transactions,
	-- use MIN() and MAX() to find first and last transaction dates and GREATEST() to ensure the active months value is at least 1.
    -- use TIMESTAMPDIFF() to calculate the number of months between those dates.
        GREATEST(
            TIMESTAMPDIFF(MONTH, MIN(ssa.transaction_date), MAX(ssa.transaction_date)) + 1, 
            1
        ) AS active_months
    FROM savings_savingsaccount ssa
    WHERE ssa.confirmed_amount > 0
    GROUP BY ssa.owner_id
),
-- use CTE (user_avg_freq) to compute average transactions per month per customer and categorize them into frequency groups with a CASE statement.
user_avg_freq AS (
    SELECT 
        uts.owner_id,
-- use ROUND() to format averages to 2 decimal places.
        ROUND(uts.total_transactions / uts.active_months, 2) AS avg_transactions_per_month,
        CASE 
            WHEN uts.total_transactions / uts.active_months >= 10 THEN 'High Frequency'
            WHEN uts.total_transactions / uts.active_months BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM user_tx_summary uts
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM user_avg_freq
GROUP BY frequency_category
-- FIELD() in ORDER BY to control the output order of categories.
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency'); 