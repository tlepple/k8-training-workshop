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
