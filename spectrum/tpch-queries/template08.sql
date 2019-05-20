--Template 8
set query_group to 'query 08';
set enable_result_cache_for_session=false;
select
	o_year,
	sum(case
					when nation = 'EGYPT'
					then volume
					else 0
	end) / sum(volume) as mkt_share
from (
				select
								extract(year from o_orderdate) as o_year,
								l_extendedprice * (1-l_discount) as volume,
								n2.n_name as nation
				from
								spectrum1000.part,
								spectrum1000.supplier,
								spectrum1000.lineitem,
								spectrum1000.orders,
								spectrum1000.customer,
								spectrum1000.nation n1,
								spectrum1000.nation n2,
								spectrum1000.region
				where
								p_partkey = l_partkey
								and s_suppkey = l_suppkey
								and l_orderkey = o_orderkey
								and o_custkey = c_custkey
								and c_nationkey = n1.n_nationkey
								and n1.n_regionkey = r_regionkey
								and r_name = 'MIDDLE EAST'
								and s_nationkey = n2.n_nationkey
								and o_orderdate between date '1995-01-01' and date '1996-12-31'
								and p_type = 'MEDIUM BURNISHED NICKEL'
				) as all_nations
group by
				o_year
order by
				o_year;
