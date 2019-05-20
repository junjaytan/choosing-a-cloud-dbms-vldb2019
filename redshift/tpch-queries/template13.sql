--Template 13
set query_group to 'query 13';
set enable_result_cache_for_session=false;
select
	c_count,
	count(*) as custdist
from
	(
		select
			c_custkey,
			count(o_orderkey)
		from
			evendist.customer left outer join evendist.orders on
				c_custkey = o_custkey
				and o_comment not like '%special%packages%'
		group by
			c_custkey
	) as c_orders (c_custkey, c_count)
group by
	c_count
order by
	custdist desc,
	c_count desc;

