
# kubernetes-spinnaker

This repository contains the necessary config to deploy Spinnaker into the same Kubernetes cluster that it will manage. All containers are deployed into a `spinnaker` namespace.

This assumes that you already the following things setup, and in working order, and accessible by the Kubernetes cluster: 

1. An NFS Server
2. A Docker Registry 
3. A Jenkins build server

## Installation

1. Clone this repo onto your Kubernetes Master, or wherever your `kubectl` is installed.
2. Replace `<NFS_IP_ADDRESS>` with your NFS Server IP in `halyard.yml` and `minio/standalone.yml`.
3. Run `./install.sh`. This will deploy halyard into a single replica.
4. Exec into your halyard pod: `kubectl exec -it -n spinnaker <HALYARD_POD> bash`. Running `kubectl get pods -n spinnaker` will give you the halyard pod name.
5. Copy the contents of `~/.kubeconfig` from your Kubernetes master, to `/root/.kubeconfig` in the halyard container.
6. Copy the contents of `configure-halyard.sh` from this repo, to `/root/configure-halyard.sh` in the halyard container.
7. From the halyard container, update the jenkins and docker registry environment variables to your paths, credentials etc.
8. From the halyard container, run `./root/configure-halyard.sh` to configure and deploy Spinnaker. This will prompt for the following 3 passwords: 
    1. **Minio:** This will be `Test1234` by default, but should be changed to something more secure by changing the value of the `MINIO_SECRET_KEY` environment variable in `minio/standalone.yml`.
    2. **Docker Registry:** Enter the password for your Docker Registry
    3. **Jenkins:** Enter the password for the Jenkins user.
9. To provide Spinnaker access to deploy containers into a specific namespace, run `./permit-namespace.sh "namespace_name"` from the halyard container. (**NOTE:** This is only works for a single namespace. More roles/rolebindings .yml would have to be created if Spinnaker needs access to deploy to more than one namespace)
10. Expose the Spinnaker dashboard(Deck) by running `./expose-deck.sh` from the Kubernetes master.
11. Access the Spinnaker dashboard at http://localhost:9000
