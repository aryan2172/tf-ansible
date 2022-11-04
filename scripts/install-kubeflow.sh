user=$1
namespace=$2


curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

mv kustomize /bin/


cd /assets/manifests

sed -i "s/user@example.com/$user/g" /assets/manifests/common/dex/base/config-map.yaml

sed -i "s/user@example.com/$user/g" /assets/manifests/common/user-namespace/base/params.env

sed -i "s/kubeflow-user-example-com/$namespace/g" /assets/manifests/common/user-namespace/base/params.env

while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done
