# GitOps Workflow with Flux v2 - Multi-Tenancy

[![test](https://github.com/mfamador/gitops-demo-multitenant/actions/workflows/test.yaml/badge.svg)](https://github.com/mfamador/gitops-demo-multitenant/actions/workflows/test.yaml)
[![e2e](https://github.com/mfamador/gitops-demo-multitenant/actions/workflows/e2e.yaml/badge.svg)](https://github.com/mfamador/gitops-demo-multitenant/actions/workflows/e2e.yaml)
[![license](https://img.shields.io/github/license/mfamador/gitops-demo-multitenant.svg)](https://github.com/mfamador/gitops-demo-multitenant/blob/main/LICENSE)

_For the original example see [flux2-multi-tenancy](https://github.com/fluxcd/flux2-multi-tenancy).

---

# Scenario



flux create tenant core --with-namespace=core \
--export > ./tenants/base/core/rbac.yaml

flux create source git data \
--namespace=data \
--url=https://github.com/mfamador/gitops-demo-tenant-data \
--branch=main \
--export > ./tenants/base/data/sync.yaml
--secret-ref=

flux create source git flux-system \
--url=ssh://git@<host>/<org>/<repository> \
--ssh-key-algorithm=ecdsa \
--ssh-ecdsa-curve=p521 \
--branch=master \
--interval=1m

