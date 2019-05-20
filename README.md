# choosing-a-cloud-dbms-vldb2019

This contains scripts and configuration details related to experiments performed in *Choosing a Cloud DBMS: Architectures and Tradeoffs* paper. Experiments were performed in early 2018 through the summer.

## Athena

Athena was launched using the aws cli. An example script is provided in the [`athena/` subdirectory](./athena)

## Hive

Each worker used a single 512GB gp2 EBS volume, and the Master used a 128GB gp2 EBS volume for the S3 setup. During testing, the master node was the same instance type as the slaves; however, an actual deployment would use a much smaller instance type as discussed in the following Presto setup section. For the HDFS setup we used 8 volumes of 200GB configured in RAID 0 on each worker node.

Detailed Hive cluster settings are provided in the example setup scripts in the [`hive/` subdirectory](./hive), especially  `setup-doc.txt`.

## Presto

The cluster was installed using [AWS Presto EMR](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-presto.html) (*Core Hadoop* configuration). Presto 0.195 was then manually installed. See the [`presto/` subdirectory](./presto) for an example script. Note that for convenience during testing, the master coordinator node was the same instance type as the worker nodes, although an actual deployment would use a much smaller node. [AWS recommends](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-plan-instances-guidelines.html) that an m4.large instance can be used for clusters of 50 nodes, and we tested that an r4.xlarge was more than enough for the tested cluster sizes.

A detailed example of configuration settings used for a Presto cluster is in [`/presto/example-cluster-config/`](./presto/example-cluster-config)

## Redshift and Spectrum

Redshift nodes were launched from the AWS console with the following settings:

* Within an "us-east" availability zone,
* In the same cluster subnet group
* database encryption = None
* No enhanced VPC routing

## Vertica

### Node Setup

**R4 instances**

* R4 instances were launched using Vertica-provided AWS marketplace AMIs.
* AWS infrastructure settings and the AMI IDs used are specified in the terraform scripts within the [`vertica/r4` subdirectory](./vertica/r4). Node setup configurations are provided in the ansible scripts.

**i3 instances**

* During the time when experiments were run, Vertica provided AWS marketplace AMIs did not allow launching i3 instances, so vertica was installed onto fresh RHEL 7.3 images. The terraform scripts within the [`vertica/i3` subdirectory](./vertica/i3) describe the node configuration, but a terraform bug prevented launching i3 nodes with instance storage from terraform; therefore we launched these manually through the AWS web console. At a high level, this setup includes the following componenets:
  * 25GB root drive (EBS)
  * 250GB gp2 EBS for holding installation files (but not used for DBMS functions)
  * 4 NVMe SSD instance store volumes configured in RAID 0 used for the DBMS.
* Node setup steps are provided in the ansible scripts within the same subdir. Among other things, these perform the following:
  * Get and install AWS ENA drivers for enhanced networking.
  * Install all Vertica prerequisites, such as mcelog, sysstat, ntp. We confirmed that disk readahead settings were already appropriate (at least 2048) and so did not change this. Also initialize swapfile for Vertica.
  * These scripts also set up NFS for experiments where one node reads data from a local volume mounted on another node (these results are not used in the paper).

### DBMS settings

The [`vertica/vertica-configuration` subdir](./vertica/vertica-configuration) contains some example scripts for various settings we changed:

* Resource pool settings were set set to 70\% using the SQL command: `ALTER RESOURCE POOL general MAXMEMORYSIZE '70%';`
* Temp storage locations (for spill-to-disk, etc) were set to a different EBS volume than the volumes holding the DBMS data and catalog.

### Vertica Eon Notes

* To clear the node data depots after each run for the cold cache case, we used the SQL command `SELECT Clear_data_depot();`.