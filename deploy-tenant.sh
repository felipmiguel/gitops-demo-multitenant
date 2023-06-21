cluster=$1
tenant=$2

export GITHUB_USER=felipmiguel
export GITHUB_REPO=gitops-demo-tenant-${tenant}

kubectl config use-context "k3d-${cluster}"

kubectl create namespace ${tenant}

echo 'Setup RBAC...'
flux create tenant ${tenant} \
--label=istio-injection=enabled \
--with-namespace=${tenant} \
--export > ./tenants/base/${tenant}/rbac.yaml

echo 'Setup git source and kustomization...'
flux create source git ${tenant} \
--namespace=${tenant} \
--url=https://github.com/${GITHUB_USER}/gitops-demo-tenant-${tenant} \
--secret-ref=${tenant} \
--branch=main \
--export > ./tenants/base/${tenant}/sync.yaml

flux create kustomization ${tenant} \
--namespace=${tenant} \
--source=${tenant} \
--service-account=${tenant} \
--path="./" \
--prune=true \
--interval=5m \
--export >> ./tenants/base/${tenant}/sync.yaml

echo "Setup ${tenant} secret..."
kubectl get secret -n flux-system flux-system -oyaml > ${tenant}-secret.yaml
sed -i 's/flux-system/'${tenant}'/g' ${tenant}-secret.yaml

kubectl apply -f ${tenant}-secret.yaml

# echo "Install the metrics server..."
# kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml


# echo "Validate critical app..."


# ./scripts/make-requests.sh podinfo.staging.eun

