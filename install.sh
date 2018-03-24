
while [[ -z "$DOCKER_REG_PWD" ]] ; do
  read -s -p "Enter your Docker Registry password: " DOCKER_REG_PWD && echo ""
done

kubectl create namespace spinnaker
kubectl create -f minio/standalone.yml
kubectl create -f halyard/serviceaccount.yml
kubectl create -f halyard/halyard.yml
