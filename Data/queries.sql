-- How can you isolate (or group) the transactions of each cardholder?
DROP VIEW IF EXISTS transactions_by_cardholder;

CREATE VIEW transactions_by_cardholder AS
SELECT cc.cardholder_id, t.date, t.amount, t.merchant_id
FROM transaction t
    JOIN credit_card cc ON cc.card = t.card
ORDER BY cc.cardholder_id, t.date;

-- Count the transactions that are less than $2.00 per cardholder.
DROP VIEW IF EXISTS trans_less_than_two_by_cardholder;

CREATE VIEW trans_less_than_two_by_cardholder AS
SELECT t.cardholder_id, COUNT(*) AS less_than_2_dollar_count
FROM transactions_by_cardholder AS t
WHERE t.amount < 2
GROUP BY t.cardholder_id;

-- Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
SELECT 'Although the number of transactions with amount less than $2.00 is high for some Cardholders, at this point ' ||
       'there is not enough evidence to suggest that one or more of the Credit Cards have been hacked.' AS conclusion_1;

-- What are the top 100 highest transactions made between 7:00 am and 9:00 am?
DROP VIEW IF EXISTS transactions_between_7_and_9;

CREATE VIEW transactions_between_7_and_9 AS
SELECT t1.cardholder_id, t1.amount
FROM (
    SELECT t.cardholder_id, ROUND(t.amount::decimal, 2) AS amount, EXTRACT(HOUR FROM t.date) AS transaction_time
    FROM transactions_by_cardholder AS t) AS t1
WHERE transaction_time BETWEEN 7 AND 9
ORDER BY amount DESC
LIMIT 100;

-- Do you see any anomalous transactions that could be fraudulent?
SELECT 'There are 10 transactions with an uncommon high amount. 3 of those transactions are associated to Cardholder 1' ||
       'However, this is not enough information to suggest these operations are fraudulent yet.' AS conclusion_2;

-- Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
SELECT 'Given the total number of transactions (3500) in our Database, this sample does not suggest anything conclusive yet.' AS conclusion_3;

-- If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.
-- N/A

-- What are the top 5 merchants prone to being hacked using small transactions?
DROP VIEW IF EXISTS trans_less_than_two_by_merchant;

CREATE VIEW trans_less_than_two_by_merchant AS
SELECT t.merchant_id, COUNT(*) AS less_than_2_dollar_count
FROM transactions_by_cardholder AS t
WHERE t.amount < 2
GROUP BY t.merchant_id
ORDER BY less_than_2_dollar_count DESC
LIMIT 5
;

-- Examine views
SELECT * FROM transactions_by_cardholder;
SELECT * FROM transactions_between_7_and_9;
SELECT * FROM trans_less_than_two_by_cardholder;
SELECT * FROM trans_less_than_two_by_merchant;

