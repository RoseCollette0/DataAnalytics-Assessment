-- 3) Account Inactivity Alert
-- 	Scenario: The ops team wants to flag accounts with no inflow transactions for over one
-- Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).

SELECT 
    ssa.plan_id,
    ssa.owner_id,
    -- filter using CASE to return the different account types; savings, investment and other.
    CASE 
        WHEN pp.is_regular_savings = 1 THEN 'Savings'
        WHEN pp.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
-- use MAX() to get the latest transaction date.
    MAX(ssa.transaction_date) AS last_transaction_date,
    -- use DATEDIFF() with the current date, "CURDATE" to calculate the inactivity period.
    DATEDIFF(CURDATE(), MAX(ssa.transaction_date)) AS inactivity_days
    
FROM savings_savingsaccount ssa
JOIN plans_plan pp ON ssa.plan_id = pp.id
WHERE ssa.confirmed_amount > 0
GROUP BY ssa.plan_id, ssa.owner_id
-- use HAVING to filter based on inactivity duration
HAVING inactivity_days > 365; 