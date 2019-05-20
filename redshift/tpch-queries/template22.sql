--Template 22
set query_group to 'query 22';
set enable_result_cache_for_session=false;
select
				cntrycode,
				count(*) as numcust,
				sum(c_acctbal) as totacctbal
from (
				select
								substring(c_phone from 1 for 2) as cntrycode,
								c_acctbal
				from
								evendist.customer
				where
								substring(c_phone from 1 for 2) in
												('13','31','23','29','30','18','17')
								and c_acctbal > (
												select
																avg(c_acctbal)
												from
																evendist.customer
												where
																c_acctbal > 0.00
																and substring (c_phone from 1 for 2) in
																				('13','31','23','29','30','18','17')
								)
								and not exists (
												select
																*
												from
																evendist.orders
												where
																o_custkey = c_custkey
								)
				) as custsale
group by
				cntrycode
order by
				cntrycode;
