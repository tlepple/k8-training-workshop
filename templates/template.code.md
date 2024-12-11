---
Author:  Tim Lepple
Last Updated:  12.06.2024
Comments:  
Tags:  Kubernetes | K8s | Docker | Ubuntu
---
# Docker  - Hands On Exercise 

### **Build the Docker Image** and give it a unique name.  `ubuntu:<YOUR NAMESPACE HERE>-azdevops-cdp-jammy-img`:

1.  **Change to our working directory**
    ```bash
    cd ~/docker/compose/<YOUR NAMESPACE HERE>/k8-training-workshop/output
    ```
2.  **Build the docker image**
    ```bash
    docker build -t amd64/ubuntu:<YOUR NAMESPACE HERE>-azdevops-cdp-jammy-img .
    ```
3.  **List docker images that are on this host**
    ```bash
    docker image ls
    ```
4.  **Create a docker volume for our new container to use**
    ```bash
    docker volume create <YOUR NAMESPACE HERE>-awsadauth_vol1
    ```
5.  **Create a docker container using our new image via `compose`**
    ```bash
    docker compose up -d
    ```
---

## Let's test this image on this docker host to verify it worked.

---

1.  **Connect into our new container**:
   - Connect to the running container and check this directory exists`/app/pim` to ensure the Git repository has been cloned or updated as expected. This container does not run like most docker containers, it is operating more like a linux VM.   It will run continously until you shut it down.

  ```
docker exec -it <YOUR NAMESPACE HERE>-aws-ad-auth bash
  ```

2.  Setup a local aws config file with profiles you have access to from Azure AD credentials

 ```
cd /app/pim
az login 
 ```

 *  This will return output similar to this:

 ```
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code <your specfic code>  to authenticate.
 ```
3.  Authenticate to Azure AD:   
    1. Open a chrome browser on your host and give it the URL `https://microsoft.com/devicelogin`.   
    2. It will ask you to enter the code from your container `<your specfic code>`.   
    3. From here you will select your Microsoft AD account.  
    4. Then click the `Continue` button from the next screen.
    5. In the returned output choose `1` which should be associated with Tenant ` NX1-Cloudera-CDP-Operations`
    
      
    
4.  Extract from Azure AD account profiles you are authorized to access in preparation for next steps.

 ```
 cd /app/pim
 python3 create_config.py
 ```

5.  Setup aws configuration files with Account Profiles gathered in previous step.

 ```
. update_config.sh
 ```


*  It will prompt you for some input.   Sample output here:

 ```
 Enter Azure AD Username: <input your cloudera-cdp.com email address here>
 Enter AWS Session Role Name: <input your role name to include here> Example:  CDPOne_FullAccess
 Updated configuration merged into ~/.aws/config successfully.
  ```

**Validate it worked with this command:** `cat ~/.aws/config`

**Sample Output**:

```
[profile VictoriaUniversity_vu735]
azure_tenant_id=<sample tenant id>
azure_app_id_uri=<sample app id>
azure_default_username=<your email address>
azure_default_role_arn=CDPOne_FullAccess
azure_default_duration_hours=1
azure_default_remember_me=true

[profile Moelis_me180]
azure_tenant_id=<sample tenant id>
azure_app_id_uri=<sample app id>
azure_default_username=<your email address>
azure_default_role_arn=CDPOne_FullAccess
azure_default_duration_hours=1
azure_default_remember_me=true
```

6.  **Set a IAM profile from within this new container.**  - We will use an `SBFE Profile`
    ```bash
    export AWS_PROFILE=SBFE_sb250
    export AWS_DEFAULT_REGION=us-east-1
    export AWS_REGION=us-east-1

    aws-azure-login --no-sandbox --profile SBFE_sb250
    ```

7.  It will prompt you for your Azure AD Password

8.  It will prompt you for a code from you 2-factor authentication device

9.  If all works without error, you can see that it creates a new file with credentials here:
    `cat ~/.aws/credentials`

10.  Test that it is working with a sample aws cli command to list the bucket names in `S3`:
     ```bash
     export AWS_PROFILE=SBFE_sb250
     export AWS_DEFAULT_REGION=us-east-1
     export AWS_REGION=us-east-1

     aws s3 ls
     ```
11.  **Sample Output:**

    ```bash
    2024-04-08 12:37:30 aws-athena-query-results-208226632548-us-east-1
    2022-11-03 15:14:32 cf-templates-1kwe6ecrr19x1-us-east-1
    2024-04-22 14:19:03 datadogintegration-forwarderstack--forwarderbucket-d008l9a3gziu
    2024-03-26 05:13:06 lacework-ct-bucket-b66b86f9
    2024-03-26 05:13:06 lacework-ct-bucket-b66b86f9-access-logs
     ```

13.  **Exit the Container**: run the command `exit`

 ##  Docker Command Reference for Common Items:

