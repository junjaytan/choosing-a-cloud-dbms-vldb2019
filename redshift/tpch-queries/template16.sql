--Template 16
set query_group to 'query 16';
set enable_result_cache_for_session=false;
select
				p_brand,
				p_type,
				p_size,
				count(distinct ps_suppkey) as supplier_cnt
from
				evendist.partsupp,
				evendist.part
where
				p_partkey = ps_partkey
				and p_brand <> 'Brand#14'
				and p_type not like 'STANDARD BURNISHED%'
				and p_size in (6, 3, 39, 37, 50, 27, 19, 34)
				and ps_suppkey not in (
								select
												s_suppkey
								from
												evendist.supplier
								where
												s_comment like '%Customer%Complaints%'
				)
group by
				p_brand,
				p_type,
				p_size
order by
				supplier_cnt desc,
				p_brand,
				p_type,
				p_size;
