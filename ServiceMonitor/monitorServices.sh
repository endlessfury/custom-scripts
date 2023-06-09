#!/bin/bash

# haproxy endpoints
declare -a URLs=(<health_api_after_url_paths>);
declare -a MS=(<health_api_service_names_to_match>);
# non-haproxy endpoints urls
declare -a xURLs=(<non-haproxy_health_api_after_url_paths>);
declare -a xMS=(<non-haproxy_health_api_service_names_to_match>);
export TKN=$(curl -s -X POST 'http://<haproxy_server><haproxy_port>/<auth_path>/token'  -H "Content-Type: application/x-www-form-urlencoded"  -d "username=<keycloak_user>"  -d 'password=<keycloak_password>'  -d 'grant_type=password'  -d 'client_id=<keycloak_client>' |awk -F\" '{print $4}');

declare -a failedURLs=();
declare -a failedMS=();

#haproxy endpoints checl


counter=0;
for api in ${URLs[@]};do
	#echo $api " done"
	export response=$(curl -X GET --header "Authorization: Bearer $TKN" "http://<haproxy_server><haproxy_port>$api" -I -s | grep HTTP);
	export feedback=$(echo $response | sed 's/HTTP\/1.1 20. //g' | sed 's/Accepted/OK/g' | sed 's/HTTP\/1.1 40. Not Found/NOK/g' | sed 's/HTTP\/1.1 50. Service Unavailable/NOK/g' | sed 's/HTTP\/1.1 40. Not Acceptable/NOK/g');
	#echo $api $feedback;	
	if [[ $feedback == *"NOK"* ]]; then
		failedURLs+=("$api");
		failedMS+=("${MS[$counter]}");
		#echo ${MS[$counter]};
	fi
	((counter+=1))
done

# non-haproxy endpoints checki
# service
export response=$(curl -Is -X GET --header "Authorization: Bearer $TKN" "http://<haproxy_server><haproxy_port>${xURLs[0]}" | grep HTTP);
export feedback=$(echo $response | sed 's/HTTP\/1.1 20. //g' | sed 's/Accepted/OK/g' | sed 's/HTTP\/1.1 40. Not Found/NOK/g' | sed 's/HTTP\/1.1 50. Service Unavailable/NOK/g' | sed 's/HTTP\/1.1 40. Not Acceptable/NOK/g');
#echo $api $feedback;
if [[ $feedback == *"NOK"* ]]; then
		failedURLs+=("${xURLs[0]}");
		failedMS+=("${xMS[0]}");
fi


counter=0;
if [ ${#failedURLs[@]} -gt 0 ];then
	echo 'Healtcheck failed for:';
	for fail in ${failedURLs[@]}; do
		echo ${failedMS[$counter]}" [$fail]";
		((counter+=1))
	done
else
	echo 'All microservices are ok';
fi

if [ ${#failedURLs[@]} -gt 0 ]; then
	exit 9
fi

