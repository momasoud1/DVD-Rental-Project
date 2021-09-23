-- Question set#1 query1
select c.name filmcategory,
       count(r.rental_id) rentalcount
from category c
join film_category fc
on c.category_id = fc.category_id
join film f
on fc.film_id = f.film_id
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
where c.name in ('Children','Animation','Music','Classics','Comedy','Family')
group by 1
order by 2 desc ;

-- Question set#1 Query2
select  c.name category,  f.rental_duration rental_duration,
       Ntile(4) over (order by f.rental_duration) as standard_quartile
from category c
join film_category fc
on c.category_id= fc.category_id
join film f
on fc.film_id = f.film_id
where c.name in ('Children','Animation','Music','Classics','Comedy','Family');

-- Question set#1 Query3
select  category,standard_quartile ,COUNT(rental_duration) 
from  (select f.title filmtitle,
       c.name category,
       f.rental_duration rental_duration,
       Ntile(4) over (order by f.rental_duration) as standard_quartile
       from category c
       join film_category fc
       on c.category_id= fc.category_id
       join film f
       on fc.film_id = f.film_id
       where c.name in ('Children','Animation','Music','Classics','Comedy','Family')
     )sub
group by 1,2
order by 1,2;

-- Question set#2 Query2
with t1 as  (select  c.first_name ||' ' ||c.last_name fullname,
     sum(p.amount) pay_amount
     from customer c
     join payment p
     on c.customer_id = p.customer_id
	 group by 1
	 order by 2 desc
     limit 10),
t2 as ( select c.first_name ||' ' ||c.last_name  fullname,
       date_trunc('month', p.payment_date)       pay_month,
        sum(p.amount) pay_amount,
        count(*) count_permonth
       from customer c
       join payment p
       on c.customer_id = p.customer_id
       where Payment_date between '2007-01-01' and '2007-12-31'
       group by 1,2
       order by 1,2)
select *
from t1
join t2
on  t1.fullname =t2.fullname ;
