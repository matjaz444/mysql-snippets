## Simple (my)sql snippets

Let's say you are db developer/data analyst for global web shop which sells subscriptions to leading knowledge webinars all over the world.

You've got assignment to prepare some stats based on records in two sql tables, named `[orders]` and `[users]`.

	select * from orders;
	+----+---------+-------+---------------------+
	| id | user_id | price | datetime            |
	+----+---------+-------+---------------------+
	|  1 |       1 |   333 | 2022-03-09 17:50:53 |
	|  2 |       3 |   111 | 2022-01-19 17:51:27 |
	|  3 |       1 |   555 | 2022-02-19 17:51:49 |
	|  4 |       1 |   111 | 2022-03-19 18:02:12 |
	|  5 |       1 |    10 | 2022-02-19 20:10:37 |
	|  6 |       2 |  1234 | 2021-12-19 20:33:52 |
	|  7 |       5 |   444 | 2022-01-13 23:30:28 |
	|  8 |       5 |    44 | 2022-02-08 23:30:28 |
	+----+---------+-------+---------------------+
	
	select * from users;
	+---------+-----------+----------+
	| user_id | username  | country  |
	+---------+-----------+----------+
	|       1 | user_si1  | Slovenia |
	|       2 | user_usa1 | USA      |
	|       3 | user_de1  | Germany  |
	|       4 | user_cog  | Congo    |
	|       5 | user_si2  | Slovenia |
	|       6 | user_usa2 | USA      |
	+---------+-----------+----------+
		
You need to answer next four analysis to marketing department.  

#### 1. volume by users all time
	select user_id, sum(price) as sumprice 
		from orders
		group by user_id /* group sums by userid */	
		order by sumprice desc;
	+---------+----------+
	| user_id | sumprice |
	+---------+----------+
	|       2 |     1234 |
	|       1 |     1009 |
	|       5 |      488 |
	|       3 |      111 |
	+---------+----------+
volume by users all time, add username to the view for simplicity:

	select orders.user_id, users.username, sum(orders.price) as sumprice 
		from orders, users
			where orders.user_id = users.user_id
		group by orders.user_id
		order by sumprice desc;
	+---------+-----------+----------+
	| user_id | username  | sumprice |
	+---------+-----------+----------+
	|       2 | user_usa1 |     1234 |
	|       1 | user_si1  |     1009 |
	|       5 | user_si2  |      488 |
	|       3 | user_de1  |      111 |
	+---------+-----------+----------+


#### 2. volume by users per month
	select user_id, sum(price), DATE_FORMAT(`datetime`,'%Y-%m') as date_month
		from orders
		group by date_month;
	+---------+------------+------------+
	| user_id | sum(price) | date_month |
	+---------+------------+------------+
	|       2 |       1234 | 2021-12    |
	|       3 |        555 | 2022-01    |
	|       1 |        609 | 2022-02    |
	|       1 |        444 | 2022-03    |
	+---------+------------+------------+

#### 3. volume by country
	select users.country, sum(orders.price) sumprice 
		from orders, users 
			where orders.user_id = users.user_id 
		group by users.country 
		order by sumprice desc;
	+----------+----------+
	| country  | sumprice |
	+----------+----------+
	| Slovenia |     1497 |
	| USA      |     1234 |
	| Germany  |      111 |
	+----------+----------+
	
#### 4. list countries with 0 EUR volume (no orders)
	select users.country, sum(orders.price) sumprice
		from users 
		left outer join orders on 
			users.user_id = orders.user_id
		group by users.country;
	+----------+----------+
	| country  | sumprice |
	+----------+----------+
	| Congo    |     NULL |
	| Germany  |      111 |
	| Slovenia |     1497 |
	| USA      |     1234 |
	+----------+----------+
	
As we see, countries which have no orders, get 'NULL' as the result of left outer join. With simple additional select we get only the countries where there are no orders in the `[orders]` table.

	select country from 
		(select users.country, sum(orders.price) sumprice
			from users 
				left outer join orders on 
					users.user_id = orders.user_id
				group by users.country
		) innersum
		where innersum.sumprice = 0 or innersum.sumprice is null;
	+---------+
	| country |
	+---------+
	| Congo   |
	+---------+
	

#### Note
If you work with a database that contains millions of data, it is recommended that you:  
a) run analytical queries on a readonly slave instance (in case there is a master-slave setup),   
  b) run queries on a separate server (use data import from daily backup).

