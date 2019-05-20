CREATE EXTERNAL TABLE region
(
r_regionkey bigint,
r_name char(25),
r_comment varchar(152)
)STORED AS ORC
LOCATION 's3a://PATH-TO_DATA/region';

CREATE EXTERNAL TABLE nation
(
n_nationkey bigint,
n_name char(25),
n_regionkey bigint,
n_comment varchar(152)
)STORED AS ORC
LOCATION 's3a://PATH-TO_DATA/nation';

CREATE EXTERNAL TABLE supplier
(
s_suppkey bigint,
s_name char(25),
s_address varchar(40),
s_nationkey bigint,
s_phone char(15),
s_acctbal float,
s_comment varchar(101)
) STORED AS ORC
LOCATION 's3a://PATH-TO_DATA/supplier';

CREATE EXTERNAL TABLE part
(
p_partkey bigint,
p_name varchar(55),
p_mfgr char(25),
p_brand char(10),
p_type varchar(25),
p_size bigint,
p_container char(10),
p_retailprice float,
p_comment varchar(23)
)STORED AS ORC
LOCATION 's3a://PATH-TO_DATA/part';

CREATE EXTERNAL TABLE partsupp
(
ps_partkey bigint,
ps_suppkey bigint,
ps_availqty bigint,
ps_supplycost float,
ps_comment varchar(199)
)STORED AS ORC
LOCATION 's3a://PATH-TO_DATA/partsupp';

CREATE EXTERNAL TABLE customer
(
c_custkey bigint,
c_name varchar(25),
c_address varchar(40),
c_nationkey bigint,
c_phone char(15),
c_acctbal float,
c_mktsegment char(10),
c_comment varchar(117)
) STORED AS ORC
LOCATION 's3a://PATH-TO_DATA/customer';

CREATE EXTERNAL TABLE orders
(
o_orderkey bigint,
o_custkey bigint,
o_orderstatus char(1),
o_totalprice float,
o_orderdate date,
o_orderpriority char(15),
o_clerk char(15),
o_shippriority bigint,
o_comment varchar(79)
)STORED AS ORC
LOCATION 's3a://PATH-TO_DATA/orders';

CREATE EXTERNAL TABLE lineitem
(
l_orderkey bigint,
l_partkey bigint,
l_suppkey bigint,
l_linenumber bigint,
l_quantity float,
l_extendedprice float,
l_discount float,
l_tax float,
l_returnflag char(1),
l_linestatus char(1),
l_shipdate date,
l_commitdate date,
l_receiptdate date,
l_shipinstruct char(25),
l_shipmode char(10),
l_comment varchar(44)
) STORED AS ORC
LOCATION 's3a://PATH-TO_DATA/lineitem';

analyze table region compute statistics for columns;
analyze table nation compute statistics for columns;
analyze table supplier compute statistics for columns;
analyze table part compute statistics for columns;
analyze table partsupp compute statistics for columns;
analyze table customer compute statistics for columns;
analyze table orders compute statistics for columns;
analyze table lineitem compute statistics for columns;
