Ansible Role: kubernetes_instance
=========

An Ansible Role to configure Amazon EC2 instance as Kubernetes Master Node.

Requirements
------------

None

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

```
pkgs:
  - kubelet
  - kubeadm
  - kubectl
  - docker
  - iproute-tc

services:
  - kubelet
  - docker

docker_daemon: "/etc/docker/daemon.json"

kubernetes_config: "/etc/sysctl.d/k8s.conf"
```

Dependencies
------------

This Role is dependent on [kubernetes_instance](https://galaxy.ansible.com/adyraj/kubernetes_instance) role which is hosted on Ansibe Galaxy. 

Example Playbook
----------------

Playbook for  kubernetes_master

```
- hosts: tag_Name_K8S_Master
  roles:
    - kubernetes.master
```

Playbook for kubernetes_instance and kubernetes_master roles together.

```
- hosts: localhost
  roles:
    - kubernetes.instance
  tasks:
    - meta: refresh_inventory

- hosts: tag_Name_K8S_Master
  roles:
    - kubernetes.master
```

License
-------

BSD

Author Information
------------------

This role is created in 2021 by Aditya Raj
