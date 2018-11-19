
kubectl delete -f halyard/halyard.yml 
kubectl delete -f halyard/serviceaccount.yml
kubectl delete -f minio/standalone.yml

#kubectl delete namespace spinnaker

kubectl delete -f https://raw.githubusercontent.com/giantswarm/kubernetes-prometheus/master/manifests-all.yaml

