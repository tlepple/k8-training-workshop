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

### List your new POD 

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
