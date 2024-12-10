A user needs to create their own PAT for secure authentication when accessing `Nexus One Repos` 

1. **Log in to Azure DevOps**:
   - The user logs in to [Azure DevOps](https://dev.azure.com/Nexus-One/NX1%20Special%20Projects/) with their `NexusOne` credentials.

2. **Navigate to the Repos and find the repo --> `aws_ad_auth` and choose the 3 elipses to the right of the name and choose `Clone`**:
   - This will pop-up a new window called `Clone Repository`.  Click the `Generate Git Credentials` button.
   - Save the `Username` and `Password` to a file.  The token is displayed only once. The user should copy it immediately and store it securely (e.g., in a password manager).  [RepoLink-aws-ad-auth](https://dev.azure.com/Nexus-One/NX1%20Special%20Projects/_git/aws_ad_auth)
 

---
---

## Request PIMs

- Request the pim `CDP-Linux-Admin`
- Request the pim `CDPOne-AWS Operations Full`
- Request the pim `NexusOneFullAccess_nx1poc`
- Request the pim `Customer-SBFE Full`


---

## Setup our Training Assets

---

##### Connect into OPS Docker Server

1. **SSH into the host** `ssh tlepple@ops-docker.cloudera-cdp.com`
2. **Create a directory** for assets used in this training `mkdir -p ~/docker/compose/<YOUR NAMESPACE HERE>`
3. **Change to this new directory** `cd ~/docker/compose/<YOUR NAMESPACE HERE>`
4. **Clone Repo with Training Materials** 
	```git clone https://github.com/tlepple/k8-training-workshop.git```

5. **Change to our new directory**	
	```
	cd ~/docker/compose/<YOUR NAMESPACE HERE>/k8-training-workshop
	```
6. **Update the code with some personal credentials**	
	```
	. ~/docker/compose/<YOUR NAMESPACE HERE>/k8-training-workshop/setup_output_files.sh <YOUR NAMESPACE HERE>
	```

---

