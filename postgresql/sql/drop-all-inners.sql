-- drop_all_inners
--
-- Drop all inner aspects of an existing database and schema:
--
--   * DROP SEQUENCE
--   * DROP TABLE
--   * DROP FUNCTION
--
-- Rather than type this in at the "psql" prompt I would suggest you copy it to a file and then pass the file as input to psql using the "--file" or "-f" options:
--
--     psql -f clean_all_pg.sql
--
-- https://stackoverflow.com/questions/3327312/how-can-i-drop-all-the-tables-in-a-postgresql-database
--
DROP FUNCTION IF EXISTS drop_all_inners();

CREATE FUNCTION drop_all_inners() RETURNS void AS $$
DECLARE
    rec RECORD;
    cmd text;
BEGIN
    cmd := '';

    FOR rec IN SELECT
            'DROP SEQUENCE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace
        WHERE
            relkind = 'S' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    FOR rec IN SELECT
            'DROP TABLE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace WHERE relkind = 'r' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    FOR rec IN SELECT
            'DROP FUNCTION ' || quote_ident(ns.nspname) || '.'
                || quote_ident(proname) || '(' || oidvectortypes(proargtypes)
                || ');' AS name
        FROM
            pg_proc
        INNER JOIN
            pg_namespace ns
        ON
            (pg_proc.pronamespace = ns.oid)
        WHERE
            ns.nspname =
            'public'
        ORDER BY
            proname
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    EXECUTE cmd;
    RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT drop_all_inners();