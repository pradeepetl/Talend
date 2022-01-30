insert into int_emp_details_avro
 select
        remove_quotes(COLUMN_DATA:registration_dttm),
    	remove_quotes(COLUMN_DATA:id)	,    
    	remove_quotes(COLUMN_DATA:first_name) 	,	
    	remove_quotes(COLUMN_DATA:last_name) 	,	
    	remove_quotes(COLUMN_DATA:email) 		,	
    	remove_quotes(COLUMN_DATA:gender) 		,	
    	remove_quotes(COLUMN_DATA:ip_address) 	,	
    	remove_quotes(COLUMN_DATA:cc )			,   
    	remove_quotes(COLUMN_DATA:country)     ,		
    	remove_quotes(COLUMN_DATA:birthdate)   ,		
    	remove_quotes(COLUMN_DATA:salary )	    ,		
    	remove_quotes(COLUMN_DATA:title )	    ,		
    	remove_quotes(COLUMN_DATA:comments   )  	
from DEMO_DB.PUBLIC.STG_EMP_DETAILS_AVRO;



 insert into int_emp_details_orc
 select
        remove_quotes(COLUMN_DATA:registration_dttm),
    	remove_quotes(COLUMN_DATA:id)	,    
    	remove_quotes(COLUMN_DATA:first_name) 	,	
    	remove_quotes(COLUMN_DATA:last_name) 	,	
    	remove_quotes(COLUMN_DATA:email) 		,	
    	remove_quotes(COLUMN_DATA:gender) 		,	
    	remove_quotes(COLUMN_DATA:ip_address) 	,	
    	remove_quotes(COLUMN_DATA:cc )			,   
    	remove_quotes(COLUMN_DATA:country)     ,		
    	remove_quotes(COLUMN_DATA:birthdate)   ,		
    	remove_quotes(COLUMN_DATA:salary )	    ,		
    	remove_quotes(COLUMN_DATA:title )	    ,		
    	remove_quotes(COLUMN_DATA:comments   )  	
from DEMO_DB.PUBLIC.STG_EMP_DETAILS_ORC;



 insert into int_emp_details_parquet
 select
        remove_quotes(COLUMN_DATA:registration_dttm),
    	remove_quotes(COLUMN_DATA:id)	,    
    	remove_quotes(COLUMN_DATA:first_name) 	,	
    	remove_quotes(COLUMN_DATA:last_name) 	,	
    	remove_quotes(COLUMN_DATA:email) 		,	
    	remove_quotes(COLUMN_DATA:gender) 		,	
    	remove_quotes(COLUMN_DATA:ip_address) 	,	
    	remove_quotes(COLUMN_DATA:cc )			,   
    	remove_quotes(COLUMN_DATA:country)     ,		
    	remove_quotes(COLUMN_DATA:birthdate)   ,		
    	remove_quotes(COLUMN_DATA:salary )	    ,		
    	remove_quotes(COLUMN_DATA:title )	    ,		
    	remove_quotes(COLUMN_DATA:comments   )  	
from DEMO_DB.PUBLIC.STG_EMP_DETAILS_PARQUET;
  

insert into author_details_json
select 

  remove_quotes(column_data:author) ,
  remove_quotes(column_data:cat) ,
  remove_quotes(column_data:genre_s) ,
  remove_quotes(column_data:id) ,
  remove_quotes(column_data:inStock) ,
  remove_quotes(column_data:name) ,
  remove_quotes(column_data:pages_i) ,
  remove_quotes(column_data:price) ,
  remove_quotes(column_data:sequence_i) ,
  remove_quotes(column_data:series_t)
from DEMO_DB.PUBLIC.STG_EMP_DETAILS_JSON;
