select * from rooms 
where number > 1488;

select *  from medicines
where id BETWEEN 1488 and 1500;

select distinct diagnosis
from mentals
where diagnosis LIKE '%depression%';

select distinct name
from patients
where room_number IN (
select distinct number
from rooms
where number 
BETWEEN 1488 and 1490);

