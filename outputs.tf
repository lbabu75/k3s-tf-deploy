# outputs.tf

output "cluster_info" {
  value = "Single cluster 'build-k8s' with 2 nodes (1 server, 1 agent) is ready. Use 'k3d kubeconfig get build-k8s' to retrieve config."
}
