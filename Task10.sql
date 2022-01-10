--Code theo ví dụ
USE AdventureWorks2019
GO
/*Tạo một thủ tục lưu trữ lấy ra toàn bộ nhân viên vào làm theo năm có
tham số đầu vào là một năm*/
CREATE PROCEDURE sp_DisplayEmployeesHireYear2
   @HireYear int
AS
SELECT * FROM HumanResources.Employee
WHERE DATEPART(YY,HireDate)=@HireYear
GO
/*Để chạy thủ tục này cần phải truyền tham số vào là năm mà nhân viên
vào làm*/
EXECUTE sp_DisplayEmployeesHireYear2 2009
GO
/*Tạo thủ tục lưu trữ đếm số người vào làm trong một năm xác định có
tham số đầu vào là một năm, tham số đầu ra là số người vào làm trong năm này*/
CREATE PROCEDURE sp_EmployeesHireYearCount3
   @HireYear int,
   @Count int OUTPUT
AS
SELECT @Count = COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate) = @HireYear
GO
/*Chạy thủ tục lưu trữ cần phải truyền vào 1 tham số đầu vào và một
tham số đầu ra.*/
DECLARE @Number int 
EXECUTE sp_EmployeesHireYearCount3 2003, @Number OUTPUT
PRINT @Number
GO
/*Tạo thủ tục lưu trữ đếm số người vào làm trong một năm xác định có
tham số đầu vào là một năm, hàm trả về số người vào làm năm đó*/
CREATE PROCEDURE sp_EmployeesHireYearCount4 
   @HireYear int
AS
DECLARE @Count int
SELECT @Count = COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY,HireDate) = @HireYear
RETURN @Count
GO
/*Chạy thủ tục lưu trữ cần phải truyền vào 1 tham số đầu và lấy về số
người làm trong năm đó.*/
DECLARE @Number int 
EXECUTE @Number = sp_EmployeesHireYearCount4 2009
PRINT @Number
GO
/*Tạo bảng tạm #Students*/
CREATE TABLE #Students(
  RollNo varchar(6) CONSTRAINT PK_Students PRIMARY KEY,
  FullName nvarchar(100),
  Birthday datetime CONSTRAINT DF_StudentsBirthday DEFAULT DATEADD(YY,-18,GETDATE())
)
GO
/*Tạo thủ tục lưu trữ tạm để chèn dữ liệu vào bảng tạm*/
CREATE PROCEDURE #spInsertStudents
   @rollNo varchar(6),
   @fullName nvarchar(100),
   @birthday datetime
AS BEGIN
   IF(@birthday IS NULL)
       SET @birthday=DATEADD(YY, -18, GETDATE())
   INSERT INTO #Students(RollNo, FullName, Birthday)
       VALUES (@rollNo, @fullName, @birthday)
END
GO
/*Sử dụng thủ tục lưu trữ để chèn dữ liệu vào bảng tạm*/
EXEC #spInsertStudents 'A12345', 'abc', NULL
EXEC #spInsertStudents 'A54321', 'abc', '12/24/2011'
SELECT * FROM #Students
/*Tạo thủ tục lưu trữ tạm để xóa dữ liệu từ bảng tạm theo RollNo*/
CREATE PROCEDURE #spDeleteStudents
   @rollNo varchar(6)
AS BEGIN
   DELETE FROM #Students WHERE RollNo = @rollNo
END
/*Xóa dữ liệu sử dụng thủ tục lưu trữ*/
EXECUTE #spDeleteStudents 'A12345'
GO
/*Tạo một thủ tục lưu trữ sử dung lệnh RETURN để trả về một số nguyên*/
CREATE PROCEDURE Cal_Square @num int = 0 AS
BEGIN
   RETURN (@num * @num);
END
GO
/*Chạy thủ tục lưu trữ*/
DECLARE @square int;
EXEC @square = Cal_Square 10;
PRINT @square;
GO
/*Xem định nghĩa thủ tục lưu trữ bằng hàm OBJECT_DEFINITION*/
SELECT 
OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdate'))
