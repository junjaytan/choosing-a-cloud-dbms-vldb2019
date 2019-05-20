--Template 4
set query_group to 'query 04';
set enable_result_cache_for_session=false;
select
	o_orderpriority,
	count(*) as order_count
from
	evendist.orders
where
	o_orderdate >= date '1993-01-01'
	and o_orderdate < date '1993-01-01' + interval '3 months'
	and exists (
		select
			*
		from
			evendist.lineitem
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;

