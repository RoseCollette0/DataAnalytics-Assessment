-- 1) High-Value Customers with Multiple Products
-- 	Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
-- Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

SELECT
  uc.id AS owner_id,
  -- use CONCAT() to combine first and last name so as to achieve expected result column name; name.
  CONCAT(uc.first_name, ' ', uc.last_name) AS name,
  -- use CASE WHEN for conditional counting of the funded savings and investment plans.
  SUM(CASE WHEN pp.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
  SUM(CASE WHEN pp.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count,
  -- use SUM() to count and total up deposits and COALESCE() to return the non-nulls in deposit values(comfirmed_amount) then divide by 100 to get deposit values from Kobo to Naira.
  SUM(COALESCE(ssa.confirmed_amount, 0)) / 100 AS total_deposits
  
FROM users_customuser uc 
JOIN savings_savingsaccount ssa
ON ssa.owner_id = uc.id 
JOIN plans_plan pp ON ssa.plan_id = pp.id
WHERE ssa.confirmed_amount > 0
GROUP BY uc.id, uc.first_name, uc.last_name
-- use HAVING to filter grouped results.
HAVING 
  SUM(CASE WHEN pp.is_regular_savings = 1 THEN 1 ELSE 0 END) >= 1
  AND
  SUM(CASE WHEN pp.is_a_fund = 1 THEN 1 ELSE 0 END) >= 1
ORDER BY total_deposits DESC;
