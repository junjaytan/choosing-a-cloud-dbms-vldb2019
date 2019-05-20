DROP SCHEMA IF EXISTS keydist;
CREATE SCHEMA keydist;

--Mimics vertica PKs and data partitioning
CREATE TABLE keydist.region (
r_regionkey INTEGER NOT NULL sortkey,
r_name char(25),
r_comment varchar(152),
primary key(r_regionkey)) 
diststyle ALL;


CREATE TABLE keydist.nation (
n_nationkey int NOT NULL sortkey,
n_name char(25),
n_regionkey int NOT NULL,
n_comment varchar(152),
primary key(n_nationkey))
diststyle ALL;


CREATE TABLE keydist.supplier
(
s_suppkey int NOT NULL sortkey,
s_name char(25),
s_address varchar(40),
s_nationkey int NOT NULL,
s_phone char(15),
s_acctbal float,
s_comment varchar(101),
primary key(s_suppkey))
diststyle key distkey (s_suppkey);


CREATE TABLE keydist.part (
p_partkey int NOT NULL sortkey,
p_name varchar(55),
p_mfgr char(25),
p_brand char(10),
p_type varchar(25),
p_size int,
p_container char(10),
p_retailprice float,
p_comment varchar(23),
primary key(p_partkey)
) diststyle key distkey (p_partkey);


CREATE TABLE keydist.partsupp (
ps_partkey int NOT NULL sortkey,
ps_suppkey int NOT NULL,
ps_availqty int,
ps_supplycost float,
ps_comment varchar(199),
primary key(ps_partkey, ps_suppkey)) 
diststyle key distkey (ps_partkey);


CREATE TABLE keydist.customer (
c_custkey int NOT NULL sortkey,
c_name varchar(25),
c_address varchar(40),
c_nationkey int NOT NULL,
c_phone char(15),
c_acctbal float,
c_mktsegment char(10),
c_comment varchar(117),
primary key(c_custkey)) 
diststyle key distkey (c_custkey);


CREATE TABLE keydist.orders (
o_orderkey BIGINT NOT NULL sortkey,
o_custkey int NOT NULL,
o_orderstatus char(1),
o_totalprice float,
o_orderdate date,
o_orderpriority char(15),
o_clerk char(15),
o_shippriority int,
o_comment varchar(79),
primary key(o_orderkey)) 
diststyle key distkey (o_orderkey);


CREATE TABLE keydist.lineitem
(
l_orderkey BIGINT NOT NULL,
l_partkey int NOT NULL,
l_suppkey int NOT NULL,
l_linenumber BIGINT NOT NULL,
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
l_comment varchar(44),
primary key(l_orderkey, l_linenumber)) 
diststyle key distkey (l_orderkey);
