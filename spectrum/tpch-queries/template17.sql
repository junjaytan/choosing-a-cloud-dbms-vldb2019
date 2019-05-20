--Template 17
set query_group to 'query 17';
set enable_result_cache_for_session=false;
select
				sum(l_extendedprice) / 7.0 as avg_yearly
from
				spectrum1000.lineitem,
				spectrum1000.part
where
				p_partkey = l_partkey
				and p_brand = 'Brand#41'
				and p_container = 'SM PACK'
				and l_quantity < (
								select
												0.2 * avg(l_quantity)
								from
												spectrum1000.lineitem
								where
												l_partkey = p_partkey
				);
