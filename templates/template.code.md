

---
Title:  Learning Kubernetes and supporting tools.
Author:  Tim Lepple
Last Updated:  12.06.2024
Comments:  This repo is intended to capture notes about using K8s and its supporting cast members in the K8 ecosystem.
Tags:  Kubernetes | K8s | Docker | Ubuntu
---


# K8s - Hands On Exercise and Notes

* The goal of this document is to capture details that mimic a current set of administration tasks that currently are run from a docker container and migrate this container to be run inside of Kubernetes.

---

---
---

### Create your `namespace`

- Ensure you have setup your `define.yaml` file.  --> [How2Guide](https://nexuscognitive.atlassian.net/wiki/spaces/CDPSAASTeam/pages/208732161/K8s+-+How+to+Create+a+Service+Account+and+Credentials+to+access+EKS+Cluster)


```bash
kubectl create namespace <YOUR NAMESPACE HERE>
```

---

### Create your `Persistent Volume Claim`

```bash
kubectl apply -f pvc.yaml --namespace=<YOUR NAMESPACE HERE>
```

---

### Create your `ecr-secret`

```bash
kubectl apply -f ecr-secret.yaml --namespace=<YOUR NAMESPACE HERE>
```


---

### Create your `azure-repo-secret`

```bash
kubectl apply -f az_secrets.yaml --namespace=<YOUR NAMESPACE HERE>
```

---

### Create your POD 

```bash
kubectl apply -f pod.yaml --namespace=<YOUR NAMESPACE HERE>
```

---

### Connect into your new pod POD 

```bash
kubectl exec -it awsbuild-pod --namespace=<YOUR NAMESPACE HERE> -- /bin/bash
```
---

### List your PODs

```bash
kubectl get pods --namespace=<YOUR NAMESPACE HERE>
```

---

### Describe your new POD 

```bash
kubectl describe pod awsbuild-pod --namespace=<YOUR NAMESPACE HERE>
```


---

### Validate PVC is bound

```bash
kubectl get pvc efs-claim-<YOUR NAMESPACE HERE> --namespace=<YOUR NAMESPACE HERE>
```


---

### Test that data is being persisted to our PVC by deleting the POD

```bash
kubectl get pvc efs-claim-<YOUR NAMESPACE HERE> --namespace=<YOUR NAMESPACE HERE>
```


**Exit the container from k8s:** `exit`

**Run from your desktop:**

```bash
kubectl delete pod awsbuild-pod --namespace=<YOUR NAMESPACE HERE>
```

**Create the POD again using the existing PVC***

```bash
kubectl apply -f pod.yaml --namespace=<YOUR NAMESPACE HERE>
```

**Connect into the container**

```bash
kubectl exec -it awsbuild-pod --namespace=<YOUR NAMESPACE HERE> -- /bin/bash
```

**List contents from one of the persisted volumes**

```bash
cat ~/.aws/config
```

**If all ran successfully you should see similar output:**

```text
[profile cazenapoc]
azure_tenant_id=<TENANT ID>
azure_app_id_uri=<APP ID>
azure_default_username=<YOUR CDP EMAIL ADDRESS>
azure_default_role_arn=CDPOne_FullAccess
azure_default_duration_hours=1
azure_default_remember_me=true


[profile Bainbridge]
azure_tenant_id=<TENANT ID>
azure_app_id_uri=<APP ID>
azure_default_username=YOUR CDP EMAIL ADDRESS>
azure_default_role_arn=CDPOne_FullAccess
azure_default_duration_hours=1
azure_default_remember_me=true
#End CDP One config
```

**Note:** This section demonstrated that our PVC has retained the the data from earlier.

---
---

## **Internal Notes**

 - still trying to workout firewall issues in AWS for `nx1poc`.   all works within `rapid`

---
---





# Useful `kubectl` commands

---


| Command | Description |
| ----------- | ----------- |
| kubectl get namespace | List all the namespaces |
| kubectl create namespace `<namespace>` | Create a namespace |
| kubectl -n `<namespace>` get pods | List all pods in a namespace. |
| kubectl -n `<namespace>` logs `<pod-name>` | View logs for a specific pod. |
| kubectl -n `<namespace>` describe pod `<pod-name>` | Detailed pod information. |
| kubectl -n `<namespace>` exec -it `<pod-name>` | connect into a pod. |
| kubectl -n `<namespace>` get events -n `<namespace>` | View events for troubleshooting. |
| kubectl -n `<namespace>` rollout restart `<deploy>` | Restart a deployment. |
| kubectl -n `<namespace>` delete pod `<pod_name>` | Delete a pod |
| kubectl delete ns `<namespace>` | Delete a namespace |
| kubectl get pv | List Persistent Volumes |
| kubectl get pvc | List Persistent Volume Claims|
| kubectl get sc | Listing Storage Classes |
| kubectl get sc `<storage class name>` -o yaml | examine a specific storage class 'efs-sc' and write out the yaml |
| kubectl apply --dry-run=client -f `<yaml filename>` | Test that the yaml is configured correctly |
| kubectl -n `<namespace>` apply -f `<yaml filename>` | Apply configured yaml file to create K8 object |
| kubectl -n `<namespace>`> get secrets| List the names of Secrets |
| kubectl get serviceaccounts --all-namespaces | List Service Accounts |
| kubectl get rolebinding,clusterrolebinding -n `<namespace>` | grep admin-user | Find service accounts with admin privs |




---



---
---

