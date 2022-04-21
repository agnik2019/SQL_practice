select distinct p.name
from Tournament wimt, Tournament ust,
Tournament frt, Tournament aut,
Player p, Registration wimr, Registration usr,
Registration frr, Registration aur,
matches wimm, matches usm, matches frm, matches aum
where wimt.name = 'Wimbledon' AND ust.name = 'US Open' AND
frt.name = 'French Open' AND aut.name = 'Australian Open' AND
p.pid = wimr.pid AND p.pid = usr.pid AND
p.pid = frr.pid AND p.pid = aur.pid AND
(wimr.registrnum = wimm.registrnum1 OR
wimr.registrnum = wimm.registrnum2) AND
(usr.registrnum = usm.registrnum1 OR
usr.registrnum = usm.registrnum2) AND
(frr.registrnum = frm.registrnum1 OR
frr.registrnum = frm.registrnum2) AND
(aur.registrnum = aum.registrnum1 OR
aur.registrnum = aum.registrnum2) AND
wimm.tid = wimt.tid AND usm.tid = ust.tid AND
frm.tid = frt.tid AND aum.tid = aut.tid AND
wimm.round >= wimt.numrounds - 2 AND
usm.round >= ust.numrounds - 2 AND
frm.round >= frt.numrounds - 2 AND
aum.round >= aut.numrounds - 2;



-- 7
select distinct p.name
from CountryCodes cc, Player p, Registration r,
Player haas, Registration haas_r, matches m
where haas.name = 'Tommy Haas' AND haas_r.pid = haas.pid AND
(haas_r.registrnum = m.registrnum1 OR
haas_r.registrnum = m.registrnum2) AND
(r.registrnum = m.registrnum1 OR r.registrnum = m.registrnum2) AND
r.pid = p.pid AND p.pid != haas.pid AND p.ccode = cc.code AND
(cc.country = 'United States' OR cc.country = 'Chile' OR
cc.country = 'Russia');