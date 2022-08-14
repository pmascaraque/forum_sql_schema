--post feed (tables and data in ./gen_data.sql)

--add created_at column
alter table posts 
	add column created_at date
default now() - (random() * interval '100 days');

select * from posts;


--fetch m posts (feed)
select p.created_at, p.title,
	substr(p.body, 1, 30), u.first_name from posts p
inner join users u on p."creatorId" = u.id
order by created_at desc
offset 0
limit 20;

--fetch 1 post
select	p.title,
		u.first_name,
		c.message,
		u2.first_name comment_creator,
		f.user_id is not null has_favorited
from posts p
inner join users u on p."creatorId" = u.id
inner join comments c on p.id = c.post_id
inner join users u2 on u2.id = c.creator_id 
left join favorites f
	on f.post_id = p.id and f.user_id = 68 	--has current user (68) favorited the fetched post(15)
											-- these values should be passed on by your ts server
where p.id = 15; 

--favorites on a post
select * from favorites 
where post_id = 15;

--count comments on post
select count(*) from comments c
inner join users u on u.id = c.creator_id
where post_id = 7;