Ansible Role: kubernetes_worker
=========

An Ansible Role to configure Amazon EC2 instance as Kubernetes Worker Node.

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

This Role is dependent on [kubernetes_instance](https://galaxy.ansible.com/adyraj/kubernetes_instance) role and [kubernetes_master](https://galaxy.ansible.com/adyraj/kubernetes_master) which is hosted on Ansibe Galaxy. 

Example Playbook
----------------

Playbook for kubernetes_worker

```
- hosts: tag_Name_K8S_Worker1
  roles:
    - kubernetes.worker

- hosts: tag_Name_K8S_Worker2
  roles:
    - kubernetes.worker
```

Playbook to configure K8S Cluster using [kubernetes_instance](https://galaxy.ansible.com/adyraj/kubernetes_instance), [kubernetes_master](https://galaxy.ansible.com/adyraj/kubernetes_master) and [kubernetes_worker](https://galaxy.ansible.com/adyraj/kubernetes_worker) roles.

```
- hosts: localhost
  roles:
    - kubernetes.instance
  tasks:
    - meta: refresh_inventory

- hosts: tag_Name_K8S_Master
  roles:
    - kubernetes.master

- hosts: tag_Name_K8S_Worker1
  roles:
    - kubernetes.worker

- hosts: tag_Name_K8S_Worker2
  roles:
    - kubernetes.worker
```

License
-------

BSD

Author Information
------------------

This role is created in 2021 by Aditya Raj
