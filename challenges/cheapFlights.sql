/*Please add ; after each select statement*/
CREATE PROCEDURE cheapestFlights()
BEGIN
	DROP TEMPORARY TABLE IF EXISTS flights4;	
CREATE TEMPORARY TABLE IF NOT EXISTS flights4(
	SELECT * FROM 
	(SELECT origin, destination, 0 AS stops, cost FROM flights 
	UNION ALL
	(
	SELECT f1.origin, f3.destination, 2 AS stops, (f1.cost+f2.cost+f3.cost) AS cost
	FROM flights f1 
	INNER JOIN flights f2 ON f2.origin = f1.destination 
	INNER JOIN flights f3 ON f3.origin = f2.destination 
	)  
	UNION ALL
	(
	SELECT f1.origin, f2.destination, 1 AS stops, (f1.cost+f2.cost)  AS cost
	FROM flights f1 
	INNER JOIN flights f2 ON f2.origin = f1.destination 
	) 
	) AS tbl ORDER BY origin, destination,cost, stops

);
DROP TEMPORARY TABLE IF EXISTS flights5;	
CREATE TEMPORARY TABLE IF NOT EXISTS flights5 (SELECT * FROM flights4);

SELECT f1.origin, f1.destination, f1.stops, f1.cost as total_cost FROM flights4 f1
LEFT JOIN flights5 f2 ON f1.origin = f2.origin AND f1.destination = f2.destination 
AND f1.cost > f2.cost
WHERE f2.origin IS NULL and f1.origin <> f1.destination
GROUP BY f1.origin, f1.destination 
ORDER BY f1.origin, f1.destination;
END