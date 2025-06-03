// Solutions to the SQL Murder Mystery challenge by Knight Lab https://mystery.knightlab.com/ 

// The crime was a murder 
// Occurred sometime on Jan.15, 2018
// Took place in SQL City

// Let's first find some more details about the murder in the crime_scene_report table 

select * 
from crime_scene_report
where type = 'murder' and city = 'SQL City' and date = '20180115' 

// Security footage shows that there were 2 witnesses. 
// The first witness lives at the last house on "Northwestern Dr". 
// The second witness, named Annabel, lives somewhere on "Franklin Ave".

// Let's find the two witnesses using the person table

select * 
from person
where address_street_name = 'Northwestern Dr'
order by address_number desc

// First witness = Morty Schapiro
// id = 14887

select * 
from person
where address_street_name = 'Franklin Ave' and name like '%Annabel%'

// Second witness = Annabel Miller
// id = 16371

// Examine the interview table

select * 
from interview
where person_id = 14887 or person_id = 16371

// transcript: "I heard a gunshot and then saw a man run out.
// He had a "Get Fit Now Gym" bag.
// The membership number on the bag started with "48Z". 
// Only gold members have those bags. 
// The man got into a car with a plate that included "H42W"."

// "I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th."

with CTE_get_fit_now as (  
  select * 
  from get_fit_now_member
  inner join get_fit_now_check_in
  on id = membership_id
  where id like '48Z%' and membership_status = 'gold' and check_in_date = 20180109
 ),
 	CTE_drivers_license as (
	  select *
	  from person 
	  inner join drivers_license as d
	  on license_id = d.id
	  where plate_number like '%H42W%'
)
 select *
 from CTE_get_fit_now as c
 inner join CTE_drivers_license as dl
 on c.person_id = dl.id

 // And the murderer is Jeremy Bowers.

 // Extra challenge - querying the interview transcript of the murderer to find the real villain behind this crime

select
	transcript ,
	name
from interview
inner join person
	on person_id = id
where name = 'Jeremy Bowers'

// I was hired by a woman with a lot of money. 
// I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
// She has red hair and she drives a Tesla Model S. 
// I know that she attended the SQL Symphony Concert 3 times in December 2017.

with CTE as (
	select
  		* ,
  		count (person_id) as visits
  	from facebook_event_checkin
  	where cast (date as text) like '201712%'
  	and event_name like '%SQL Symphony Concert%'
  	group by person_id
  	having count (person_id) >= 3
)
select 
    name
from drivers_license as dl
inner join person as p
	on dl.id = p.license_id
inner join CTE as c
	on c.person_id = p.id
where hair_color = 'red'
and height >= 65
and height <= 67
and car_make = 'Tesla'
and car_model = 'Model S'

// And finally, the brains behind the murder is Miranda Priestly!
