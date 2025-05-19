-- 4) Customer Lifetime Value (CLV) Estimation
-- 	Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
-- For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
-- Account tenure (months since signup)
-- Total transactions
-- Estimated CLV (Assume: CLV = (total transactions / tenure) * 12 * avg_profit_per_transaction)
-- Order by estimated CLV from highest to lowest


SELECT 
    uc.id AS customer_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
-- use GREATEST() to ensure tenure is at least 1 month to avoid division by zero.
-- use TIMESTAMPDIFF() to calculate months between first transaction and today
-- use MIN() to get the earliest transaction date per customer (used for calculating tenure) and SUM() to calculate the total value of confirmed transactions for each customer (used in CLV calculation).
    GREATEST(
        TIMESTAMPDIFF(MONTH, MIN(ssa.transaction_date), CURDATE()), 1
    ) AS tenure_months,
    SUM(ssa.confirmed_amount) AS total_transactions_kobo,
-- use ROUND() to format the estimated CLV to 2 decimal places.
    ROUND((
        (SUM(ssa.confirmed_amount) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(ssa.transaction_date), CURDATE()), 1))
        * 12 * 0.001
    ), 2) AS estimated_clv
FROM users_customuser uc
JOIN savings_savingsaccount ssa ON uc.id = ssa.owner_id
-- WHERE to filter for funded transactions.
WHERE ssa.confirmed_amount > 0
GROUP BY uc.id, uc.first_name, uc.last_name
ORDER BY estimated_clv DESC;
