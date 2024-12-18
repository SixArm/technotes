select 
	tablename,
	indexname, 
from 
	pg_indexes 
where
	schemaname = current_schema()
	and tablename = 'user'
order by
	schemaname, 
	table_name, 
	column_name;
