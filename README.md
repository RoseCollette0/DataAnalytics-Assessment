# DataAnalytics-Assessment


##  QUESTION 1

### Approach
- I joined ‘users_customuser (uc)’ table to ‘savings_savingsaccount’ table then 'plans_plan (pp)' table, to access customer names, IDs, customer’s account’s plan type and deposits made to these accounts.
- Used ‘WHERE ssa.confirmed_amount > 0’ to ensure only funded accounts were considered.
- Applied ‘SUM(CASE WHEN)’ to count how many savings plans (‘is_regular_savings = 1’) and investment plans (‘is_a_fund = 1’) each customer had.
- Summed up ‘confirmed_amount’ and divided by 100 to convert from Kobo to Naira and used the ‘COALESCE()’ ensure only the non-null values were calculated. 
- Used a ‘HAVING’ clause to select only customers with at least one funded savings **and** one funded investment plan.
- Sorted results by total deposit value in descending order as requested.

### Challenge:

- I had to read the hints section and check my tables a few too many times before realizing that both savings_count and investment_count were coming from the same table and not both savings_savingsaccount and plans_plans table.
- I also tried out other functions before realizing that CASE WHEN within a SUM() worked best for counting only the relevant plan types per user without overcounting.


## QUESTION 2

### Approach

- I used a CTE ('user_tx_summary') to calculate the total number of transactions per customer and figure out how many months they were active by checking their first and last transaction dates.
- Created a second CTE ('user_avg_freq') to calculate each customer's average transactions per month and classify them into frequency groups using a 'CASE' statement.
- Applied 'COUNT()', 'MIN()', 'MAX()', and 'TIMESTAMPDIFF()' to gather transaction counts and time spans.
- Used 'GREATEST()' to avoid dividing by zero when calculating average transactions.
- Rounded the averages with 'ROUND()' for cleaner output.
- Finally, grouped the results by frequency category and ordered them from High to Low frequency.

### Challenge:
- I wasn’t sure what function would give me a clean and readable result, so I did some research and came across CTEs. Using them made the logic easier to follow and helped me structure my query better.


## QUESTION 3

### Approach
- Joined the ‘savings_savingsaccount (ssa)’ table with the ‘plans_plan (pp)’ table to determine each account’s type; **Savings** or **Investment**.
- Used a ‘CASE’ statement to label accounts based on plan type flags ('is_regular_savings', 'is_a_fund').
- Filtered for only funded accounts using ‘WHERE ssa.confirmed_amount > 0’.
- Grouped by ‘plan_id’ and 'owner_id' to analyze transactions per account.
- Used ‘MAX(ssa.transaction_date)’ to get the latest transaction date for each account.
- Calculated inactivity using ‘DATEDIFF(CURDATE(), MAX(ssa.transaction_date))’, this required a bit of research.
- Used the ‘HAVING’ clause to return only accounts with no transactions in the **last 365 days**.

### Challenge: 

- I figured out how to use CURDATE() to calculate inactivity by comparing it with the most recent transaction date using MAX(transaction_date), which helped me accurately flag inactive accounts.
- I also debated between using 'HAVING inactivity_days > 365' and '= 365' to match the requirement phrasing correctly.


## QUESTION 4

### Approach

- I joined ‘users_customuser’ with ‘savings_savingsaccount’ to access customer details and their transaction data.
- Filtered out accounts with no inflow, using ‘ssa.confirmed_amount > 0’.
- Used ‘MIN(transaction_date)’ to find the earliest transaction (the first time a customer ever transacted) per customer and calculated tenure in months with ‘TIMESTAMPDIFF’.
- Made sure the CLV formula didn’t divide by zero by using GREATEST(..., 1) to set a minimum tenure of 1 month.
- Aggregated total confirmed transaction values using ‘SUM()’ and used the given profit margin of ‘0.1%’ to estimate CLV.
- Used ‘ROUND()’ for cleaner CLV results and sorted the final output by ‘estimated_clv’ from highest to lowest, as requested.

### Challenge:

- Took some time to look for functions (like GREATEST(..., 1)) that would let me calculate account tenure without breaking for users with very recent transactions.
- Making sense of the CLV formula and aligning the logic with monthly profit estimates took a bit of breaking down, but once I understood the structure, it came together nicely.
