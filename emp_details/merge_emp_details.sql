use database demo_db;
use schema public;

merge into emp_details tgt
using int_emp_details_avro src
on
tgt.id=src.id
when not matched  then
insert  
(
      tgt.registration_dttm 	,
    	tgt.id 			  ,
    	tgt.first_name 		,
    	tgt.last_name 		,
    	tgt.email 			,
    	tgt.gender 			,
    	tgt.ip_address 		,
    	cc 			  ,
    	country 		,
    	birthdate 		,
    	salary 			,
    	title 			,
    	comments 		,
      data_source   
)
 values (
        src.registration_dttm,
    	src.id	,    
    	src.first_name 	,	
    	src.last_name 	,	
    	src.email 		,	
    	src.gender 		,	
    	src.ip_address 	,	
    	src.cc 			,   
    	src.country     ,		
    	src.birthdate   ,		
    	src.salary 	    ,		
    	src.title 	    ,		
    	src.comments   	,
        'AVRO' );
        
        
merge into author_details tgt
using author_details_json src
on tgt.id=src.id
when not matched then
insert
(
  tgt.author ,
  tgt.cat ,
  tgt.genre_s ,
  tgt.id ,
  tgt.inStock ,
  tgt.name ,
  tgt.pages_i ,
  tgt.price ,
  tgt.sequence_i ,
  tgt.series_t 
)
values
(
  src.author ,
  src.cat ,
  src.genre_s ,
  src.id ,
  src.inStock ,
  src.name ,
  src.pages_i ,
  src.price ,
  src.sequence_i ,
  src.series_t 
)
