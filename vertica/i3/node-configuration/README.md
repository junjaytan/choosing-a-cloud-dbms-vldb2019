# run ansible script
# Misc Notes about i3 Ansible Scripts

You will need the ansible [dynamic inventory (ec2.py) script](https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html) to run ansible scripts. Once you have this, you can run the playbooks using a command like:

`ansible-playbook -i PATH/TO/ec2.py -u 'USERNAME' vertica-prereqs-playbook.yml --private-key=PATH/TO/YOURPRIVATEKEY`

Notes about other settings:

* Disk readahead
 * was not set because was already found to be set to 8192. E.g. using command:
/sbin/blockdev --getra /dev/vgebs/lvebs
* Hugepages was also already enabled so this was fine
 * see [this vertica doc page](https://my.vertica.com/docs/7.2.x/HTML/index.htm#Authoring/InstallationGuide/BeforeYouInstall/transparenthugepages.htm#Red_Hat/CentOS_7_Users)
* Scheduler was already set to deadline so this was fine
 * See [this vertica doc page](https://my.vertica.com/docs/7.1.x/HTML/Content/Authoring/InstallationGuide/BeforeYouInstall/IOScheduling.htm)
* Networking
 * i3 instances use AWS's Elastic Network Adapter (ena). If you don't install this kernel module and enable ena on your ec2s via the aws CLI, then your instances will not have 10Gb network connectivity. (I've seen it more in the range of ~6.5Gb).
 * Some RHEL amis (e.g., 7.4 HVM) seem to already have this module installed. Otherws may not. Run the modinfo ena command to detect this.
 * Run the 3 ansible scripts called ansible-ena-setup-0n.yml, where n=1,2,3, to enable ena. After you run these scripts, you will also need to stop your instances and run the aws CLI to enable ena.

