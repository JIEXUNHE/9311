
create table Department (
	name        text,  -- implicit not null because in primary key
	phone       text,
	location    text,
	manager     text not null,  -- enforces total participation
	manager     text unique not null,  
	                 -- unique enforces manager can manage only one branch
	                 -- not null enforces total participation
	mdate       date,
	primary key (name)
--	foreign key (manager) references Employee(ssn)
);

create table Employee (
	ssn         text,  -- implicit not null because in primary key
	name        text,
	birthdate   date,
	worksIn     text not null,  -- enforces total participation
	primary key (ssn),
	foreign key (worksIn) references Department(name)
);

alter table Department add constraint FK_constraint
	foreign key (manager) REFERENCES EMPLOYEE(ssn);


create table Dependent (
	employee    text,  -- implicit not null because in primary key
	name        text,  -- implicit not null because in primary key
	relation    text,  -- e.g. spouse, child, ...
	birthdate   date,
	primary key (employee,name),
	foreign key (employee) references Employee(ssn)
);

create table Project (
	pname       text,     -- implicit not null, primary key
	pnumber     integer,  -- implicit not null, primary key
	primary key (pname,pnumber),
);

create table Participation (
	employee    text,
	pnam        text,
	pnum        integer,
	time        integer,  -- hours spent on project
	primary key (employee,pname,pnumber),
	foreign key (employee) references Employee(ssn)
	foreign key (pnam,pnum) references Project(pname,pnumber)
);
