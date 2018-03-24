
# Params:
#   1. Minio password
#   2. Docker hub password
#   3. Jenkins password

while [[ -z "$MINIO_PWD" ]] ; do
  read -s -p "Enter the Minio password: " MINIO_PWD && echo ""
done

while [[ -z "$DOCKER_HUB_PWD" ]] ; do
  read -s -p "Enter the Docker Hub password: " DOCKER_HUB_PWD && echo ""
done

while [[ -z "$JENKINS_PWD" ]] ; do
  read -s -p "Enter the Jenkins password: " JENKINS_PWD && echo ""
done

K8S_NAMESPACES = "default,spinnaker"
DOCKER_REGISTRY_ADDRESS = "index.docker.io"
DOCKER_REGISTRY_ACCOUNT = "someaccount"
DOCKER_REGISTRY_REPOSITORY = "username/repo"

JENKINS_USER = "jenkins-user"
JENKINS_SPINNAKER_ACCOUNT = "jenkins-lab"
JENKINS_ADDRESS = "http://jenkins:8080"

# Apply config via Halyard
hal config version edit --version 1.5.3
hal config features edit --mine-canary=true

echo $MINIO_PWD | hal config storage s3 edit --endpoint http://minio-service.spinnaker.svc.cluster.local:9001/ --bucket data --access-key-id spinnaker-minio --secret-access-key
hal config storage edit --type s3

hal config provider docker-registry enable
hal config provider docker-registry account add $DOCKER_REGISTRY_ACCOUNT --address $DOCKER_REGISTRY_ADDRESS
echo $DOCKER_HUB_PWD | hal config provider docker-registry account edit $DOCKER_REGISTRY_ACCOUNT --username $DOCKER_REGISTRY_ACCOUNT --address $DOCKER_REGISTRY_ADDRESS --add-repository $DOCKER_REGISTRY_REPOSITORY --password

hal config provider kubernetes enable
hal config provider kubernetes account add k8s-account --context kubernetes-admin@kubernetes --docker-registries $DOCKER_REGISTRY_ACCOUNT --namespaces $K8S_NAMESPACES

hal config ci jenkins enable
echo $JENKINS_PWD | hal config ci jenkins master add $JENKINS_SPINNAKER_ACCOUNT --address $JENKINS_ADDRESS --username $JENKINS_USER --password

hal config deploy edit --type distributed --account-name k8s-account

# Deploy Spinnaker
hal deploy apply
