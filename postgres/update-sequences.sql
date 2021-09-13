-- It can be useful when you have some autoincrement fields with incorrect sequence values

-----------------------------------------------------------------------------
--------  SHOW QUERIES FOR UPDATE PK SEQUENCES FOR ALL/SOME TABLES  ---------
-----------------------------------------------------------------------------

SELECT 'SELECT SETVAL(' ||
       quote_literal(quote_ident(PGT.schemaname) || '.' || quote_ident(S.relname)) ||
       ', COALESCE(MAX(' || quote_ident(C.attname) || '), 1) ) FROM ' ||
       quote_ident(PGT.schemaname) || '.' || quote_ident(T.relname) || ';' as sql
FROM pg_class AS S,
     pg_depend AS D,
     pg_class AS T,
     pg_attribute AS C,
     pg_tables AS PGT
WHERE S.relkind = 'S'
  AND S.oid = D.objid
  AND D.refobjid = T.oid
  AND D.refobjid = C.attrelid
  AND D.refobjsubid = C.attnum
  AND T.relname = PGT.tablename
--   AND PGT.schemaname LIKE '%schema%'
--   AND S.relname like '%table%'
ORDER BY S.relname;


-----------------------------------------------------------------------------------------------
--------  SHOW ALL QUERIES FOR UPDATE PK SEQUENCES FOR ALL/SOME TABLES AS ONE STRING  ---------
-----------------------------------------------------------------------------------------------

SELECT string_agg(sqlQuery.sql, ' ')
FROM (SELECT 'SELECT SETVAL(' ||
             quote_literal(quote_ident(PGT.schemaname) || '.' || quote_ident(S.relname)) ||
             ', COALESCE(MAX(' || quote_ident(C.attname) || '), 1) ) FROM ' ||
             quote_ident(PGT.schemaname) || '.' || quote_ident(T.relname) || ';' AS sql
      FROM pg_class AS S,
           pg_depend AS D,
           pg_class AS T,
           pg_attribute AS C,
           pg_tables AS PGT
      WHERE S.relkind = 'S'
        AND S.oid = D.objid
        AND D.refobjid = T.oid
        AND D.refobjid = C.attrelid
        AND D.refobjsubid = C.attnum
        AND T.relname = PGT.tablename
        --   AND PGT.schemaname LIKE '%schema%'
        --   AND S.relname like '%table%'
      ORDER BY S.relname) as sqlQuery;
