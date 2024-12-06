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
azure_tenant_id=655b1c57-e57f-413b-8c9d-7c2fd723604d
azure_app_id_uri=9a60d808-b1be-44ef-87c1-5798a9412080
azure_default_username=tlepple@cloudera-cdp.com
azure_default_role_arn=CDPOne_FullAccess
azure_default_duration_hours=1
azure_default_remember_me=true


[profile Bainbridge]
azure_tenant_id=655b1c57-e57f-413b-8c9d-7c2fd723604d
azure_app_id_uri=d5bf9193-7b32-4e05-b9f0-ccf6ba857d90
azure_default_username=tlepple@cloudera-cdp.com
azure_default_role_arn=CDPOne_FullAccess
azure_default_duration_hours=1
azure_default_remember_me=true
#End CDP One config
```

**Note:** This section demonstrated that our PVC has retained the the data from earlier.
