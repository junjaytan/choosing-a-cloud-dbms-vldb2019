output=output.txt
for i in $(seq 22 22); do
	echo "Query $i" >> $output
	for trial in $(seq 1 3); do
		aws athena start-query-execution --query-execution-context Database=tpch-sf1000-orc-fixed --query-string "$(sed -n 2,100p ../presto/queries/template${i}.sql | tr '\r\n' ' ')" --result-configuration "OutputLocation=s3://athena-results-temp/" > id.txt 
		id=$(jq '.QueryExecutionId' id.txt | tr -d '"') 
		echo $id
		aws athena get-query-execution --query-execution-id $id > execution.json
		echo
		state=$(jq '.QueryExecution.Status.State' execution.json | tr -d '"')
		while [ $state == "RUNNING" ]; do
			aws athena get-query-execution --query-execution-id $id > execution.json
			state=$(jq '.QueryExecution.Status.State' execution.json | tr -d '"')
			echo "Query${i} is still running"
			sleep 5
		done
		echo "Query${i} Done"
		aws athena get-query-execution --query-execution-id $id
		if [ $state == "SUCCEEDED" ]; then
			runtime=$(jq '.QueryExecution.Statistics.EngineExecutionTimeInMillis' execution.json | tr -d '"')
			data_scan=$(jq '.QueryExecution.Statistics.DataScannedInBytes' execution.json | tr -d '"')
			rt=$(bc <<< "scale=10; $runtime / 1000.0")
			data=$(bc <<< "scale=10; $data_scan / 1024.0 / 1024 / 1024")	
			echo $rt ',' $data >> $output
		else
			echo "ERROR" | tee $output
			exit 0
		fi
	done
done
