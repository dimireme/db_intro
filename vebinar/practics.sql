use vk;
select * from users where id = 1;
select * from users limit 1;
select firstname as fn, lastname as ln from users limit 1;

------ Профиль
-- Выбираем фото нашего пользователя
-- Запрос с подзапросами. Более медленная альтернатива джойнов.
select
	firstname,
	lastname,
	(
		select filename
		from media
		where id = (
			select photo_id
			from profiles
			where user_id = 1
		)
	) as main_photo,
	(
		select hometown
		from profiles
		where user_id = 1
	) as city
from users
where id = 1;

-- Выбираем все фото пользователя
select filename from media
where user_id = 1
	and media_type_id = (
		select id
		from media_types
		where name like 'photo' -- like не чувствителен к регистру. % - любое число символов. _ - один символ
	);

------ Новости
-- Выбираем новости пользователя
select *
from media
where user_id = 1;

-- Выбираем путь к файлам медиа, которые есть в новостях (они же фото)
select filename
from media
where user_id = 1
	and media_type_id = (
		select id
		from media_types
		where name = 'photo'
	);

-- Подсчитываем количество таких файлов
select count(*)
from media
where user_id = 1
	and media_type_id = (
		select id
		from media_types
		where name = 'photo'
	);

------ Друзья пользователя
desc friend_requests;
describe friend_requests;

select *
from friend_requests
where initiator_user_id = 1 -- мои заявки
	or target_user_id = 1 -- заявки ко мне
;

select *
from friend_requests
where (initiator_user_id = 1 -- мои заявки
	or target_user_id = 1 -- заявки ко мне
	) and status = 'approved'
;


------ Новости друзей
-- подзапрос 1
select initiator_user_id
	from friend_requests
	where target_user_id = 1
		and status = 'approved';

-- подзапрос 2
select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved';

-- запрос
select * from media where user_id = 1
union
select *
from media
-- where iser_id in (1,2,4,6)
where user_id in (
	select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
	union
	select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved'
)
order by created_at desc
limit 10 offset 0;


------ Лайки
desc likes;

-- посчитаем лайки для моих новостей
select media_id, count(*)
from likes
-- where media_id in (1,2,5)
where media_id in (
	select id from media where user_id = 1 -- мои медиа
)
group by media_id
order by count(*) desc;

-- то же с JOIN
select m.id, count(*)
from likes l
	join media m on m.id = l.media_id
where m.user_id = 1 -- мои медиа
group by m.id
order by count(*) desc;

-- архив новостей по месяцам (скоьлко новостей было создано в каждом месяце)
select
	count(id) as news_count,
	month(created_at) as month,
	monthname(created_at)
from media
group by month
order by month;

-- сколько новостей у каждого пользователя
select count(*), user_id
from media
group by user_id
order by count(*) desc;


------ Сообщения
-- выбираем сообщения от меня и ко мне
desc messages;

select *
from messages
where from_user_id = 1
	or to_user_id = 1
order by created_at desc;

-- добавим статус сообщения в таблицу messages
alter table messages
add column is_read BOOL default false;

-- получим все не прочитанные сообщения
select *
from messages
where
	(from_user_id = 1
	or to_user_id = 1)
	and is_read = false
order by created_at desc;

-- обновим старые сообщения, сделаем их прочтенными
update messages
set is_read = true
where created_at < date_sub(now(), interval 100 day);


-- выводим друзей пользователя с преобразованием пола и возраста
select
	user_id,
	case (gender)
		when 'm' then 'mail'
		when 'f' then 'female'
	end as gender,
	timestampdiff(year, birthday, now()) as age
from profiles
where user_id in (
	select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
	union
	select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved'
);
