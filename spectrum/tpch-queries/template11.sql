--Template 11
set query_group to 'query 11';
set enable_result_cache_for_session=false;
select
				ps_partkey,
				sum(ps_supplycost * ps_availqty) as value
from
				spectrum1000.partsupp,
				spectrum1000.supplier,
				spectrum1000.nation
where
				ps_suppkey = s_suppkey
				and s_nationkey = n_nationkey
				and n_name = 'JAPAN'
group by
				ps_partkey having
								sum(ps_supplycost * ps_availqty) > (
												select
																sum(ps_supplycost * ps_availqty) * 0.0000001 --0.0001
												from
																spectrum1000.partsupp,
																spectrum1000.supplier,
																spectrum1000.nation
												where
																ps_suppkey = s_suppkey
																and s_nationkey = n_nationkey
																and n_name = 'JAPAN'
								)
order by
				value desc;
