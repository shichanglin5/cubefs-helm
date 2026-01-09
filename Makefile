# cubefs-helm Makefile

package: lint
	cp README.md cubefs/ && helm package cubefs && rm cubefs/README.md

lint:
	helm lint ./cubefs

.PHONY: package lint

helm-deploy-test:
	helm upgrade --install --create-namespace \
	  -n cubefs-dev cubefs ./cubefs \
	  --kubeconfig /home/lhhdz/.kube/config-test \
	  -f ./values-overrides-test.yaml

helm-deploy-prod-th:
	helm upgrade --install --create-namespace \
	  -n cubefs-dev cubefs ./cubefs \
	  --kubeconfig /home/lhhdz/.kube/config-prod-th \
	  -f ./values-overrides-prod.yaml

helm-deploy-prod-th-native:
	helm upgrade --install --create-namespace \
	  -n cubefs-native cubefs-native ./cubefs \
	  --kubeconfig /home/lhhdz/.kube/config-prod-th \
	  -f ./values-overrides-prod-native.yaml
