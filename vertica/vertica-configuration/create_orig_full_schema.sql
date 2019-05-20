/* Create the original full schema for tpc-h data provided by the Vertica team 
 can run as root via: /opt/vertica/bin/vsql -U dbadmin -w dbadmin -f create_orig_full_schema.sql
 */



-- schema
       CREATE TABLE public.region
    (
        r_regionkey int NOT NULL,
        r_name char(25),
        r_comment varchar(152)
    );
 
    ALTER TABLE public.region ADD CONSTRAINT region_pkey PRIMARY KEY (r_regionkey);
 
    CREATE TABLE public.nation
    (
        n_nationkey int NOT NULL,
        n_name char(25),
        n_regionkey int NOT NULL,
        n_comment varchar(152)
    );
 
    ALTER TABLE public.nation ADD CONSTRAINT nation_pkey PRIMARY KEY (n_nationkey);
 
    CREATE TABLE public.supplier
    (
        s_suppkey int NOT NULL,
        s_name char(25),
        s_address varchar(40),
        s_nationkey int NOT NULL,
        s_phone char(15),
        s_acctbal float,
        s_comment varchar(101)
    );
 
    ALTER TABLE public.supplier ADD CONSTRAINT supplier_pkey PRIMARY KEY (s_suppkey);
 
    CREATE TABLE public.part
    (
        p_partkey int NOT NULL,
        p_name varchar(55),
        p_mfgr char(25),
        p_brand char(10),
        p_type varchar(25),
        p_size int,
        p_container char(10),
        p_retailprice float,
        p_comment varchar(23)
    );
 
    ALTER TABLE public.part ADD CONSTRAINT part_pkey PRIMARY KEY (p_partkey);
 
    CREATE TABLE public.partsupp
    (
        ps_partkey int NOT NULL,
        ps_suppkey int NOT NULL,
        ps_availqty int,
        ps_supplycost float,
        ps_comment varchar(199)
    );
 
    ALTER TABLE public.partsupp ADD CONSTRAINT partsupp_pkey PRIMARY KEY (ps_partkey, ps_suppkey);
 
    CREATE TABLE public.customer
    (
        c_custkey int NOT NULL,
        c_name varchar(25),
        c_address varchar(40),
        c_nationkey int NOT NULL,
        c_phone char(15),
        c_acctbal float,
        c_mktsegment char(10),
        c_comment varchar(117)
    );
 
    ALTER TABLE public.customer ADD CONSTRAINT customer_pkey PRIMARY KEY (c_custkey);
 
    CREATE TABLE public.orders
    (
        o_orderkey int NOT NULL,
        o_custkey int NOT NULL,
        o_orderstatus char(1),
        o_totalprice float,
        o_orderdate date,
        o_orderpriority char(15),
        o_clerk char(15),
        o_shippriority int,
        o_comment varchar(79)
    );
 
    ALTER TABLE public.orders ADD CONSTRAINT orders_pkey PRIMARY KEY (o_orderkey);
 
    CREATE TABLE public.lineitem
    (
        l_orderkey int NOT NULL,
        l_partkey int NOT NULL,
        l_suppkey int NOT NULL,
        l_linenumber int NOT NULL,
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
    );
 
    ALTER TABLE public.lineitem ADD CONSTRAINT lineitem_pkey PRIMARY KEY (l_orderkey, l_linenumber);
    ALTER TABLE public.nation ADD CONSTRAINT nation_fkey_region FOREIGN KEY (n_regionkey) references public.region (r_regionkey);
    ALTER TABLE public.supplier ADD CONSTRAINT supplier_fkey_nation FOREIGN KEY (s_nationkey) references public.nation (n_nationkey);
    ALTER TABLE public.partsupp ADD CONSTRAINT partsupp_fkey_part FOREIGN KEY (ps_partkey) references public.part (p_partkey);
    ALTER TABLE public.partsupp ADD CONSTRAINT partsupp_fkey_supplier FOREIGN KEY (ps_suppkey) references public.supplier (s_suppkey);
    ALTER TABLE public.customer ADD CONSTRAINT customer_fkey_nation FOREIGN KEY (c_nationkey) references public.nation (n_nationkey);
    ALTER TABLE public.orders ADD CONSTRAINT orders_fkey_customer FOREIGN KEY (o_custkey) references public.customer (c_custkey);
    ALTER TABLE public.lineitem ADD CONSTRAINT lineitem_fkey_orders FOREIGN KEY (l_orderkey) references public.orders (o_orderkey);
    ALTER TABLE public.lineitem ADD CONSTRAINT lineitem_fkey_part FOREIGN KEY (l_partkey) references public.part (p_partkey);
    ALTER TABLE public.lineitem ADD CONSTRAINT lineitem_fkey_supplier FOREIGN KEY (l_suppkey) references public.supplier (s_suppkey);
    ALTER TABLE public.lineitem ADD CONSTRAINT lineitem_fkey_partsupp FOREIGN KEY (l_partkey, l_suppkey) references public.partsupp (ps_partkey, ps_suppkey);
 
