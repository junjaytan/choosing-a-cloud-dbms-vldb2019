--Template 6
set query_group to 'query 06';
set enable_result_cache_for_session=false;
--Modified query to account for ORC floating point conversion issues
select
sum(l_extendedprice*l_discount) as revenue
from
keydist.lineitem
where
l_shipdate >= date '1995-01-01'
and l_shipdate < date '1995-01-01' + interval '1 year'
and l_discount between 0.06 - 0.01001 and 0.06 + 0.01001
and l_quantity < 24;

/*
-- Original unmodified query
select
sum(l_extendedprice*l_discount) as revenue
from
evendist.lineitem
where
l_shipdate >= date '1995-01-01'
and l_shipdate < date '1995-01-01' + interval '1 year'
and l_discount between 0.06 - 0.01 and 0.06 + 0.01
and l_quantity < 24;
*/
