-- 1.non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT FirstName, LastName, CustomerId, Country FROM Customer WHERE Country != "USA";

-- 2.brazil_customers.sql: Provide a query only showing the Customers from Brazil.

SELECT * FROM Customer WHERE Country = "Brazil"

-- 3.brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
#with joins
#SELECT cust.FirstName, cust.LastName, inv.InvoiceId, inv.InvoiceDate, inv.BillingCountry
#FROM Invoice as inv LEFT JOIN Customer as cust on inv.CustomerId = cust.CustomerId WHERE inv.BillingCountry = "Brazil";

#without Joins
SELECT Customer.FirstName, Customer.LastName, Invoice.InvoiceId, Invoice.InvoiceDate, Invoice.BillingCountry
FROM Invoice, Customer
where Invoice.CustomerId = Customer.CustomerId
and Invoice.BillingCountry = "Brazil"

-- 4.sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.
SELECT * FROM Employee WHERE Title = "Sales Support Agent";

-- 5.unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
Select DISTINCT BillingCountry From Invoice;

-- 6.sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
--SELECT emp.FirstName, emp.LastName, emp.Title, inv.InvoiceId
--FROM Customer as cust LEFT JOIN Invoice as inv ON cust.customerId = inv.customerId
--LEFT JOIN Employee as emp ON cust.SupportRepId = emp.EmployeeId WHERE emp.Title = "Sales Support Agent";

Select Employee.FirstName, Employee.LastName, Employee.Title, Invoice.InvoiceId
From Employee, Invoice, Customer
where Employee.EmployeeId = Customer.SupportRepId
and Customer.CustomerId = Invoice.CustomerId
and Employee.Title = "Sales Support Agent"

-- 7.invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT Customer.FirstName, Customer.LastName, Invoice.Total, Invoice.BillingCountry, Employee.FirstName, Employee.LastName, Employee.Title
FROM Invoice, Customer, Employee
where Employee.EmployeeId = Customer.SupportRepId
and Customer.CustomerId = Invoice.CustomerId;

#SELECT cust.FirstName, cust.LastName, inv.Total, emp.FirstName, emp.LastName, cust.Country
#FROM Customer as cust LEFT JOIN Invoice as inv ON cust.customerId = inv.customerId
#LEFT JOIN Employee as emp ON cust.SupportRepId = emp.EmployeeId

-- 8.total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?
SELECT COUNT(InvoiceId) FROM Invoice 
WHERE InvoiceDate BETWEEN "2009-01-01 00:00:00" and "2012-01-01 00:00:00";

-- 9.total_sales_{year}.sql: What are the respective total sales for each of those years?
SELECT SUM(Total)
FROM Invoice
WHERE InvoiceDate GLOB "2009*" OR InvoiceDate GLOB "2011*"
GROUP BY InvoiceDate GLOB "2011*";

-- 10.invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(InvoiceId)
FROM InvoiceLine
WHERE InvoiceId = "37";

-- 11.line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT InvoiceId, COUNT(InvoiceId) as "Line Items"
FROM InvoiceLine
GROUP BY InvoiceId;

-- 12.line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
SELECT t.Name, art.Name, il.*
FROM Track as t LEFT JOIN InvoiceLine as il ON t.TrackId = il.TrackId
LEFT JOIN Album as a ON t. AlbumId = a.AlbumId
LEFT JOIN Artist as art ON a.AlbumId = art.ArtistId;

-- 13.line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT t.Name, art.Name, il.*
FROM Track as t LEFT JOIN InvoiceLine as il ON t.TrackId = il.TrackId
LEFT JOIN Album as a ON t. AlbumId = a.AlbumId
LEFT JOIN Artist as art ON a.AlbumId = art.ArtistId;

-- 14.country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT BillingCountry, COUNT(InvoiceId)
FROM Invoice
GROUP BY BillingCountry;

-- 15.playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.
SELECT p.name, COUNT(pt.TrackId)
From Playlist as p LEFT JOIN PlaylistTrack as pt ON p.PlaylistId = pt.PlaylistId
group by p.PlaylistId

-- 16. tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
SELECT Track.Name, Album.Title, MediaType.Name, Genre.Name
FROM Track, Album, MediaType, Genre
where Track.AlbumId = Album.AlbumId
and Track.MediaTypeId = MediaType.MediaTypeId
and Track.GenreId = Genre.GenreId;



-- 17.invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT inv.*, il.Quantity
FROM Invoice as inv LEFT JOIN InvoiceLine as il ON inv.InvoiceId = il.InvoiceId


