create domain PositiveIntegerValue as
	integer check (value > 0);

create domain PersonAge as
	integer check (value >= 0 and value <= 200);
--	integer check (value between 0 and 200);

create domain UnswCourseCode as
	char(8) check (value ~ '[A-Z]{4}[0-9]{4}');
--	text check (value ~ '^[A-Z]{4}[0-9]{4}$');

create domain UnswSID as
	char(7) check (value ~ '[0-9]{7}');
--	integer check (value >= 1000000 and value <= 9999999);

create type IntegerPair as
	(x integer, y integer);

create domain UnswGradesDomain as
	char(2) check (value in ('FL','PS','CR','DN','HD'))
	-- CR < DN < FL < HD < PS
	
create type UnswGradesType as
	enum ('FL','PS','CR','DN','HD');
	-- FL < PS < CR < DN < HD

create table UnswGrades (
	id      integer,
	name    char(2),
	low     float,
	high    float,
	primary key (id)
);

insert into UnswGrades values (1,'FL', 0.0, 49.9);
insert into UnswGrades values (2,'PS', 50.0, 64.9);
insert into UnswGrades values (3,'CR', 65.0, 74.9);
insert into UnswGrades values (4,'DN', 75.0, 84.9);
insert into UnswGrades values (5,'HD', 85.0, 100.0);

