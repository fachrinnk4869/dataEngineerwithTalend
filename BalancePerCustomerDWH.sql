select TransactionId, Customername, TransactionDate, AccountType, Balance, Amount, TransactionType from DimAccount
JOIN FactTransaction on DimAccount.AccountId = FactTransaction.AccountId
JOIN DimCustomer on DimCustomer.CustomerId = DimAccount.CustomerId
WHERE CustomerName LIKE '%ani%' AND Status='active';

CREATE OR ALTER PROCEDURE BalancePerCustomer
(@name VARCHAR(100)) AS
BEGIN
    SELECT 
        DimCustomer.CustomerName,
        DimAccount.AccountType,
        DimAccount.Balance,
        DimAccount.Balance + SUM(CASE WHEN FactTransaction.TransactionType = 'Deposit' THEN FactTransaction.Amount ELSE -FactTransaction.Amount END) AS CurrentBalance
    FROM 
        DimCustomer
    JOIN 
        DimAccount ON DimCustomer.CustomerId = DimAccount.CustomerId
    LEFT JOIN 
        FactTransaction ON DimAccount.AccountId = FactTransaction.AccountId
    WHERE 
        DimCustomer.CustomerName LIKE '%' + @name + '%' AND
        DimAccount.Status = 'active'
    GROUP BY 
        DimCustomer.CustomerName,
        DimAccount.AccountType,
        DimAccount.Balance;
END;


EXEC BalancePerCustomer @name = 'ani';
