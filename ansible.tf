resource "local_file" "ansible_host" {

    depends_on = [
      aws_instance.k8s
    ]

    count       = 2
    content     = "[Master_Node]\n${aws_instance.k8s.public_ip}\n\n[Worker_Node]\n${join("\n", aws_instance.myk8svm.*.public_ip)}"
    filename    = "inventory"
  }

resource "local_file" "ansible_vars"{
  
    depends_on = [
      aws_instance.k8s
    ]

    content   = "master_ip: ${aws_instance.k8s.public_ip} \n name:${var.name}"
    filename  = "vars.yml" 
}

resource "null_resource" "null1" {

    depends_on = [
      local_file.ansible_host
    ]

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    command = "ansible-playbook playbook.yml --private-key=${var.name}.pem"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    command = "ansible-playbook longhorn.yml --private-key=${var.name}.pem"
  }

  provisioner "local-exec" {
    command = "ansible-playbook longhorn-master.yml --private-key=${var.name}.pem"
  }

#  provisioner "local-exec" {
#    command = "sleep 60"
#  }

#  provisioner "local-exec" {
#    command = "ansible-playbook kubeflow.yml --private-key=${var.name}.pem"
#  }
}

output "Master_Node_IP" {
  value = aws_instance.k8s.public_ip
}

output "Worker_Node_IP" {
  value = join(", ", aws_instance.myk8svm.*.public_ip)
}
