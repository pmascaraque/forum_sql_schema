create table users (
    id serial primary key,
    first_name varchar(255) not null,
    last_name text,
    age int,
    email text unique not null
);

drop table users;

insert into users
(first_name, last_name, age, email)
values
('bob', null, null, 'bob@bob6.com');

select * from users;

alter table users drop column age;
alter table users add column age int;

select * from users where age is not null;

update users
set age = age - 10
where age < 25;

select * from users;

delete from users
where last_name is null;
--  1 to many
create table posts(
    id serial primary key,
    title text not null,
    body text default '...',
    "creatorId" int references users(id) not null
);

insert into posts
    (title, "creatorId")
values ('the great sixth article', 4);

select * from posts;

delete from users
where id = 1;

delete from posts
where "creatorId" = 4;

select u.id user_id, p.id post_id,
first_name, title from users u
inner join posts p on u.id = p."creatorId"
where p.title ilike '%my%Post%' and u.id = 1;

-- 1 single user
-- 2 posts
-- x * (y, z) = (x, y), (x, z)

-- 1 to many with posts
-- 1 to many with users
create table comments (
    id serial primary key,
    message text not null,
    post_id int references posts(id),
    creator_id int references users(id)
);

select * from posts;

insert into comments
(message, post_id, creator_id)
values ('hello, nice post!', 2, 4);

select c.message, p.title,
u.id user_id_for_post,
u2.id user_id_for_comment
from comments c
inner join posts p on c.post_id = p.id
inner join users u on p."creatorId" = u.id
inner join users u2 on c.creator_id = u2.id;

-- favorites
-- user - post
-- many to many

-- favorites (join table)

create table favorites(
   user_id int references users(id),
   post_id int references posts(id),
   primary key (user_id, post_id) -- composite key
);

select * from users;
select * from posts;

insert into favorites
(user_id, post_id)
values (2, 11);

select * from favorites;

--friends table

create table friends (
    user_id1 int references users(id),
    user_id2 int references users(id),
    primary key (user_id1, user_id2)
);

insert into friends
    (user_id1, user_id2)
    values (1, 2);

select * from  friends;

--who has the most friends
select	
		max(u.first_name),
		user_id1,
		array_agg(user_id2),
		count(*)
from friends f
inner join users u on u.id = f.user_id1
group by user_id1
order by count(*) desc;

--post with most favorites

select max(p.title), post_id, count(*) from favorites f
inner join posts p on f.post_id = p.id
group by post_id 
order by count(*) desc;

--who has no friends

select * from users u
left join friends f 
	on f.user_id1 = u.id
		or f.user_id2 = u.id
where f.user_id1 is null;

--users with no posts

select * from users u
left join posts p 
	on p."creatorId" = u.id
where p."creatorId" is null;