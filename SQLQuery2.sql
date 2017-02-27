
use Northwind;
/*1.1	Выбрать в таблице Orders заказы, которые были доставлены до 1января 1997 года (колонка ShippedDate) и которые доставлены с ShipVia >= 3. 
Формат указания даты должен быть верным при любых региональных настройках, согласно требованиям статьи “Writing International Transact-SQL Statements” 
в Books Online раздел “Accessing and Changing Relational Data”. Этот метод использовать далее для всех заданий. Запрос должен высвечивать только колонки OrderID, ShippedDate и ShipVia. 
Пояснить почему сюда не попали заказы с NULL-ом в колонке ShippedDate.
*/

SELECT OrderId, ShippedDate, ShipVia 
 FROM dbo.Orders
 WHERE ShippedDate < '19970101' AND ShipVia >= 3;

/*1.2	Вывести всю информацию по заказам из крупных городов (не регионов).*/
SELECT * 
  FROM dbo.Orders 
  WHERE ShipRegion IS NULL;

/*1.3	Выбрать из таблицы Employees имена и фамилии всех сотрудников младше 50-ти  лет. 
Напротив имени каждого сотрудника в колонке с названием “Age” вывести его возраст.*/
SELECT FirstName, DATEDIFF(YEAR, BirthDate, GETDATE()) as 'Age', LastName 
  FROM dbo.Employees 
  WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) > 50;

/*1.4	Написать запрос, который выводит только компании без факса из таблицы Suppliers. 
В результатах запроса высвечивать для колонки Fax вместо значений NULL строку ‘No fax’ – использовать системную функцию CASЕ. 
Запрос должен высвечивать только колонки CompanyName и Fax.*/
SELECT CompanyName, 
  CASE 
    WHEN Fax IS NULL THEN 'No fax'
  END as 'Fax'
  FROM dbo.Suppliers WHERE Fax IS NULL;
 

 /*1.5	Выбрать в таблице Orders заказы, которые были доставлены до 6 мая 1998 года (ShippedDate) не включая эту дату или которые еще не доставлены. 
 В запросе должны высвечиваться только колонки OrderID (переименовать в Order Number) и ShippedDate (переименовать в Shipped Date). ]
 В результатах запроса высвечивать для колонки ShippedDate вместо значений NULL строку ‘Not Shipped’, для остальных значений высвечивать дату в формате по умолчанию.*/

SELECT OrderID as 'Order Number',
	 CASE
		WHEN ShippedDate IS NULL THEN 'Not Shipped' 
		ELSE  CAST(CAST(ShippedDate as DATE) as nvarchar)
	 END AS 'Shipped Date'
 FROM dbo.Orders
 WHERE ShippedDate < '19980506' OR ShippedDate is NULL;
 
 SELECT * FROM dbo.Orders;
 
 /*2.	Явное преобразование типов данных. Использование операторов CAST и CONVERT*/ 
 /*2.1	Вывести заказы, доставленные до 5 мая 2007 года. Выводить только OrderID и дату доставки его. Дату выводить в формате мес дд гггг чч:мм AM (или PM). Использовать функцию CAST.*/
  SELECT OrderID, CAST(ShippedDate AS nvarchar) 
  FROM dbo.Orders 
  WHERE ShippedDate < '20070505'
;
 /* 2.2	Вывести заказы, доставленные до 5 мая 2007 года. Выводить только OrderID и дату доставки его. Дату выводить в формате мм/дд/гггг.
Использовать функцию CONVERT.*/
SELECT OrderID, convert(varchar, ShippedDate, 101) as 'ShipperDate'
  FROM dbo.Orders 
  WHERE ShippedDate < '20070505'

/*3.	Использование операторов IN, DISTINCT, ORDER BY, NOT*/

/*3.1	Выбрать всех сотрудников, проживающих в Лондоне и Сиэтле. 
Запрос сделать с только помощью оператора IN. 
Высвечивать колонки с именем, фамилией пользователя и названием города в результатах запроса. 
Упорядочить результаты запроса по фамилии сотрудников.*/
SELECT FirstName, LastName, City
  FROM dbo.Employees
  WHERE City IN ('London', 'Seattle')
  ORDER BY LastName;

/*3.2	Выбрать из таблицы Employees всех сотрудников, не проживающих в Лондоне и Сиэтле. 
Запрос сделать с помощью оператора IN. Высвечивать колонки с именем, фамилией пользователя и названием города в результатах запроса. 
Упорядочить результаты запроса по фамилии сотрудников.*/
SELECT FirstName, LastName, City
  FROM dbo.Employees
  WHERE City NOT IN ('London', 'Seattle')
  ORDER BY LastName;

/*3.3	Выбрать из таблицы Customers все ContactTitle, которые в ней встречаются. 
Каждый ContactTitle должен быть упомянут только один раз и список отсортирован по возрастанию.
Не использовать предложение GROUP BY. Высвечивать только одну колонку в результатах запроса. */
SELECT DISTINCT ContactTitle
  FROM dbo.Customers
  ORDER BY ContactTitle ASC;

/*3.4	Вывести из таблицы Shippers поля CompanyName и ShipperID. 
Результаты запроса упорядочить по обоим полям в порядке, который указан. 
Объяснить, почему не все поля отсортировались по порядку.*/
SELECT CompanyName, ShipperID
  FROM dbo.Shippers
  ORDER BY CompanyName, ShipperID;

