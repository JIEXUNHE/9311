
    create or replace view Q1(Name) as 
    select pe.Name
    from Proceeding pr, Person pe
    where pr.EditorId = pe.PersonId;
    
    create or replace view AandE(Id) as
	select r.PersonId from RelationPersonInProceeding r
	join Proceeding p on (r.PersonId =p.EditorId)
	group by r.PersonId 
	;

	create or replace view Q2(Name) as 
	SELECT p.name FROM Person p
	join AandE a on (a.Id=p.PersonId) 
	;
    create or replace view Q3(Name) as 
    select pe.name
    from Person pe, Proceeding pr, AandE a
    where pr.EditorId = a.Id and pe.PersonId = a.Id
    ;
    create or replace view Q4(Title) as 
    select Title
    from Proceeding pr, AandE a, Person pe
    where pr.EditorId = a.Id and pe.PersonId = a.Id
    ;
    create or replace view clark(Id)
    as
    select pe.personId
    from Person pe
    where pe.name like '%Clark'
    ;
    
    create or replace view Q5(Title) as 
 	 select ip.Title
 	from RelationPersonInProceeding r,InProceeding ip, clark c
 	where r.InProceedingId = ip.InProceedingId and c.Id = r.PersonId
 	;
    create or replace view Q6(Year, Total) as 
    select pr.year, count(pr.ProceedingId)
    from Proceeding pr
    group by pr.year
    ;

    create or replace view Q7r(Id,total)
    as
    select pu.PublisherId, count(pu.PublisherId)
    from Proceeding pr,Publisher pu
    where pr.PublisherId = pu.PublisherId
    group by pu.PublisherId
    ;
    
    create or replace view Q7(Name) as 
    Select name
    from puer
    where total = (select max(total) from puer)

	create or replace view Q8r1(Id,count)
    as
    Select PersonId, count(PersonId)
    from RelationPersonInProceeding
    group by PersonId
    ;
    --author and count
    create or replace view Q8r2(name,count)
    as
    Select pe.name,count(pe.name)
    From Person pe, Q8r1 q
    Where pe.PersonId = q.Id 
    group by pe.name
    ;
    --
    
    create or replace view Q8(Name) as 
    select name
    from Q8r2 
    where count = (select max(count) from Q8r2);

	create or replace view Q9r1(ipId,peid) as 
	select  InProceedingId,PersonId
	FROM RelationPersonInProceeding
	; 
	
	create or replace view Q9r2(ID, coId) as 
	SELECT r.personId, q.peid FROM RelationPersonInProceeding r
	right JOIN Q9r1 q on(r.InProceedingId=q.ipid)
	where (r.personId!=q.peid)
	;

	
	create or replace view Q9r3(authorID,count) as
	select q.Id, count(Q9r2.coid)FROM Q9r2 
	right JOIN Q8r1 q on(Q9r2.ID=q.Id)
	group by q.Id
	;

	create or replace view Q9(Name) as
	SELECT p.name FROM Person p
	JOIN Q9r3 q on (q.authorID=p.PersonId)
	where b.count=0
	;
    

    create or replace view Q10r(Name, Total) as 
    select distinct pe.name, count(pe.PersonId)
    from Person pe, RelationPersonInProceeding r, InProceeding ip
    where ip.InProceedingId = r.InProceedingId and r.PersonId = pe.PersonId
    group by pe.PersonId
    order by count(pe.PersonId) DESC
    ;
    
    create or replace view Q10(Name, Total) as 
    select * 
    from Q10r
    order by name DESC
    ;
    create or replace view Q11r1 as
	SELECT p.name, p.PersonId from person p 
	join q8r1 q on(p.PersonId=q.Id)
	where p.name like 'Richard %'
	;

	create or replace view Q11r2 as
	SELECT * from Q9r2 q9
	right JOIN Q11r1 q11 on(q9.ID=q11.personid or q9.coid=q11.personid)
	;

	create or replace view Q11r3 as
	SELECT p.name,bb.id from person p
 	join Q8r1 q8 on (q8.Id =p.PersonId)
 	left join Q11r2 q11 on (q8.Id=q11.id)
	;

	create or replace view Q11(Name) as
	SELECT name from Q11r3
	where id isNull
	;
    create or replace view Q12r1 as
	SELECT * from Q11r1 q1, Q9r2 q2
	where  q1.personid=q2.id 
	;
	create or replace view Q12r2 as
	WITH RECURSIVE result AS 
	(
    SELECT q2.id,q2.coid from q11r1 q1, q9r2 q2
        where  q1.personid=q2.id 
    UNION
    SELECT q.id,q.coid from result,q9r2 q
        where  result.coid=q.id
	)
	SELECT id from result
	group by id
	;
	create or replace view Q12(Name) as 
	SELECT p.name FROM person p
	JOIN Q12r2 q2 on(q2.id=p.PersonId)
	left JOIN Q12r1 q1 on (q1.id=q2.id)
	where q1.id isNull
	;


--13.Output the authors name, their total number of publications, the first year they published, and the last year they published. Your output should be ordered by the total number of publications in descending order and then by name in ascending order. If none of their publications have year information, the word "unknown" should be output for both first and last years of their publications.
    

--14.Suppose that all papers that are in the database research area either contain the word or substring "data" (case insensitive) in their title or in a proceeding that contains the word or substring "data". Find the number of authors that are in the database research area. (We only count the number of authors and will not include an editor that has never published a paper in the database research area).
    create or replace view Q14(Total)
    as
    select Distinct count(r.PersonId)
    from RelationPersonInProceeding r, InProceeding ip, Proceeding pr
    where r.InProceedingId = ip.InProceedingId and ip.ProceedingId = pr.ProceedingId and (ip.Title like '%data%' or pr.Title like '%data%')
    ;

    

--15.Output the following information for all proceedings: editor name, title, publisher name, year, total number of papers in the proceeding. Your output should be ordered by the total number of papers in the proceeding in descending order, then by the year in ascending order, then by the title in ascending order.
	create or replace view Q15(EditorName, Title, PublisherName, Year, Total) as
	SELECT pe.name, pr.Title,pu.name, pr.year, ip.pages 
	from person pe, Proceeding pr, Publisher pu,  InProceeding ip
	where pr.ProceedingId=ip.ProceedingId and pr.PublisherId=pu.PublisherId and pe.PersonId=pr.EditorId 
	order by ip.pages desc,pr.year asc, pr.Title asc
	;

--16.Output the author names that have never co-authored (i.e., always published a paper as a sole author) nor edited a proceeding.


--17.Output the author name, and the total number of proceedings in which the author has at least one paper published, ordered by the total number of proceedings in descending order, and then by the author name in ascending order.


--18.Count the number of publications per author and output the minimum, average and maximum count per author for the database. Do not include papers that are not published in any proceedings.

    

--19.Count the number of publications per proceeding and output the minimum, average and maximum count per proceeding for the database.


--20.Create a trigger on RelationPersonInProceeding, to check and disallow any insert or update of a paper in the RelationPersonInProceeding table from an author that is also the editor of the proceeding in which the paper has published. 

--21.Create a trigger on Proceeding to check and disallow any insert or update of a proceeding in the Proceeding table with an editor that is also the author of at least one of the papers in the proceeding. 

--22.Create a trigger on InProceeding to check and disallow any insert or update of a proceeding in the InProceeding table with an editor of the proceeding that is also the author of at least one of the papers in the proceeding.
