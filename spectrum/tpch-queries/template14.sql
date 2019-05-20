--Template 14
set query_group to 'query 14';
set enable_result_cache_for_session=false;
select
				100.00 * sum(case
								when p_type like 'PROMO%'
								then l_extendedprice*(1-l_discount)
								else 0
				end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from
				spectrum1000.lineitem,
				spectrum1000.part
where
				l_partkey = p_partkey
				and l_shipdate >= date '1993-01-01'
				and l_shipdate < date '1993-01-01' + interval '1 month';
