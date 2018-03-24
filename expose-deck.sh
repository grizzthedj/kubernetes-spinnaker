
nohup kubectl --namespace spinnaker port-forward $(kubectl --namespace spinnaker get pods -l replication-controller=spin-deck-v000 -o jsonpath='{.items[*].metadata.name}') 9000:9000 & 
nohup kubectl --namespace spinnaker port-forward $(kubectl --namespace spinnaker get pods -l replication-controller=spin-gate-v000 -o jsonpath='{.items[*].metadata.name}') 8084:8084 &
