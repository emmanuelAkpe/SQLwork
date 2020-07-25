
						QUESTION 1
  	SELECT COUNT(name) FROM users;

--Since the name field is 'Not Null' we can use it to find the total number of users.

						QUESTION 2

 	SELECT COUNT(transfer_id) FROM transfers WHERE send_amount_currency='CFA';
	
--The question implies that it is possible that transfers  were also sent in other currencies.
--So to find the total transfers sent in "CFA", we need to equate the
 --"send_amount_currency column" to "CFA".

						QUESTION 3

	SELECT COUNT(DISTINCT(transfer_id)) FROM transfers WHERE send_amount_currency='CFA';
	
-- We use "DISTINCT" coupled with "COUNT" to determine the total number of different users.We then
--equate the "send_amount_currency column" to "CFA" to determine the different  users who sent their 
--transfers in "CFA".

						QUESTION 4

	SELECT COUNT(atx_id) FROM agent_transactions WHERE EXTRACT(YEAR FROM when_created)=2018
	GROUP BY EXTRACT(MONTH FROM when_created);

--We first use "COUNT" to determine the total agent_transactions from the agent_transactions table.
--But since we are interested in finding the agent_transactions broken down by months, we then use 
--the "EXTRACT" and the "GROUP BY" functions.
						QUESTION 5
	 WITH  mywithdrawers AS
	(SELECT COUNT(agent_id) netwithdrawers FROM agent_transactions HAVING COUNT(amount) IN
	(SELECT COUNT(amount) FROM agent_transactions WHERE amount >-1 AND amount!=0 HAVING 
	COUNT(amount)>  (SELECT COUNT(amount) FROM agent_transactions WHERE amount <1 AND amount!=0)))
	SELECT netwithdrawers FROM mywithdrawers;
	WITH mydepositors AS
	(SELECT COUNT(agent_id) netdepositors FROM agent_transactions HAVING COUNT(amount) IN
	(SELECT COUNT(amount) FROM agent_transactions WHERE amount <1 AND amount!=0 HAVING COUNT(amount)>
	(SELECT COUNT(amount) FROM agent_transactions WHERE amount >-1 AND amount!=0)))
	SELECT netdepositors FROM mydepositors;

						QUESTION 6

	SELECT COUNT(agent_transactions.atx_id) AS "atx volume city summary",
	agents.city FROM agent_transactions
	LEFT JOIN agents ON agent_transactions.agent_id=agents.agent_id
	WHERE
	agent_transactions.when_created >=NOW()-INTERVAL'1 week'
	GROUP BY agents.city;

						QUESTION 7

	SELECT COUNT(agent_transactions.atx_id) AS "atx volume city summary",
	agents.city, agents.country FROM agent_transactions
	LEFT JOIN agents ON agent_transactions.agent_id=agents.agent_id
	WHERE
	agent_transactions.when_created >=NOW()-INTERVAL'1 week'
	GROUP BY agents.city,agents.country;

						QUESTION 8

	SELECT transfers.kind AS kind, wallets.ledger_location AS country,
	SUM(transfers.send_amount_scalar) AS volume FROM transfers
	INNER JOIN wallets ON transfers.source_wallet_id=wallets.wallet_id
	WHERE (transfers.when_created>(NOW()-INTERVAL '1 week'))
	GROUP BY wallets.ledger_location, transfers.kind;

						QUESTION 9

	SELECT COUNT(transfers.source_wallet_id) 
	AS Unique_Senders, COUNT (transfer_id) AS Transaction_Count, transfers.kind 
	AS Transfer_Kind, wallets.ledger_location AS Country, 
	SUM (transfers.send_amount_scalar) AS Volume FROM transfers 
	INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id 
	WHERE (transfers.when_created > (NOW() - INTERVAL '1 week')) 
	GROUP BY wallets.ledger_location, transfers.kind;

						QUESTION 10

	SELECT source_wallet_id, send_amount_scalar FROM 
	transfers WHERE send_amount_currency = 'CFA' AND (send_amount_scalar>10000000) AND 
	(transfers.when_created > (NOW() - INTERVAL '1 month'));

--the statement above will retrieve all wallets sending an amount greater than 1000000 specifying the currency in CFA.  