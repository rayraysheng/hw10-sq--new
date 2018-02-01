use sakila;

-- 1a.
select first_name, last_name from actor;

-- 1b.
select upper(concat(first_name, ' ', last_name)) as full_name
from actor;

-- 2a.
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- 2b.
select actor_id, first_name, last_name
from actor
where last_name like '%gen%';

-- 2c.
select actor_id, last_name, first_name
from actor
where last_name like '%li%'
order by last_name asc, first_name asc;

-- 2d.
select country, country_id
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a.
alter table actor
    add column middle_name varchar(45)
    after first_name;
    
-- 3b.
alter table actor
    modify column middle_name blob;
    
-- 3c.
alter table actor
    drop middle_name;
    
-- 4a.
select last_name, count(last_name)
from actor
group by last_name;

-- 4b.
select last_name, count(last_name)
from actor
group by last_name
having count(last_name) >= 2; 

-- 4c.
update actor
	set first_name = 'HARPO'
    where first_name = 'groucho' and last_name = 'williams';
    
-- 5a.
show create table address;

-- 6a.
select s.first_name, s.last_name, a.address
from staff s
left join address a
using(address_id);

-- 6b.
select s.staff_id, s.first_name, s.last_name, sum(p.amount)
from staff s
left join payment p
using(staff_id)
where p.payment_date like '2005-08%'
group by staff_id; 

-- 6c.
select f.title, count(fa.actor_id)
from film f
inner join film_actor fa
using(film_id)
group by title;

-- 6d.
select f.title, count(i.inventory_id)
from film f
inner join inventory i
using(film_id)
group by title
having title = 'Hunchback Impossible';

-- 6e.
select c.customer_id, c.last_name, c.first_name, sum(p.amount)
from customer c
left join payment p
using(customer_id)
group by customer_id
order by last_name;

-- 7a.
select title from film
where (
    language_id = (
        -- Find which language id matches English
        select language_id from language
        where name = 'English'
        )
    and 
        (
        title like 'K%' or title like 'Q%'
        )
	);
    
-- 7b.
select actor_id, first_name, last_name from actor
where actor_id in (
	-- Find the actor ids from the film_actor table that match the film
	select actor_id from film_actor
	where film_id = (
		-- Find which film id matches the film title from the film table
		select film_id from film
        where title = 'Alone Trip'
	    )
    );

-- 7c.
select cus.customer_id, cus.first_name, cus.last_name, cus.email
from customer cus
inner join address using(address_id)
inner join city using(city_id)
inner join country using(country_id)
where country = 'Canada';

-- 7d.
select title from film
where film_id in (
    -- Find which film ids match the category
    select film_id from film_category
    where category_id = (
        -- Find which category id matches the category
        select category_id from category where name = 'Family'
    )
);

-- 7e.
select f.title, count(r.rental_id)
from film f
left join inventory using(film_id)
left join rental r using(inventory_id)
group by f.title
order by count(r.rental_id) desc;

-- 7f.
select s.store_id, sum(p.amount)
from store s
left join customer using(store_id)
left join payment p using(customer_id)
group by s.store_id;

-- 7g.
select s.store_id, city.city, country.country
from store s
left join address using(address_id)
left join city using(city_id)
left join country using(country_id);

-- 7h.
select cat.name, sum(p.amount)
from category cat
left join film_category using(category_id)
left join film using(film_id)
left join inventory using(film_id)
left join rental using(inventory_id)
left join payment p using (rental_id)
group by cat.name
order by sum(p.amount) desc
limit 5;

-- 8a.
create view top_five_genres as
select cat.name, sum(p.amount)
from category cat
left join film_category using(category_id)
left join film using(film_id)
left join inventory using(film_id)
left join rental using(inventory_id)
left join payment p using (rental_id)
group by cat.name
order by sum(p.amount) desc
limit 5;

-- 8b.
select * from top_five_genres;

-- 8c.
drop view top_five_genres;