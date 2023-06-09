./create-cluster-local.sh cluster1 rancher/k3s:v1.25.10-k3s1
./deploy-tenant.sh cluster1 core
./create-cluster-local.sh cluster2 rancher/k3s:latest staging northeurope 8081
./deploy-tenant.sh cluster2 core