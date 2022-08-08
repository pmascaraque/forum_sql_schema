--basic post, comment & like DB schema

--users

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

--posts (1-m)

create table posts(
    id serial primary key,
    title text not null,
    body text default '...',
    "creatorId" int references users(id) not null
);

insert into posts
	(title, creator_id)
values ('the great fifth post', 5);

select * from posts;

select u.id users_id, p.id posts_id,
first_name, title from users u
inner join posts p on u.id = p.creator_id
where p.title ilike '%sEcOnd%' and u.id = 1;

--comments

create table comments (
	id serial primary key,
	message text not null,
	post_id int references posts(id),
	creator_id int references users(id)
);

drop table comments;

insert into comments
(message, post_id, creator_id)
values('hello, nice post!', 2, 5);

select * from comments;

select c.message, p.title,
u.first_name author_post,
u2.first_name author_comment
from comments c
inner join posts p on c.post_id = p.id
inner join users u on p.creator_id = u.id
inner join users u2 on c.creator_id = u2.id;

--favorites (m-m)

--join table
create table favorites(
	user_id int references users(id),
	post_id int references posts(id),
	primary key (user_id, post_id) -- composite key
)

insert into favorites
(user_id, post_id)
values (2, 7)

select * from favorites;

--friends

--join table
create table friends(
	user_id1 int references users(id),
	user_id2 int references users(id),
	primary key (user_id1, user_id2)
);

insert into friends 
	(user_id1, user_id2)
	values (1, 2);
	
select * from friends;