-- 18.sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
SELECT emp.Title, Count (cust.SupportRepId)
FROM Customer as cust LEFT JOIN Employee as emp ON cust.SupportRepId = emp.EmployeeId
GROUP BY emp.EmployeeId;

#
#SELECT Employee.Title, Employee.FirstName, Employee.LastName, Count (Customer.SupportRepId)
#FROM Customer, Employee
#where Customer.SupportRepId = Employee.EmployeeId
#GROUP BY Employee.EmployeeId;

-- 19.top_2009_agent.sql: Which sales agent made the most in sales in 2009?

--     Hint: Use the MAX function on a subquery.

SELECT MAX(winner.totalsales) as TotalSales, winner.name
FROM (SELECT emp.Title, emp.FirstName as name, SUM (inv.Total) as totalsales
    FROM Customer as cust LEFT JOIN Employee as emp ON cust.SupportRepId = emp.EmployeeId
    LEFT JOIN Invoice as inv ON cust.CustomerId = inv.CustomerId
    WHERE inv.InvoiceDate GLOB "2009*" 
    GROUP BY emp.EmployeeId ORDER BY SUM (inv.Total) DESC) AS winner;


-- 20. top_agent.sql: Which sales agent made the most in sales over all?

SELECT MAX(winner.totalsales) as TotalSales, winner.name
FROM (SELECT emp.Title, emp.FirstName as name, SUM (inv.Total) as totalsales
    FROM Customer as cust LEFT JOIN Employee as emp ON cust.SupportRepId = emp.EmployeeId
    LEFT JOIN Invoice as inv ON cust.CustomerId = inv.CustomerId
    GROUP BY emp.EmployeeId ORDER BY SUM (inv.Total) DESC) AS winner;

-- 21. sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
Select Employee.FirstName, Employee.LastName, Employee.Title, Count(Customer.CustomerId)
From Employee, Customer
where Employee.EmployeeId = Customer.SupportRepId
GROUP BY Employee.EmployeeId

-- 22.sales_per_country.sql: Provide a query that shows the total sales per country.
SELECT BillingCountry, SUM(Total)
FROM invoice
GROUP BY BillingCountry;

-- 23.top_country.sql: Which country's customers spent the most?
SELECT i.BillingCountry, SUM (i.Total)
FROM Invoice as i LEFT JOIN Customer as c ON i.CustomerId = c.CustomerId
GROUP BY i.BillingCountry ORDER BY SUM (i.Total) DESC LIMIT 1;

-- 24.top_2013_track.sql: Provide a query that shows the most purchased track of 2013.
SELECT t.Name 'Track', count(*) 'Purchases'
FROM Track t, Invoice inv, InvoiceLine il
WHERE t.TrackId = il.TrackId and inv.InvoiceId = il.InvoiceId and inv.InvoiceDate GLOB "2013*"
GROUP BY t.TrackId
ORDER BY COUNT(*) desc LIMIT 1;

-- 25.top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.
SELECT t.Name, COUNT (il.InvoiceId) as Sales, SUM (i.Total) as Money
FROM Track as t LEFT JOIN InvoiceLine as il ON t.TrackId = il.TrackId
LEFT JOIN Invoice as i ON il.InvoiceId = i.InvoiceId
GROUP BY il.InvoiceId ORDER BY Money DESC LIMIT 5;

-- 26.top_3_artists.sql: Provide a query that shows the top 3 best selling artists.
SELECT  art.Name, COUNT (a.ArtistId) as NumberAlbumsSold, SUM (i.Total) as TotalMoney
FROM Track as t LEFT JOIN InvoiceLine as il ON t.TrackId = il.TrackId
LEFT JOIN Album as a ON t.AlbumId = a.AlbumId
LEFT JOIN Invoice as i ON il.InvoiceId = i.InvoiceId
LEFT JOIN Artist as art ON a.ArtistId = art.ArtistId
GROUP BY art.Name ORDER BY TotalMoney DESC LIMIT 3;

-- 27.top_media_type.sql: Provide a query that shows the most purchased Media Type.
SELECT mt.Name, COUNT (t.MediaTypeId) as NumberSold
FROM Track as t LEFT JOIN MediaType as mt ON t.MediaTypeId = mt.MediaTypeId
LEFT JOIN InvoiceLine as il ON t.TrackId = il.TrackId
LEFT JOIN Invoice as i ON il.InvoiceId = i.InvoiceId
GROUP BY mt.Name ORDER BY NumberSold DESC LIMIT 1;
