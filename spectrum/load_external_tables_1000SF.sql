/**
 * Script to load external ORC tables

To drop all tables:
DROP TABLE spectrum1000.region;
DROP TABLE spectrum1000.nation;
DROP TABLE spectrum1000.supplier;
DROP TABLE spectrum1000.part;
DROP TABLE spectrum1000.partsupp;
DROP TABLE spectrum1000.customer;
DROP TABLE spectrum1000.orders;
DROP TABLE spectrum1000.lineitem;
 */

create external schema spectrum1000 
from data catalog 
database 'spectrum1000db'
iam_role 'YOUR_IAM_ROLE'
create external database if not exists;

-- 5 rows
CREATE EXTERNAL TABLE spectrum1000.region (
r_regionkey BIGINT,
r_name char(25),
r_comment varchar(152))
stored as orc
location 's3://PATH-TO-DATA/region/';

-- 25 rows
CREATE EXTERNAL TABLE spectrum1000.nation (
n_nationkey BIGINT,
n_name char(25),
n_regionkey BIGINT,
n_comment varchar(152)
)
stored as ORC
location 's3://PATH-TO-DATA/nation/';


-- 10000000 rows
CREATE EXTERNAL TABLE spectrum1000.supplier
(
s_suppkey BIGINT,
s_name char(25),
s_address varchar(40),
s_nationkey BIGINT,
s_phone char(15),
s_acctbal float,
s_comment varchar(101)
)
stored as ORC
location 's3://PATH-TO-DATA/supplier/';


-- 200000000 rows
CREATE EXTERNAL TABLE spectrum1000.part (
p_partkey BIGINT,
p_name varchar(55),
p_mfgr char(25),
p_brand char(10),
p_type varchar(25),
p_size BIGINT,
p_container char(10),
p_retailprice float,
p_comment varchar(23)
)
stored as ORC
location 's3://PATH-TO-DATA/part/';


-- 800000000 rows
CREATE EXTERNAL TABLE spectrum1000.partsupp (
ps_partkey BIGINT,
ps_suppkey BIGINT,
ps_availqty BIGINT,
ps_supplycost float,
ps_comment varchar(199)
)
stored as ORC
location 's3://PATH-TO-DATA/partsupp/';


-- 150000000 rows
CREATE EXTERNAL TABLE spectrum1000.customer (
c_custkey BIGINT,
c_name varchar(25),
c_address varchar(40),
c_nationkey BIGINT,
c_phone char(15),
c_acctbal float,
c_mktsegment char(10),
c_comment varchar(117)
)
stored as ORC
location 's3://PATH-TO-DATA/customer/';


-- Note that orderdate is timestamp instead of date
-- Otherwise it refuses to load the external table with error:
-- Redshift type "date" only supported as partition column for external table creation
-- 1500000000 rows
CREATE EXTERNAL TABLE spectrum1000.orders (
o_orderkey BIGINT,
o_custkey BIGINT,
o_orderstatus char(1),
o_totalprice float,
o_orderdate timestamp,
o_orderpriority char(15),
o_clerk char(15),
o_shippriority BIGINT,
o_comment varchar(79)
)
stored as ORC
location 's3://PATH-TO-DATA/orders/';


-- Note that the date fields are set to datatype timestamp instead of date
-- 5999989709 rows
CREATE EXTERNAL TABLE spectrum1000.lineitem
(
l_orderkey BIGINT,
l_partkey BIGINT,
l_suppkey BIGINT,
l_linenumber BIGINT,
l_quantity float,
l_extendedprice float,
l_discount float,
l_tax float,
l_returnflag char(1),
l_linestatus char(1),
l_shipdate timestamp,
l_commitdate timestamp,
l_receiptdate timestamp,
l_shipinstruct char(25),
l_shipmode char(10),
l_comment varchar(44)
)
stored as ORC
location 's3://PATH-TO-DATA/lineitem/';
