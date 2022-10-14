master_ip=$1
cluster_name=$2
echo $master_ip

sed -i "s/vanshav/$cluster_name/g" /assets/dashboard.json




kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm upgrade --namespace monitoring --install kube-stack-prometheus prometheus-community/kube-prometheus-stack --set prometheus-node-exporter.hostRootFsMount.enabled=false

sleep 60

kubectl port-forward --namespace monitoring svc/kube-stack-prometheus-kube-prometheus 9090:9090 --address=0.0.0.0 > /dev/null 2>&1 &

sleep 30

curl -X POST http://admin:admin123@3.6.198.89:3000/api/datasources \
    -H "Content-Type: application/json" \
    -d '{"name":"'"$cluster_name"'", "type":"prometheus", "url":"http://'"$master_ip"':9090/", "access":"proxy", "basicAuth":false}'

curl -X POST http://admin:admin123@3.6.198.89:3000/api/dashboards/import -H "Content-Type: application/json" -d @/assets/dashboard.json
