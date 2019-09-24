#!/usr/bin/env bash
set -x

# delayed added to ensure consul has started on host - intermittent failures
sleep 2

AGENTTOKEN=`sudo VAULT_TOKEN=reallystrongpassword VAULT_ADDR="http://${LEADER_IP}:8200" vault kv get -field "value" kv/development/consulagentacl`
export CONSUL_HTTP_TOKEN=${AGENTTOKEN}

/usr/local/go/bin/go get ./...
/usr/local/go/bin/go get -u github.com/gobuffalo/packr/packr
packr build -o webcounter main.go
./webcounter -consulACL=${CONSUL_HTTP_TOKEN} -ip="0.0.0.0" -consulIp="127.0.0.1:8321" &

# delay added to allow webcounter startup
sleep 2

ps -ef | grep webcounter

# check web frontend
echo "Web Frontend"
curl http://127.0.0.1:3000

# check health
echo "APPLICATION HEALTH"
curl http://127.0.0.1:8314/health

curl http://localhost:8080/health

curl http://localhost:8080

curl http://127.0.0.1:8080/health

curl http://127.0.0.1:8080

page_hit_counter=`lynx --dump http://127.0.0.1:8080`
echo $page_hit_counter
next_page_hit_counter=`lynx --dump http://127.0.0.1:8080`

echo $next_page_hit_counter
if (( next_page_hit_counter > page_hit_counter )); then
 echo "Successful Page Hit Update"
 exit 0
else
 echo "Failed Page Hit Update"
 exit 1
fi
# The End
