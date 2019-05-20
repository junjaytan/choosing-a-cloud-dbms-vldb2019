/** Various scripts (SQL and shell scripts */


-- view partitions. By default we don't add any partitions but if we do, this would be how to save the output.
vsql -c "SELECT * FROM partitions" > partitions.txt

/**------- Adjusting storage locations -----**/
--SEE: https://my.vertica.com/docs/9.0.x/HTML/index.htm#Authoring/AdministratorsGuide/StorageLocations/AlteringStorageLocations.htm%3FTocPath%3DAdministrator's%2520Guide%7CManaging%2520Storage%2520Locations%7C_____3

--view storage locations
vsql -c "SELECT * FROM V_MONITOR.DISK_STORAGE;" > v_monitor_disk_storage.txt
SELECT * FROM V_MONITOR.DISK_STORAGE;

-- This is how to create a temp storage location, then set the original data, temp storage location to be just for data.
CREATE LOCATION '/mnt/verticatemp/temp' ALL NODES USAGE 'TEMP';

SELECT ALTER_LOCATION_USE ('/mnt/active_mount/tpch1000/tpch1000/v_tpch1000_node0001_data', 'v_tpch1000_node0001', 'DATA');
SELECT ALTER_LOCATION_USE ('/mnt/active_mount/tpch1000/tpch1000/v_tpch1000_node0002_data', 'v_tpch1000_node0002', 'DATA');
SELECT ALTER_LOCATION_USE ('/mnt/active_mount/tpch1000/tpch1000/v_tpch1000_node0003_data', 'v_tpch1000_node0003', 'DATA');
SELECT ALTER_LOCATION_USE ('/mnt/active_mount/tpch1000/tpch1000/v_tpch1000_node0004_data', 'v_tpch1000_node0004', 'DATA');

-- If you want to change back to the original setup, delete the new temp storage location
-- and reset the original data, temp location back.
SELECT ALTER_LOCATION_USE ('/mnt/active_mount/tpch1000/tpch1000/v_tpch1000_node0001_data', 'v_tpch1000_node0001', 'DATA,TEMP');
SELECT ALTER_LOCATION_USE ('/mnt/active_mount/tpch1000/tpch1000/v_tpch1000_node0002_data', 'v_tpch1000_node0002', 'DATA,TEMP');
SELECT ALTER_LOCATION_USE ('/mnt/active_mount/tpch1000/tpch1000/v_tpch1000_node0003_data', 'v_tpch1000_node0003', 'DATA,TEMP');
SELECT ALTER_LOCATION_USE ('/mnt/active_mount/tpch1000/tpch1000/v_tpch1000_node0004_data', 'v_tpch1000_node0004', 'DATA,TEMP');

SELECT DROP_LOCATION('/mnt/verticatemp/temp', 'v_tpch1000_node0001');
SELECT DROP_LOCATION('/mnt/verticatemp/temp', 'v_tpch1000_node0002');
SELECT DROP_LOCATION('/mnt/verticatemp/temp', 'v_tpch1000_node0003');
SELECT DROP_LOCATION('/mnt/verticatemp/temp', 'v_tpch1000_node0004');


/***----- Memory settings ------ **/
-- This is how to modify the memory setting and save it to an output file.
vsql -c "SELECT * FROM RESOURCE_POOLS;" > resource_pool_settings.txt
ALTER RESOURCE POOL general MAXMEMORYSIZE '70%';
