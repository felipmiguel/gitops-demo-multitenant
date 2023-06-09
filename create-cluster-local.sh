cluster_name=$1
image=${2:-rancher/k3s:v1.25.10-k3s1}
environment=${3:-staging}
location=${4:-northeurope}
server_port=${5:-8080}

# image rancher/k3s:v1.25.10-k3s1
k3d cluster create ${cluster_name} -p ${server_port}:80@loadbalancer --agents 2 --image ${image} --k3s-arg "--disable=traefik@server:0" 
# cluster2 is the new one, assuming latest version of k3s is good enough
# k3d cluster create cluster2 -p 8081:80@loadbalancer --agents 4 --k3s-arg "--disable=traefik@server:0" 

# the github token will be requested when running the command `flux bootstrap github`
# export GITHUB_TOKEN=<REDACTED>
export GITHUB_USER=felipmiguel
export GITHUB_REPO=gitops-demo-multitenant

kubectl config use-context k3d-${cluster_name}

flux bootstrap github \
--components-extra=image-reflector-controller,image-automation-controller \
--owner=${GITHUB_USER} \
--repository=${GITHUB_REPO} \
--branch=main \
--personal \
--path=clusters/${environment}/${location} \
--token-auth



