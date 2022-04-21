USE `CL2`;
show tables

select p1.name winner, p2.name loser, matchinfo.tname,
matchinfo.year, matchinfo.roundnum
from player p1, registration r1,
player p2, registration r2,
(select t.name tname,SUBSTRING_INDEX(t.StartDate, '-', -1) year, m.round roundnum,
m.registrnum1 rn1, m.registrnum2 rn2, mr.winner winner
from matches m, tournament t, retiredmatch rm, matchresults mr
where m.tid = t.tid AND rm.mid = m.mid AND t.ttype = 'Singles' AND
mr.mid = m.mid AND mr.numsets > 2) matchinfo
where p1.pid = r1.pid AND r1.registrnum = matchinfo.winner AND
p2.pid = r2.pid AND r2.registrnum != matchinfo.winner AND
(r2.registrnum = matchinfo.rn1 OR r2.registrnum = matchinfo.rn2);




-- qn 2

select distinct p.name,cc.country
from CountryCodes cc, Player p, Registration r,
Player haas, Registration haas_r, matches m
where haas.name = 'Novak Djokovic' AND haas_r.pid = haas.pid AND
(haas_r.registrnum = m.registrnum1 OR
haas_r.registrnum = m.registrnum2) AND
(r.registrnum = m.registrnum1 OR r.registrnum = m.registrnum2) AND
r.pid = p.pid AND p.pid != haas.pid AND p.ccode = cc.code AND
(cc.country = 'Great Britain' OR cc.country = 'United States' OR
cc.country = 'Australia')
