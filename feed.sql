--post feed (tables and data in ./gen_data.sql)

--add created_at column
alter table posts 
	add column created_at date
default now() - (random() * interval '100 days');

select * from posts;


--feed
select p.created_at, p.title,
	substr(p.body, 1, 30), u.first_name from posts p
inner join users u on p."creatorId" = u.id
order by created_at desc
offset 0
limit 20;