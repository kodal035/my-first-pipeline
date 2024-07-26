provider "local" {}

resource "local_sensitive_file" "install_docker_script" {
  filename = "${path.module}/install_docker.sh"
  content = file("${path.module}/install_docker.sh")
}

resource "null_resource" "install_docker" {
  provisioner "local-exec" {
    command = "bash ${local_sensitive_file.install_docker_script.filename}"
  }
}

resource "local_sensitive_file" "install_minikube_script" {
  filename = "${path.module}/install_minikube.sh"
  content = file("${path.module}/install_minikube.sh")
}

resource "null_resource" "install_minikube" {
  provisioner "local-exec" {
    command = "bash ${local_sensitive_file.install_minikube_script.filename}"
  }
  depends_on = [null_resource.install_docker]
}

resource "local_sensitive_file" "update_kube_config_script" {
  filename = "${path.module}/update_kube_config.sh"
  content = file("${path.module}/update_kube_config.sh")
}

resource "null_resource" "update_kube_config" {
  provisioner "local-exec" {
    command = "bash ${local_sensitive_file.update_kube_config_script.filename}"
  }
  depends_on = [null_resource.install_minikube]
}

resource "local_sensitive_file" "install_jenkins_script" {
  filename = "${path.module}/install_jenkins.sh"
  content = file("${path.module}/install_jenkins.sh")
}

resource "null_resource" "install_jenkins" {
  provisioner "local-exec" {
    command = "bash ${local_sensitive_file.install_jenkins_script.filename}"
  }
  depends_on = [null_resource.update_kube_config]
}

resource "local_sensitive_file" "create_kubernetes_resources_script" {
  filename = "${path.module}/create_kubernetes_resources.sh"
  content = file("${path.module}/create_kubernetes_resources.sh")
}

resource "null_resource" "create_kubernetes_resources" {
  provisioner "local-exec" {
    command = "bash ${local_sensitive_file.create_kubernetes_resources_script.filename}"
  }
  depends_on = [null_resource.install_jenkins]
}
