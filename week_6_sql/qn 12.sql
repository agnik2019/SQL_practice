USE `CL2`;
-- show tables
SELECT * FROM player;

SELECT `Name`,`TType`,`Surface`,`NumRounds` FROM `tournament` ORDER BY(`NumRounds`) ASC;

SELECT p.Name from player p INNER JOIN countrycodes c where c.code = p.ccode and country = 'Australia';

SELECT player.Name FROM player  INNER JOIN countrycodes ON player.CCode=countrycodes.Code WHERE countrycodes.Country = "Australia";

SELECT `EndDate` FROM Tournament;

SELECT STR_TO_DATE(REPLACE(EndDate, '-', ' '),'%d %M %Y') FROM Tournament;

SELECT NAME,Location,StartDate,EndDate,DATEDIFF(STR_TO_DATE(REPLACE(EndDate, '-', ' '),'%d %M %Y'), STR_TO_DATE(REPLACE(StartDate, '-', ' '),'%d %M %Y')) AS Duration,NumROunds
 FROM tournament
 WHERE Surface = "Hard" AND NumROunds > 5;
 
 
 select p.Name from player p, registration r, playedin pn, tournament t where p.PID=r.PID and 
r.RegistrNum=pn.RegistrNum and pn.TID=t.TID ; 


select r.pid,p.name, count(*) as c from registration r, player p, tournament t, playedin pn
where r.pid = p.pid and  r.RegistrNum=pn.RegistrNum and pn.TID=t.TID and SUBSTRING_INDEX(t.StartDate, '-', -1) =  SUBSTRING_INDEX(t.endDate, '-', -1)
group by r.pid;

select r.pid,p.name, count(*) as c from registration r, player p, tournament t, playedin pn
where r.pid = p.pid and  r.RegistrNum=pn.RegistrNum and pn.TID=t.TID and SUBSTRING_INDEX(t.StartDate, '-', -1) =  SUBSTRING_INDEX(t.endDate, '-', -1)
group by r.pid
order by c DESC LIMIT 1;

-- alternative correct solution
select p.name, count(r.registrnum) registered_tournaments
from Player p, Registration r
where p.pid not in
(select count1.pid
from
(select p.pid pid, count(r.registrnum) numreg
from Registration r, player p
where r.pid = p.pid
group by p.pid) count1,
(select p.pid, count(r.registrnum) numreg
from Registration r, player p
where r.pid = p.pid
group by p.pid) count2
where count1.numreg < count2.numreg)
AND p.pid = r.pid
group by p.name;



select mr.MID, p.Name as MatchWinner from matchresults mr, registration r, player p, matches m, tournament t
where r.RegistrNum = mr.Winner and p.PID = r.PID and m.MID = mr.MID and 
t.TID = m.TID and t.Name = "US Open"  
AND SUBSTRING_INDEX(t.StartDate, '-', -1) = 2007
GROUP BY mr.MID;


-- 7
select p.name,t.TType,t.Name,c.Country from player p,countrycodes c, registration r, playedin pn, tournament t
where p.PID = r.PID and p.CCode= c.code and p.Gender='M' 
and r.Registrnum = pn.Registrnum
and pn.TID = t.TID and t.Name='French Open'
AND SUBSTRING_INDEX(t.StartDate, '-', -1) = 2007
and t.TType = 'Doubles'
and c.Country='Australia';

-- 6
select distinct p.name from player p, registration r, playedin pn
where p.PID = r.PID and r.Registrnum = pn.Registrnum
and pn.Seed is not NULL;


-- List the pairs of players who played doubles tennis at Wimbledon in 2007. Do not include
-- duplicate entries (ex: hpersonA, personBi as well as hpersonB, personAi)
select p1.name, p2.name
from player p1, player p2, registration r1, registration r2, playedin pi
where p1.pid = r1.pid AND p2.pid = r2.pid AND r1.registrnum = r2.registrnum AND
r1.registrnum = pi.registrnum AND r1.pid != r2.pid AND p1.pid < p2.pid AND
pi.tid in (select tid
from tournament t
where SUBSTRING_INDEX(t.StartDate, '-', -1) = 2007 AND
t.ttype = 'Doubles' AND t.name = 'Wimbledon');


-- List the names of all players who have lost to Roger Federer in the finals of any tournament,
-- as well as the name of the tournament they lost in. Include results only for singles tennis
select p.name, t.name
from registration rroger, registration r, matches m, matchresults mr,
(select p.pid pid
from Player p
where name='Roger Federer') roger, tournament t, player p
where rroger.pid = roger.pid AND m.mid = mr.mid AND
mr.winner = rroger.registrnum AND
( (rroger.registrnum = m.registrnum1 AND r.registrnum = m.registrnum2) OR
(rroger.registrnum = m.registrnum2 AND r.registrnum = m.registrnum1) ) AND
t.tid = m.tid AND t.numrounds = m.round AND t.ttype = 'Singles' AND
p.pid = r.pid;



select winner.playername winnername, winner.seed winnerseed,
loser.playername losername, loser.seed loserseed
from matches m, tournament t, matchresults mr,
(select r.registrnum, pi.seed seed, p.name playerName
from player p, registration r, playedin pi
where p.pid = r.pid AND r.registrnum = pi.registrnum AND
pi.seed is not null) winner,
(select r.registrnum, pi.seed seed, p.name playerName
from player p, registration r, playedin pi
where p.pid = r.pid AND r.registrnum = pi.registrnum AND
pi.seed is not null) loser
where m.tid = t.tid AND t.ttype = 'Singles' AND m.round = t.numrounds AND
m.mid = mr.mid AND
(m.registrnum1 = winner.registrnum OR m.registrnum2 = winner.registrnum) AND
(m.registrnum1 = loser.registrnum OR m.registrnum2 = loser.registrnum) AND
winner.registrnum != loser.registrnum AND mr.winner = winner.registrnum;



select t.name, t.ttype, t.EndDate - t.StartDate length
from tournament t
where (t.EndDate - t.StartDate > 7)