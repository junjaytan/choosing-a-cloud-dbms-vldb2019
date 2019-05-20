--Template 18
set query_group to 'query 18';
set enable_result_cache_for_session=false;
select
				c_name,
				c_custkey,
				o_orderkey,
				o_orderdate,
				o_totalprice,
				sum(l_quantity)
from
				evendist.customer,
				evendist.orders,
				evendist.lineitem
where
				o_orderkey in (
								select
												l_orderkey
								from
												evendist.lineitem
								group by
												l_orderkey having
																sum(l_quantity) > 312
				)
				and c_custkey = o_custkey
				and o_orderkey = l_orderkey
group by
				c_name,
				c_custkey,
				o_orderkey,
				o_orderdate,
				o_totalprice
order by
				o_totalprice desc,
				o_orderdate
LIMIT 100;
