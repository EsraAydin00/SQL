

--Factorial Function

--Create a scalar-valued function that returns the factorial of a number you gave it.



CREATE FUNCTION Factorial(@num INT)
RETURNS INT
AS
BEGIN
		DECLARE @result INT = 1

		IF @num < 0
			SET @result = NULL

        ELSE IF @num = 0
			SET @result = 1 

		ELSE
			DECLARE @i INT = 1
			WHILE @i <= @num
			BEGIN
				SET @result = @result * @i
				SET @i += 1
			END

RETURN @result

END;



SELECT dbo.Factorial(5)