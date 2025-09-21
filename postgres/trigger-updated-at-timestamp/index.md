# Trigger updated_at timestamp

By Claude.

How to create a Postgres trigger to automatically set the timestamp column `updated_at` using time zone UTC.

Generic function that works with any table:

```sql
-- Generic function that works with any table
CREATE OR REPLACE FUNCTION trigger_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = (NOW() AT TIME ZONE 'UTC');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

Apply to a table:

```sql
CREATE TRIGGER set_timestamp_users
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION trigger_updated_at();
```

Show existing triggers:

```sql
SELECT 
    trigger_name,
    table_name,
    action_timing,
    event_manipulation
FROM information_schema.triggers 
WHERE trigger_schema = 'public'
ORDER BY table_name, trigger_name;
```

Verify the trigger works:

```sql
UPDATE users SET name = 'Updated Name' WHERE id = 1;
SELECT updated_at FROM users WHERE id = 1;
```
