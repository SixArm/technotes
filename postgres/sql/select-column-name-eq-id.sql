select 
	table_name, 
	column_name, 
	data_type 
from 
	information_schema.columns 
where 
	table_catalog = current_database() 
	and 
	table_schema = current_schema() 
	and 
	column_name = 'id' 
order by 
	table_catalog, 
	table_schema, 
	table_name, 
	column_name;
