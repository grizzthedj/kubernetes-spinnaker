
kubectl create -f rbac/role.yml -n $1
kubectl create -f rbac/rolebinding.yml -n $1