-- design
 
    SELECT MARK_DESIGN_KSAFE(0); -- This should be done before creating any projections
 
    CREATE PROJECTION public.part_p
    (
     p_type ENCODING RLE,
     p_mfgr ENCODING RLE,
     p_brand ENCODING RLE,
     p_partkey,
     p_name,
     p_size,
     p_container,
     p_retailprice,
     p_comment
    )
    AS
     SELECT part.p_type,
            part.p_mfgr,
            part.p_brand,
            part.p_partkey,
            part.p_name,
            part.p_size,
            part.p_container,
            part.p_retailprice,
            part.p_comment
     FROM public.part
     ORDER BY part.p_type,
              part.p_mfgr,
              part.p_brand
    SEGMENTED BY hash(part.p_partkey) ALL NODES;
 
    CREATE PROJECTION public.partsupp_p
    (
     ps_availqty ENCODING RLE,
     ps_partkey,
     ps_suppkey,
     ps_supplycost,
     ps_comment
    )
    AS
     SELECT partsupp.ps_availqty,
            partsupp.ps_partkey,
            partsupp.ps_suppkey,
            partsupp.ps_supplycost,
            partsupp.ps_comment
     FROM public.partsupp
     ORDER BY partsupp.ps_availqty
    SEGMENTED BY hash(partsupp.ps_partkey) ALL NODES;
 
    CREATE PROJECTION public.customer_p
    (
     c_mktsegment ENCODING RLE,
     c_nationkey ENCODING RLE,
     c_custkey,
     c_name,
     c_address,
     c_phone,
     c_acctbal,
     c_comment
    )
    AS
     SELECT customer.c_mktsegment,
            customer.c_nationkey,
            customer.c_custkey,
            customer.c_name,
            customer.c_address,
            customer.c_phone,
            customer.c_acctbal,
            customer.c_comment
     FROM public.customer
     ORDER BY customer.c_mktsegment,
              customer.c_nationkey
    SEGMENTED BY hash(customer.c_custkey) ALL NODES;
 
    CREATE PROJECTION public.orders_p
    (
     o_orderdate ENCODING RLE,
     o_shippriority ENCODING RLE,
     o_orderstatus ENCODING RLE,
     o_orderpriority ENCODING RLE,
     o_orderkey,
     o_custkey,
     o_totalprice,
     o_clerk,
     o_comment
    )
    AS
     SELECT orders.o_orderdate,
            orders.o_shippriority,
            orders.o_orderstatus,
            orders.o_orderpriority,
            orders.o_orderkey,
            orders.o_custkey,
            orders.o_totalprice,
            orders.o_clerk,
            orders.o_comment
     FROM public.orders
     ORDER BY orders.o_orderdate,
              orders.o_shippriority,
              orders.o_orderstatus,
              orders.o_orderpriority
    SEGMENTED BY hash(orders.o_orderkey) ALL NODES;
 
    CREATE PROJECTION public.lineitem_p
    (
     l_returnflag ENCODING RLE,
     l_discount ENCODING RLE,
     l_quantity ENCODING RLE,
     l_linestatus ENCODING RLE,
     l_shipinstruct ENCODING RLE,
     l_shipmode ENCODING RLE,
     l_linenumber ENCODING RLE,
     l_orderkey,
     l_partkey,
     l_suppkey,
     l_extendedprice,
     l_tax,
     l_shipdate,
     l_commitdate,
     l_receiptdate,
     l_comment
    )
    AS
     SELECT lineitem.l_returnflag,
            lineitem.l_discount,
            lineitem.l_quantity,
            lineitem.l_linestatus,
            lineitem.l_shipinstruct,
            lineitem.l_shipmode,
            lineitem.l_linenumber,
            lineitem.l_orderkey,
            lineitem.l_partkey,
            lineitem.l_suppkey,
            lineitem.l_extendedprice,
            lineitem.l_tax,
            lineitem.l_shipdate,
            lineitem.l_commitdate,
            lineitem.l_receiptdate,
            lineitem.l_comment
     FROM public.lineitem
     ORDER BY lineitem.l_returnflag,
              lineitem.l_discount,
              lineitem.l_quantity,
              lineitem.l_linestatus,
              lineitem.l_shipinstruct,
              lineitem.l_shipmode,
              lineitem.l_linenumber
    SEGMENTED BY hash(lineitem.l_orderkey) ALL NODES;
 
    CREATE PROJECTION public.region_p
    (
     r_regionkey,
     r_name,
     r_comment
    )
    AS
     SELECT region.r_regionkey,
            region.r_name,
            region.r_comment
     FROM public.region
     ORDER BY region.r_regionkey,
              region.r_name,
              region.r_comment
    UNSEGMENTED ALL NODES;
 
    CREATE PROJECTION public.nation_p
    (
     n_regionkey ENCODING RLE,
     n_nationkey,
     n_name,
     n_comment
    )
    AS
     SELECT nation.n_regionkey,
            nation.n_nationkey,
            nation.n_name,
            nation.n_comment
     FROM public.nation
     ORDER BY nation.n_regionkey
    UNSEGMENTED ALL NODES;
 
    CREATE PROJECTION public.supplier_p
    (
     s_nationkey ENCODING RLE,
     s_suppkey,
     s_name,
     s_address,
     s_phone,
     s_acctbal,
     s_comment
    )
    AS
     SELECT supplier.s_nationkey,
            supplier.s_suppkey,
            supplier.s_name,
            supplier.s_address,
            supplier.s_phone,
            supplier.s_acctbal,
            supplier.s_comment
     FROM public.supplier
     ORDER BY supplier.s_nationkey
    SEGMENTED BY hash(supplier.s_suppkey) ALL NODES;

