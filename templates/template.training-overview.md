---
Title:  Learning Kubernetes - Useful Information.
Author:  Tim Lepple
Last Updated:  12.10.2024
Comments:  
Tags:  Kubernetes | K8s | Docker | Helm | Ubuntu
---


---
---

# K8 Items we will cover:

---
---

## What is a `Storage Class`, a `Persistent Volume` a `Persistent Volume Claim` and a `Namespace`

---
---

### 1. **Storage Class (SC)**

A **Storage Class** in Kubernetes defines the type of storage to be provisioned dynamically within a cluster. It provides an abstraction for storage configurations, such as storage type (e.g., SSD, HDD), provisioning parameters, and access modes. When a PersistentVolumeClaim (PVC) requests storage, the Storage Class determines how and where the storage should be created. This allows users to specify the "class" of storage they need without having to know underlying infrastructure details.

- **Key Features**:
  - Defines storage properties (e.g., provisioned capacity, I/O performance)
  - Enables dynamic provisioning of storage based on PVCs
  - Allows storage resources to be automatically created and reclaimed as needed

### 2. **Persistent Volume (PV)**

A **Persistent Volume (PV)** represents a piece of storage in a Kubernetes cluster that has been provisioned by an administrator or dynamically through a Storage Class. PVs are cluster resources that remain independent of any specific pod, meaning they persist data even if pods are deleted or moved. PVs are used to store data that needs to be retained across container restarts, and they support various types of storage backends, such as network file systems, cloud storage, and local disks.

- **Key Features**:
  - Represents actual storage with defined access modes (e.g., ReadWriteOnce, ReadWriteMany)
  - Has a lifecycle independent of pods
  - Can be statically or dynamically provisioned

### 3. **Persistent Volume Claim (PVC)**

A **Persistent Volume Claim (PVC)** is a request for storage by a user. PVCs specify requirements, such as storage size and access mode, and Kubernetes uses this information to bind the PVC to an appropriate Persistent Volume (PV) that meets the criteria. The PVC essentially "claims" the storage, making it available for use within a pod. PVCs allow users to manage their storage needs declaratively, enabling Kubernetes to handle storage allocation and provisioning automatically.

- **Key Features**:
  - Requests specific storage characteristics (size, access mode)
  - Binds to a suitable PV to make storage available to pods
  - Enables seamless data persistence across pod lifecycles



### 4. **Namespace**

A **Namespace** in Kubernetes is a virtual cluster or logical partition within a physical Kubernetes cluster. Namespaces provide a way to divide cluster resources among multiple users or teams, isolating resources and configurations to avoid conflicts and support resource organization and management. This separation is especially useful in large environments where different teams or projects need their own environments within a single shared Kubernetes cluster.

- **Purpose**:
  - Organizes resources into logical groups, making them easier to manage.
  - Supports resource isolation, allowing each namespace to have its own services, configurations, and permissions.
  - Enables resource quotas and limits, helping control the amount of resources (CPU, memory, etc.) each namespace can use.
  
- **Key Features**:
  - Namespaces are **isolated** by default, with resources (like services and PersistentVolumeClaims) scoped within each namespace.
  - Pods, services, and other resources can communicate across namespaces when allowed, using qualified resource names (`service-name.namespace-name`).
  - Namespaces help enforce role-based access control (RBAC) and other security configurations, supporting multi-tenancy.

* Namespaces are ideal for managing environments like development, staging, and production within a single Kubernetes cluster or organizing resources by team or application type.


---
---

### Use a Storage Class of type `efs-sc`

---

A **Kubernetes StorageClass** type of `"efs-sc"` refers to a StorageClass used for provisioning **Amazon EFS (Elastic File System)** volumes dynamically within a Kubernetes cluster running on AWS, such as **EKS (Elastic Kubernetes Service)**. **Amazon EFS** provides a fully managed, scalable, shared file system for use with cloud resources, and in Kubernetes, it enables Pods to mount a shared filesystem that can persist across restarts and can be accessed by multiple Pods at the same time.

### Key Concepts:
1. **Amazon EFS (Elastic File System)**:
   - EFS is an NFS (Network File System) based storage service offered by AWS.
   - It supports concurrent access from multiple Kubernetes Pods, EC2 instances, or other resources.
   - EFS scales automatically to accommodate growing storage needs.
   - Ideal for workloads that require shared, persistent storage like content management systems, home directories, or shared data among multiple Pods.

2. **Kubernetes StorageClass**:
   - A **StorageClass** in Kubernetes defines the "class" of storage to be used when dynamically provisioning persistent volumes (PVs).
   - StorageClasses specify provisioners (like AWS EFS), parameters, and reclaim policies for dynamically created PersistentVolumes.
   - The StorageClass named `"efs-sc"` is typically used for provisioning Amazon EFS-backed PersistentVolumes.

### How `efs-sc` Works in Kubernetes: (This has already been installed for us)

1. **EFS CSI Driver**:
   - To use **Amazon EFS** with Kubernetes, you must install the **EFS CSI (Container Storage Interface) driver** in your EKS cluster.
   - The **EFS CSI driver** allows Kubernetes to interface with Amazon EFS and dynamically create and manage EFS-based PersistentVolumes.
   - Once installed, you can create a `StorageClass` like `"efs-sc"` to dynamically provision EFS-backed storage for your Pods.

