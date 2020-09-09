-- COMP9311 18s2 Assignment 1
-- Schema for the myPhotos.net photo-sharing site
--
-- Written by:
--    Name:  <<YOUR NAME GOES HERE>>
--    Student ID:  <<YOUR STUDENT ID GOES HERE>>
--    Date:  ??/09/2018
--
-- Conventions:
-- * all entity table names are plural
-- * most entities have an artifical primary key called "id"
-- * foreign keys are named after either:
--   * the relationship they represent
--   * the table being referenced

-- Domains (you may add more)

create domain URLValue as
	varchar(100) check (value like 'http://%');

create domain KBfilesize as
	text check (value like '%.KB$');

create domain SafeValue as
	varchar(20) check (value in ('safe','moderate','restricted'));

create domain VisibilityValue as
	varchar(50) check (value in ('private','friends','family','friends+family','public'));

create domain EmailValue as
	varchar(100) check (value like '%@%.%');

create domain GenderValue as
	varchar(6) check (value in ('male','female'));
	
create domain RatingValue as
	varchar(3) check (value in ('1','2','3','4','5'));

create domain GroupModeValue as
	varchar(15) check (value in ('private','by-invitation','by-request'));

create domain ContactListTypeValue as
	varchar(10) check (value in ('friends','family'));

create domain NameValue as varchar(50);

create domain OrderValue as 
	smallint  check(value >0);

create domain LongNameValue as varchar(100);


-- Tables (you must add more)

create table People (
	id          serial,
	family_name  NameValue,
	given_names  NameValue not null,
	displayed_name LongNameValue ,
	email_address   EmailValue not null,
	primary key (id)
);

create table Users (
	id 			integer,
	date_registered date,
	brithday       date,
	gender         GenderValue,
	password       text not null,
	primary key (id),
	foreign key (id) references People(id)
);

create table Groups (
	id     integer,
	title  text,
	mode   GroupModeValue,
	owner   LongNameValue,
	primary key (id)
);


create table Contact_lists (
	id integer,
	type ContactListTypeValue,
	title text,
	owner   LongNameValue,
	primary key (id)
);

create table Photos (
	id serial,
	title  NameValue,
	description text,
	date_uploaded date default now(),
	date_taken  date,
	owner   integer,
	file_size KBfilesize,
	technical text,
	primary key (id),
	foreign key (owner) references Users (id)
);

create table Comments(
	id serial primary key,
	title NameValue,
	when_posted date,
	content text,
	author integer,
	replyTo integer,
	foreign key(replyTo) references Comments(id)
);

create table Discussions(
	id    serial primary key,
	contains integer,
	title text
);
alter table Comments add constraint FK_constraint
	foreign key (author) REFERENCES Discussions(id);
alter table Discussions add constraint FK_constraint
	foreign key (contains) REFERENCES Comments(id);

create table Collections(
	id serial primary key,
	description text,
	title NameValue,
	key integer,
	foreign key (key) references Photos(id)
);

create table User_Collection(
	id integer primary key,
	owns integer,
	foreign key (id) references Collections(id),
	foreign key (owns) references Users(id)
);

create table Group_Collleciton(
	id integer primary key,
	owns integer,
	foreign key (id) references Collections(id),
	foreign key (owns) references Groups(id)
);

create table Tags(
	id text primary key,
	freq integer,
	name NameValue
);

create table User_rates_photos(
	whenrated date,
	rating 	RatingValue,
	"User" integer,
	Photo integer,
	primary key("User",Photo),
	foreign key("User") references Users (id),
	foreign key(Photo) references Photos (id)
);

create table Photo_has_Tags(
	when_tagged date,
	"User" integer,
	Tag   text,
	primary key ("User",Tag),
	foreign key ("User") references Users(id),
	foreign key (Tag) references Tags(id)
);

create table Photo_in_Collection(
	Photo integer,
	Collection integer,
	"order" OrderValue,
	primary key (Photo,Collection),
	foreign key (Photo) references Photos(id),
	foreign key (Collection) references Collections(id)
);

create table User_member_Group(
	"User" integer,
	"Group" integer,
	primary key("User","Group"),
	foreign key("User") references Users(id),
	foreign key("Group") references Groups(id)
);

create table Person_member_ContactList(
	Person integer,
	ContactList integer,
	primary key(Person,ContactList),
	foreign key(Person) references People(id),
	foreign key(ContactList) references Contact_Lists(id)
);

create table Group_has_Discussion(
	Discussion integer,
	"Group"   integer,
	primary key(Discussion, "Group"),
	foreign key (Discussion) references Discussions(id),
	foreign key ("Group") references Groups(id)
);





