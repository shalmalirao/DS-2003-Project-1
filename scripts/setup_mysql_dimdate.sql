CREATE DATABASE IF NOT EXISTS healthcare_mart;
USE healthcare_mart;

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
   DateKey INT NOT NULL PRIMARY KEY,
   DateValue DATE NOT NULL,
   DayNum TINYINT NOT NULL,
   DaySuffix CHAR(2) NOT NULL,
   WeekdayNum TINYINT NOT NULL,
   WeekDayName VARCHAR(10) NOT NULL,
   WeekDayName_Short CHAR(3) NOT NULL,
   WeekDayName_FirstLetter CHAR(1) NOT NULL,
   DOWInMonth TINYINT NOT NULL,
   DayOfYear SMALLINT NOT NULL,
   WeekOfMonth TINYINT NOT NULL,
   WeekOfYear TINYINT NOT NULL,
   MonthNum TINYINT NOT NULL,
   MonthName VARCHAR(10) NOT NULL,
   MonthName_Short CHAR(3) NOT NULL,
   MonthName_FirstLetter CHAR(1) NOT NULL,
   QuarterNum TINYINT NOT NULL,
   QuarterName VARCHAR(6) NOT NULL,
   YearNum INT NOT NULL,
   MMYYYY CHAR(6) NOT NULL,
   MonthYear CHAR(7) NOT NULL,
   IsWeekend BOOLEAN NOT NULL,
   IsHoliday BOOLEAN NOT NULL,
   HolidayName VARCHAR(20),
   SpecialDays VARCHAR(20),
   FinancialYear INT,
   FinancialQuarter INT,
   FinancialMonth INT,
   FirstDateOfYear DATE,
   LastDateOfYear DATE,
   FirstDateOfQuarter DATE,
   LastDateOfQuarter DATE,
   FirstDateOfMonth DATE,
   LastDateOfMonth DATE,
   FirstDateOfWeek DATE,
   LastDateOfWeek DATE,
   CurrentYear SMALLINT,
   CurrentQuarter SMALLINT,
   CurrentMonth SMALLINT,
   CurrentWeek SMALLINT,
   CurrentDay SMALLINT
);

DELIMITER //

DROP PROCEDURE IF EXISTS Populatedim_date//
CREATE PROCEDURE Populatedim_date(IN startDate DATE, IN endDate DATE)
BEGIN
  DECLARE currentDate DATE;
  SET currentDate = startDate;

  WHILE currentDate <= endDate DO
    INSERT INTO dim_date (
      DateKey, DateValue, DayNum, DaySuffix, WeekdayNum, WeekDayName,
      WeekDayName_Short, WeekDayName_FirstLetter, DOWInMonth, DayOfYear,
      WeekOfMonth, WeekOfYear, MonthNum, MonthName, MonthName_Short,
      MonthName_FirstLetter, QuarterNum, QuarterName, YearNum, MMYYYY,
      MonthYear, IsWeekend, IsHoliday, HolidayName, SpecialDays,
      FinancialYear, FinancialQuarter, FinancialMonth,
      FirstDateOfYear, LastDateOfYear,
      FirstDateOfQuarter, LastDateOfQuarter,
      FirstDateOfMonth, LastDateOfMonth,
      FirstDateOfWeek, LastDateOfWeek,
      CurrentYear, CurrentQuarter, CurrentMonth, CurrentWeek, CurrentDay
    )
    SELECT
      YEAR(currentDate)*10000 + MONTH(currentDate)*100 + DAY(currentDate),
      currentDate,
      DAY(currentDate),
      CASE
        WHEN DAY(currentDate) IN (1,21,31) THEN 'st'
        WHEN DAY(currentDate) IN (2,22) THEN 'nd'
        WHEN DAY(currentDate) IN (3,23) THEN 'rd'
        ELSE 'th'
      END,
      DAYOFWEEK(currentDate),
      DAYNAME(currentDate),
      UPPER(LEFT(DAYNAME(currentDate),3)),
      LEFT(DAYNAME(currentDate),1),
      DAY(currentDate),
      DAYOFYEAR(currentDate),
      WEEK(currentDate) - WEEK(DATE_ADD(currentDate, INTERVAL -DAY(currentDate)+1 DAY)) + 1,
      WEEKOFYEAR(currentDate),
      MONTH(currentDate),
      MONTHNAME(currentDate),
      UPPER(LEFT(MONTHNAME(currentDate),3)),
      LEFT(MONTHNAME(currentDate),1),
      QUARTER(currentDate),
      CASE QUARTER(currentDate)
        WHEN 1 THEN 'First'
        WHEN 2 THEN 'Second'
        WHEN 3 THEN 'Third'
        WHEN 4 THEN 'Fourth'
      END,
      YEAR(currentDate),
      LPAD(MONTH(currentDate),2,'0') + 0 + YEAR(currentDate),  
      CONCAT(YEAR(currentDate), LEFT(MONTHNAME(currentDate),3)),
      (DAYOFWEEK(currentDate) IN (1,7)),
      FALSE,
      NULL,
      NULL,
      YEAR(currentDate),
      QUARTER(currentDate),
      MONTH(currentDate),
      MAKEDATE(YEAR(currentDate),1),
      MAKEDATE(YEAR(currentDate),365),
      DATE_ADD(MAKEDATE(YEAR(currentDate), (QUARTER(currentDate)-1)*91+1), INTERVAL 0 DAY),
      DATE_ADD(MAKEDATE(YEAR(currentDate), QUARTER(currentDate)*91), INTERVAL -1 DAY),
      DATE_ADD(currentDate, INTERVAL -DAY(currentDate)+1 DAY),
      LAST_DAY(currentDate),
      DATE_SUB(currentDate, INTERVAL (DAYOFWEEK(currentDate)-1) DAY),
      DATE_ADD(currentDate, INTERVAL (7-DAYOFWEEK(currentDate)) DAY),
      NULL,NULL,NULL,NULL,NULL;
    SET currentDate = DATE_ADD(currentDate, INTERVAL 1 DAY);
  END WHILE;
END//
DELIMITER ;

CALL Populatedim_date('2025-01-01','2025-12-31');

UPDATE dim_date SET IsHoliday = TRUE, HolidayName = 'Christmas' WHERE MonthNum = 12 AND DayNum = 25;
UPDATE dim_date SET SpecialDays = 'Valentines Day' WHERE MonthNum = 2 AND DayNum = 14;

SELECT COUNT(*) AS RowsLoaded, MIN(DateValue) AS StartDate, MAX(DateValue) AS EndDate FROM dim_date;
