-- select * from FactTransaction

CREATE OR ALTER PROCEDURE DailyTransaction
(@start_date DATETIME, @end_date DATETIME) AS
BEGIN
    SET @end_date = CAST(FORMAT(@end_date, 'yyyy-MM-dd') + ' 23:59:59' AS DATETIME);

	SELECT 
	Format(TransactionDate, 'yyyy-MM-dd') as [Date],
	COUNT(TransactionId) as TotalTransactions,
	SUM(Amount) as TotalAmount
	FROM FactTransaction 
	WHERE TransactionDate > @start_date AND TransactionDate <= @end_date
	GROUP BY FORMAT(TransactionDate, 'yyyy-MM-dd');
END;

EXEC DailyTransaction @start_date = '2024-01-18' , @end_date = '2024-01-20';

