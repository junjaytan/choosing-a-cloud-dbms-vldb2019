--Template 2
set query_group to 'query 02';
set enable_result_cache_for_session=false;
select
	s_acctbal,
	s_name,
	n_name,
	p_partkey,
	p_mfgr,
	s_address,
	s_phone,
	s_comment
from
	spectrum1000.part,
	spectrum1000.supplier,
	spectrum1000.partsupp,
	spectrum1000.nation,
	spectrum1000.region
where
	p_partkey = ps_partkey
	and s_suppkey = ps_suppkey
	and p_size = 47
	and p_type like '%NICKEL'
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'AFRICA'
	and ps_supplycost = (
		select
			min(ps_supplycost)
		from
			spectrum1000.partsupp,
			spectrum1000.supplier,
			spectrum1000.nation,
			spectrum1000.region
		where
			p_partkey = ps_partkey
			and s_suppkey = ps_suppkey
			and s_nationkey = n_nationkey
			and n_regionkey = r_regionkey
			and r_name = 'AFRICA'
	)
order by
	s_acctbal desc,
	n_name,
	s_name,
	p_partkey
LIMIT 100;
