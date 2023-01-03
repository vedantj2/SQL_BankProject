USE bank354

--QUESTION 1 OF THE PROJECT
/*CustomerID, first name, last name, and income of customers who own an account with a
balance below $9000, ordered by these attributes in that order.*/
SELECT C.customerID, C.firstName, C.lastName, C.income
	FROM Customer C, Account A, Owns O
	WHERE C.customerID = O.customerID AND O.accNumber = A.accNumber AND  A.balance < 9000
ORDER BY C.customerID, C.firstName, C.lastName, C.income

--QUESTION 2 OF THE PROJECT
/*CustomerID, first name, last name of customers who own an account with highest balance
among all branches, ordered by these attributes in that order.*/
SELECT C.customerID, C.firstName, C.lastName
	FROM Customer C, Account A, Owns O
	WHERE C.customerID = O.customerID AND O.accNumber = A.accNumber AND A.balance = (SELECT MAX(balance)
																					 FROM Account)
ORDER BY C.customerID, C.firstName, C.lastName

--QUESTION 3 OF THE PROJECT
/*CustomerID, first name, last name of customers who own an account with highest
balance in his/her branch, ordered by these attributes in that order.*/	
SELECT C.customerID, C.firstName, C.lastName
	FROM Customer C, Account A, Owns O
	WHERE C.customerID = O.customerID AND O.accNumber = A.accNumber AND A.balance = (SELECT MAX(A2.balance)
																					 FROM Account A2
																					 WHERE A.branchNumber = A2.branchNumber)
ORDER BY C.customerID, C.firstName, C.lastName

--QUESTION 4 OF THE PROJECT
/*CustomerID, first name, last name of customers who own both a chequing (type CHQ) and
savings (type SAV) accounts, ordered by these attributes in that order.*/
SELECT C.customerID, C.firstName, C.lastName
	FROM Customer C, Account A, Owns O
	WHERE C.customerID = O.customerID AND O.accNumber = A.accNumber AND A.type = 'CHQ'
INTERSECT
SELECT C.customerID, C.firstName, C.lastName
	FROM Customer C, Account A, Owns O
	WHERE C.customerID = O.customerID AND O.accNumber = A.accNumber AND A.type = 'SAV'
ORDER BY C.customerID, C.firstName, C.lastName

--QUESTION 5 OF THE PROJECT
/*CustomerID and total balance of customers whose total balance is at least twice
the total balance of any customer with the first name Victor, ordered by these
attributes in that order*/
SELECT C.customerID, SUM(A.balance) AS TotalBalance
	FROM CUSTOMER C, OWNS O, ACCOUNT A
	WHERE C.customerID = O.customerID AND A.accNumber = O.accNumber
	GROUP BY C.customerID
	HAVING SUM(A.balance) >= ANY(SELECT 2*SUM(A.balance)
								 FROM CUSTOMER C, OWNS O, ACCOUNT A
								 WHERE C.firstName = 'Victor' AND C.customerID = O.customerID AND A.accNumber = O.accNumber
								 GROUP BY C.customerID)

--QUESTION 6 OF THE PROJECT
/*Branch number, branch name, minimum, maximum, average, and total balance at each branch,
ordered by branch number and branch name.*/
Select B.branchNumber, B.branchName, MIN(A.balance) AS Min, Max(A.balance) AS Max, Avg(A.balance)As Average, Sum(A.balance) As Sum
	from Branch B, Account A
	where A.branchNumber = B.branchNumber
group by B.branchNumber, B.branchName

--QUESTION 7 OF THE PROJECT
/*CustomerID of customers who have the largest number of transactions. */
SELECT O.customerID
FROM Transactions T, Owns O, Account A
WHERE O.accNumber=A.accNumber AND A.accNumber=T.accNumber
GROUP BY O.customerID
HAVING COUNT(*) >= ALL (
	SELECT COUNT(*)
	FROM Transactions T, Owns O, Account A
	WHERE O.accNumber=A.accNumber AND A.accNumber=T.accNumber
	GROUP BY O.customerID)

