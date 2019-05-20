select sum(1.0 * l_orderkey * l_partkey * l_suppkey * l_linenumber * l_quantity * l_extendedprice * l_discount * l_tax) 
from lineitem;
