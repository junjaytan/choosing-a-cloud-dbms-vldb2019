# Sample script for installing presto manually after launching the Core Hadoop cluster via AWS Presto EMR
source ip_address.sh

python update_config.py $instance_size $node_count
for ip in ${ips[*]}
do
	$SSH ubuntu@$ip "rm /var/presto/data/java_*" 
done

for ip in ${ips[*]}
do
	$SCP presto-server-0.195-e.0.5.tar ubuntu@$ip:~
	$SSH ubuntu@$ip "tar xvf presto-server-0.195-e.0.5.tar; mv presto-server-0.195-e.0.5 presto-0.195;"
	$SCP *.xml ubuntu@$ip://usr/share/hadoop-2.9.0/etc/hadoop
done

for ip in ${ips[*]}; do
	$SCP presto-cli-0.195-e.0.5-executable.jar ubuntu@$ip:~ 
	$SSH ubuntu@$ip "mv presto-cli-0.195-e.0.5-executable.jar presto-0.195/presto; sudo chmod +x presto-0.195/presto"
done

for ip in ${ips[*]}; do
	$SSH ubuntu@$ip "rm -r ~/presto-0.195/etc"
	$SCP -r etc ubuntu@$ip:~/presto-0.195/ 
done

for ip in ${master[*]}; do
	$SSH ubuntu@$ip "mv ~/presto-0.195/etc/config.properties.master ~/presto-0.195/etc/config.properties;"
done

for ip in ${slaves[*]}; do
	$SSH ubuntu@$ip "mv ~/presto-0.195/etc/config.properties.slave ~/presto-0.195/etc/config.properties;"
done


$SSH ubuntu@${master[0]} "mv presto-0.195/etc/node.properties.master presto-0.195/etc/node.properties"
$SSH ubuntu@${slaves[0]} "mv presto-0.195/etc/node.properties.slave0 presto-0.195/etc/node.properties"
$SSH ubuntu@${slaves[1]} "mv presto-0.195/etc/node.properties.slave1 presto-0.195/etc/node.properties"
$SSH ubuntu@${slaves[2]} "mv presto-0.195/etc/node.properties.slave2 presto-0.195/etc/node.properties"
$SSH ubuntu@${slaves[3]} "mv presto-0.195/etc/node.properties.slave3 presto-0.195/etc/node.properties"

for ip in ${ips[*]}; do
	echo $ip
	$SSH ubuntu@$ip "./presto-0.195/bin/launcher stop; ./presto-0.195/bin/launcher start"
done
