--Template 15
set query_group to 'query 15';
set enable_result_cache_for_session=false;
drop view if exists revenue0;
create view revenue0 (supplier_no, total_revenue) as select l_suppkey, sum(l_extendedprice * (1 - l_discount)) from spectrum1000.lineitem where l_shipdate >= date '1994-02-01' and l_shipdate < date '1994-02-01' + interval '3 month' group by l_suppkey;
/*
create view revenue0 (supplier_no, total_revenue) as
				select
				l_suppkey,
				sum(l_extendedprice * (1 - l_discount))
				from
								spectrum1000.lineitem
				where
								l_shipdate >= date '1994-02-01'
								and l_shipdate < date '1994-02-01' + interval '3 month'
				group by
				l_suppkey;
*/
select
				s_suppkey,
				s_name,
				s_address,
				s_phone,
				total_revenue
from
				spectrum1000.supplier,
				revenue0
where
				s_suppkey = supplier_no
				and total_revenue = (
								select
												max(total_revenue)
								from
												revenue0
				)
order by
				s_suppkey;

drop view if exists revenue0;