2. **StorageClass Configuration (`efs-sc`)**:
   - A StorageClass named `"efs-sc"` typically defines EFS-specific parameters like the file system ID.
   - It uses the EFS CSI driver as the provisioner.
   - Here’s an example of a StorageClass definition for EFS:
     
     ```yaml
     apiVersion: storage.k8s.io/v1
     kind: StorageClass
     metadata:
       name: efs-sc
     provisioner: efs.csi.aws.com
     parameters:
       fileSystemId: fs-12345678   # Your EFS file system ID here
       directoryPerms: "700"       # Optional: Permissions for the root directory
     reclaimPolicy: Retain
     volumeBindingMode: Immediate
     ```

   - **Key Fields**:
     - `provisioner`: The EFS CSI driver (`efs.csi.aws.com`) is used to dynamically create PVs.
     - `fileSystemId`: This is the ID of the EFS file system in AWS that Kubernetes will use.
     - `directoryPerms`: Optional, but it can set the permissions for the root directory of the EFS volume.
     - `reclaimPolicy`: Defines whether the volume should be deleted or retained when a PersistentVolumeClaim (PVC) is deleted. In this case, it's set to `Retain` to keep the data even after the PVC is deleted.
     - `volumeBindingMode`: When set to `Immediate`, the volume is created immediately when the PVC is created.

3. **PersistentVolumeClaim (PVC)**:
   - After the StorageClass is set up, you can create a **PersistentVolumeClaim (PVC)** that will dynamically provision a PersistentVolume backed by EFS.
   - Here’s an example of a PVC using the `"efs-sc"` StorageClass:
     
     
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: efs-claim-tim
  namespace: tim
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: efs-sc
  resources:
    requests:
      storage: 1Gi  # EFS scales automatically, but you specify a size for your PVC
```

   - **Key Fields**:
     - `accessModes`: Specifies how the volume can be accessed. **Amazon EFS** supports `ReadWriteMany` (multiple Pods can read and write concurrently).
     - `storageClassName`: This is set to `efs-sc` to use the StorageClass you created for EFS.
     - `resources.requests.storage`: Even though EFS is auto-scaling, this defines the amount of space you want to request for the PVC. This value doesn't limit the size of the file system.

4. **Mounting the PVC in a Pod**:
   - Once the PVC is created, you can mount it into a Pod to provide persistent, shared storage to the containers in that Pod.
   - Here’s an example of how you would mount the EFS-backed PVC into a Pod:
     
     ```yaml
     apiVersion: v1
     kind: Pod
     metadata:
       name: efs-app
     spec:
       containers:
       - name: app
         image: nginx
         volumeMounts:
         - name: efs-volume
           mountPath: /usr/share/nginx/html
       volumes:
       - name: efs-volume
         persistentVolumeClaim:
           claimName: efs-claim-tim  # The PVC created above
     ```

   - **Key Fields**:
     - `volumeMounts`: This defines where the EFS volume will be mounted inside the container (in this case, `/usr/share/nginx/html`).
     - `volumes.persistentVolumeClaim.claimName`: References the PVC (`efs-claim-tim`) that is backed by EFS.

### Why Use EFS with Kubernetes?
- **Shared Storage**: EFS allows multiple Pods to read and write to the same storage, which is ideal for shared storage use cases.
- **Elastic Scaling**: EFS automatically scales as the amount of data grows, so you don’t need to pre-provision storage size.
- **Durable and Highly Available**: EFS is regionally resilient, storing data across multiple Availability Zones, ensuring durability and availability.

### Common Use Cases:
- **Shared Files**: Applications that need shared file storage across multiple Pods or even across multiple nodes, such as content management systems or collaboration tools.
- **Home Directories**: Storing user-specific data that needs to persist across sessions.
- **Persistent Application Data**: Storing data that needs to persist even when the application Pod is recreated or scaled.

### Considerations:
- **Performance**: EFS has different performance modes (General Purpose and Max I/O) that affect throughput and latency. For high IOPS workloads, other storage solutions like Amazon EBS might be more suitable.
- **Cost**: EFS is generally more expensive than other AWS storage services like EBS due to its fully managed nature and multi-AZ resilience.
- **Network File System (NFS)**: EFS is based on NFS, which is not the fastest compared to block storage (like EBS). For read-heavy or write-heavy workloads requiring low latency, EBS might be better.

### Summary:
- **StorageClass `efs-sc`**: Used to provision Amazon EFS-backed PersistentVolumes in Kubernetes.
- **EFS CSI Driver**: Required to interface Kubernetes with Amazon EFS.
- **Shared File System**: EFS provides a shared, persistent storage solution that can be accessed by multiple Pods concurrently.
- **Use Cases**: Ideal for shared file storage, persistent application data, and elastic file systems in AWS-based Kubernetes clusters (EKS).

By using `"efs-sc"`, you enable dynamic provisioning of EFS storage for your Kubernetes workloads, providing scalable, durable, and shared storage for applications running in EKS.


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

