insert into DEMO_DB.PUBLIC.EMPLOYEE
select 
distinct * from EMPLOYEE_v2;

insert into DEMO_DB.PUBLIC.EMPLOYEE
select 
distinct * from EMPLOYEE_v1;


insert into DEMO_DB.PUBLIC.EMPLOYEE_CITY_TIER_1
select 
distinct * from EMPLOYEE
where city='Monte-Carlo';


insert into DEMO_DB.PUBLIC.EMPLOYEE_CITY_TIER_2
select 
distinct * from EMPLOYEE
where city!='Monte-Carlo';

TRUNCATE DEMO_DB.PUBLIC.EMPLOYEE
