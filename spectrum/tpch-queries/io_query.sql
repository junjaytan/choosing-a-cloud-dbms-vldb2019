--IO Query
set query_group to 'io query';
set enable_result_cache_for_session=false;
SELECT sum(1.0 * l_orderkey * l_partkey * l_suppkey * l_linenumber * l_quantity * l_extendedprice * l_discount * l_tax) FROM spectrum1000.lineitem;
