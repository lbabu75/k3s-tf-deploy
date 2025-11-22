# main.tf

# --- Single Cluster: 2 Nodes (1 Server + 1 Agent) ---
resource "null_resource" "k3d_single_cluster" {
  provisioner "local-exec" {
    command = <<-EOT
      # Create cluster named 'build-k8s' with 1 server node and 1 worker (agent) node
      k3d cluster create build-k8s \
        --servers 1 \
        --agents 1
    EOT
    # Run the installation only once
    when = create
  }

  provisioner "local-exec" {
    # Delete the cluster on destroy
    command = "k3d cluster delete build-k8s"
    when    = destroy
  }
}

# --- Kubeconfig Retrieval ---
# Retrieve the kubeconfig content from k3d to allow the Kubernetes provider to connect
data "external" "cluster_kubeconfig" {
  program = ["k3d", "kubeconfig", "write", "build-k8s", "--output", "-"]
}

# --- Kubernetes Provider Configuration ---
provider "kubernetes" {
  # The cluster is accessed via the kubeconfig content
  config_raw = data.external.cluster_kubeconfig.result["stdout"]
}

# --- Example: Deploy a Test Namespace ---
resource "kubernetes_namespace" "test_ns" {
  metadata {
    name = "build-environment-ns"
  }
}