---


| Command | Description |
| ----------- | ----------- |
| docker ps -a | list all containers on host |
| docker container start aws-ad-auth | start an existing container |
| docker container stop aws-ad-auth | stop a running container |
| docker container rm aws-ad-auth | remove a docker container |
| docker volume ls | list docker volumes |
| docker volume rm awsadauth_vol | remove a docker volume |
| docker image ls | list local docker images |
| docker image rm `<image ID>` | remove a local image |

---
---

# End of Docker Stuff

---
---

# Begin K8 Stuff

---
---

# Add steps here to push this new image to ECR

# Add steps here to get your ECR PAT here.

# K8s - Hands On Exercises

---
---

### Create your `namespace`

- Ensure you have setup your `define.yaml` file.  


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
---
## **Test that the POD works as expected**

### Connect into your new POD 

```bash
kubectl exec -it awsbuild-pod --namespace=<YOUR NAMESPACE HERE> -- /bin/bash
```
---

Setup a local aws config file with profiles you have access to from Azure AD credentials

 ```
cd /app/pim
az login 
 ```

 *  This will return output similar to this:

 ```
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code <your specfic code>  to authenticate.
 ```
6.  Authenticate to Azure AD:   
    1. Open a chrome browser on your host and give it the URL `https://microsoft.com/devicelogin`.   
    2. It will ask you to enter the code from your container `<your specfic code>`.   
    3. From here you will select your Microsoft AD account.  
    4. Then click the `Continue` button from the next screen.
    5. In the returned output choose `1` which should be associated with Tenant ` NX1-Cloudera-CDP-Operations`
    
      
    
7.  Extract from Azure AD account profiles you are authorized to access in preparation for next steps.

 ```
 cd /app/pim
 python3 create_config.py
 ```

8.  Setup aws configuration files with Account Profiles gathered in previous step.

 ```
. update_config.sh
 ```


*  It will prompt you for some input.   Sample output here:

 ```
 Enter Azure AD Username: <input your cloudera-cdp.com email address here>
 Enter AWS Session Role Name: <input your role name to include here> Example:  CDPOne_FullAccess
 Updated configuration merged into ~/.aws/config successfully.
  ```

**Validate it worked with this command:** `cat ~/.aws/config`

**Sample Output**:

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
---
---

###   Verify we can use this pod like we did in docker container earlier:

1.   **Configure components for IAM Profiles:**

  ```bash
 export AWS_PROFILE=SBFE_sb250
 export AWS_DEFAULT_REGION=us-east-1
 export AWS_REGION=us-east-1

 aws-azure-login --no-sandbox --profile SBFE_sb250
  ```

2.    It will prompt you for your Azure AD Password.

3.    It will prompt you for a code from your 2-factor authentication device.

4.    If all works without error, you can see that it creates a new file with credentials here:  
 		  `cat ~/.aws/credentials`

5.    Test that it is working with a sample aws cli command:

  ```
 export AWS_PROFILE=SBFE_sb250
 export AWS_DEFAULT_REGION=us-east-1
 export AWS_REGION=us-east-1
 
 aws s3 ls
  ```
6.   **Sample Output:**
  
  ```
  2024-04-08 12:37:30 aws-athena-query-results-208226632548-us-east-1
2022-11-03 15:14:32 cf-templates-1kwe6ecrr19x1-us-east-1
2024-04-22 14:19:03 datadogintegration-forwarderstack--forwarderbucket-d008l9a3gziu
2024-03-26 05:13:06 lacework-ct-bucket-b66b86f9
2024-03-26 05:13:06 lacework-ct-bucket-b66b86f9-access-logs
2022-11-03 15:17:19 laceworkcloudsecurity-laceworklogs-gxg2spjfyvy7
2023-07-03 15:05:10 sb-251-cdp-private-etl-migration-svc
2022-10-28 20:37:32 sb250-cdp-private-default-g9hzvc5
2022-10-28 20:37:16 sb250-cdp-public-default-g9hzvc5
2024-06-07 19:37:07 sb250-cloudtrail-generalpurpose
2022-11-03 15:17:44 sb250-laceworkcws-547a
2022-10-28 21:18:02 sb251-cdp-private-default-8x2hqpc
2024-10-21 19:38:55 sb251-cdp-public-datalake-backup
2022-10-28 21:17:45 sb251-cdp-public-default-8x2hqpc
2024-10-21 20:00:34 sb251-datalake-public-backup-bucket-use2
2022-12-22 16:16:33 sb252-cdp-private-default-3vbwqeh
2022-12-22 16:16:25 sb252-cdp-public-default-3vbwqeh
2023-12-29 17:28:58 terraform-airflow-sbfe
2023-04-27 16:37:24 tfstate-208226632548
  ```




**Exit the container from k8s:** `exit`

---
---

### Test that data is being persisted to our PVC by deleting the POD

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