/*4.	Использование оператора BETWEEN, DISTINCT*/
/*4.1	Это задание необходимо выполнить 2-мя способами. 
Выбрать все заказы (OrderID) из таблицы Order Details (заказы не должны повторяться), где встречаются продукты с количеством от 1 до 6 не включая 1 и 6 – это 
колонка Quantity в таблице Order Details. Использовать оператор BETWEEN. Запрос должен высвечивать только колонку OrderID. */
SELECT DISTINCT OrderID
  FROM dbo.[Order Details]
  WHERE Quantity BETWEEN '2' AND '5';

SELECT DISTINCT OrderID
  FROM [Order Details]
  WHERE Quantity > 1 AND Quantity < 6;

/*4.2	Выбрать всех заказчиков из таблицы Customers, у которых вторая буква названия страны из диапазона o и r. Использовать оператор BETWEEN. 
Запрос должен высвечивать только колонки CustomerID и Country и отсортирован по Country. Почему работает запрос с условием заглавного регистра букв O и R?*/
SELECT CustomerID, Country
  FROM dbo.Customers
  WHERE SUBSTRING(Country, 2, 1) BETWEEN 'o' AND 'r' 
  ORDER BY Country;

/*4.3	Выбрать всех заказчиков из таблицы Customers, у которых вторая буква названия страны из диапазона o и r, не используя оператор BETWEEN.*/
 SELECT CustomerID, Country
  FROM dbo.Customers
  WHERE SUBSTRING(Country, 2, 1) >= 'o' AND SUBSTRING(Country, 2, 1) <= 'r' 
  ORDER BY Country;
  /*OR*/
 SELECT CustomerID, Country
  FROM dbo.Customers
  WHERE Country LIKE '_[o-r]%'
  ORDER BY Country;
/*5.	Использование оператора LIKE*/
/*5.1	Выбрать из таблицы  поставщиков все компании, названия которых начинаются на “L”.*/
 SELECT CompanyName
   FROM dbo.Suppliers
   WHERE CompanyName LIKE 'L%';

/*5.2	В таблице Products найти все продукты (колонка ProductName), где встречается двойное t ('tt').*/
 SELECT ProductName
   FROM dbo.Products
   WHERE ProductName LIKE '%tt%';

/*5.3	Необходимо вывести всю информацию о сотруднике(таблица Employees), чья фамилия точно не известна (Davolio или Diavolo).*/

 SELECT *
   FROM dbo.Employees
   WHERE LastName LIKE 'Davolio' OR LastName LIKE 'Diavolo';

/*6.   Использование агрегатных функций (SUM, COUNT,AVG)*/

/*6.1	Найти кол-во заказов со скидкой меньше 30%.*/
SELECT COUNT(OrderID) as 'Sum'
FROM dbo.[Order Details]
WHERE Discount < 0.3;

/*6.2	Найти общую сумму всех заказов из таблицы Order Details с учетом количества закупленных товаров и скидок по ним и вычесть из нее заказы,  в которых скидка меньше 15 процентов. 
Результат округлить до сотых. Скидка (колонка Discount) составляет процент из стоимости для данного товара. 
Для определения действительной цены на проданный продукт надо вычесть скидку из указанной в колонке UnitPrice цены. 
Результатом запроса должна быть одна запись с одной колонкой с названием колонки 'Totals'.*/
 SELECT ROUND((SUM((UnitPrice - UnitPrice*Discount)*Quantity) - (SELECT SUM((UnitPrice - UnitPrice*Discount)*Quantity) FROM dbo.[Order Details] WHERE Discount < 0.15)), 2) as Total
   FROM dbo.[Order Details];

 /* 
 SELECT SUM(UnitPrice - UnitPrice*Discount)
 FROM dbo.[Order Details];
 SELECT SUM(UnitPrice - UnitPrice*Discount) FROM dbo.[Order Details] WHERE Discount < 0.15*/

/*6.3	Найти разницу между максимальным и минимальным из всех заказов из таблицы Order Details с учетом количества закупленных товаров и скидок по ним. Результат округлить до сотых. */
 SELECT ROUND((MAX((UnitPrice - UnitPrice*Discount)*Quantity) - MIN((UnitPrice - UnitPrice*Discount)*Quantity)), 2) as Total
   FROM dbo.[Order Details];
 /*SELECT ROUND(MAX((UnitPrice - UnitPrice*Discount)*Quantity), 2) as Total
   FROM dbo.[Order Details];
 SELECT ROUND(MIN((UnitPrice - UnitPrice*Discount)*Quantity), 2) as Total
   FROM dbo.[Order Details];*/

/*6.4	Найти среднее кол-во продуктов в заказах.*/
SELECT AVG(Quantity) as 'AvgQuantity'
  FROM dbo.[Order Details];

/*6.5	По таблице Orders найти количество заказов, которые уже доставлены (т.е. в колонке ShippedDate есть значение  даты доставки). 
Использовать при этом запросе только оператор COUNT. Не использовать предложения WHERE и GROUP*/
SELECT COUNT(ShippedDate)
  FROM dbo.Orders;

/*6.6	По таблице Customers найти количество различных городов, в которых расположены заказчики. Использовать функцию COUNT и не использовать предложения WHERE и GROUP.*/
SELECT  COUNT(DISTINCT City) as 'Count of unique cities'
  FROM dbo.Customers;

/*7.	Явное соединение таблиц, самосоединения, использование агрегатных функций и предложений GROUP BY и HAVING.*/