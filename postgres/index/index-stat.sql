-- src: https://dmitry-naumenko.medium.com/%D0%BE%D0%BF%D1%80%D0%B5%D0%B4%D0%B5%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BD%D0%B5%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D1%83%D0%B5%D0%BC%D1%8B%D1%85-%D0%B8%D0%BD%D0%B4%D0%B5%D0%BA%D1%81%D0%BE%D0%B2-%D0%B2-postgresql-860907d8f0f

-- INDEX STATISTICS
SELECT idstat.relname                                 AS TABLE_NAME,              -- имя таблицы
       indexrelname                                   AS index_name,              -- индекс
       idstat.idx_scan                                AS index_scans_count,       -- число сканирований по этому индексу
       pg_size_pretty(pg_relation_size(indexrelid))   AS index_size,              -- размер индекса
       tabstat.idx_scan                               AS table_reads_index_count, -- индексных чтений по таблице
       tabstat.seq_scan                               AS table_reads_seq_count,   -- последовательных чтений по таблице
       tabstat.seq_scan + tabstat.idx_scan            AS table_reads_count,       -- чтений по таблице
       n_tup_upd + n_tup_ins + n_tup_del              AS table_writes_count,      -- операций записи
       pg_size_pretty(pg_relation_size(idstat.relid)) AS table_size               -- размер таблицы
FROM pg_stat_user_indexes AS idstat
         JOIN
     pg_indexes
     ON
                 indexrelname = indexname
             AND
                 idstat.schemaname = pg_indexes.schemaname
         JOIN
     pg_stat_user_tables AS tabstat
     ON
         idstat.relid = tabstat.relid
WHERE indexdef !~* 'unique'
ORDER BY idstat.idx_scan DESC,
         pg_relation_size(indexrelid) DESC