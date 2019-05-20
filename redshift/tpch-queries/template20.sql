--Template 20
set query_group to 'query 20';
set enable_result_cache_for_session=false;
select
				s_name,
				s_address
from
				evendist.supplier, evendist.nation
where
				s_suppkey in (
								select
												ps_suppkey
								from
												evendist.partsupp
								where
												ps_partkey in (
																select
																				p_partkey
																from
																				evendist.part
																where
																				p_name like 'aquamarine%'
												)
								and ps_availqty > (
												select
																0.5 * sum(l_quantity)
												from
																evendist.lineitem
												where
																l_partkey = ps_partkey
																and l_suppkey = ps_suppkey
																and l_shipdate >= date('1996-01-01')
																and l_shipdate < date('1996-01-01') + interval '1 year'
								)
				)
				and s_nationkey = n_nationkey
				and n_name = 'PERU'
order by
s_name;
