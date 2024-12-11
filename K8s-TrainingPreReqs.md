A user needs to create their own PAT for secure authentication when accessing `Nexus One Repos` 

1. **Log in to Azure DevOps**:
   - The user logs in to [Azure DevOps](https://dev.azure.com/Nexus-One/NX1%20Special%20Projects/) with their `NexusOne` credentials.

2. **Navigate to the Repos and find the repo --> `aws_ad_auth` and choose the 3 elipses to the right of the name and choose `Clone`**:
   - This will pop-up a new window called `Clone Repository`.  Click the `Generate Git Credentials` button.
   - Save the `Username` and `Password` to a file.  The token is displayed only once. The user should copy it immediately and store it securely (e.g., in a password manager).  [RepoLink-aws-ad-auth](https://dev.azure.com/Nexus-One/NX1%20Special%20Projects/_git/aws_ad_auth)
   - This credential will be used multiple times in this exercise
 

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

1. **SSH into the host** `ssh <your email username>@ops-docker.cloudera-cdp.com`
2. **Create a directory** for assets used in this training `mkdir -p ~/docker/compose/<YOUR NAMESPACE HERE>`
3. **Change to this new directory** `cd ~/docker/compose/<YOUR NAMESPACE HERE>`
4. **Clone Repo with Training Materials** 
	```git clone https://github.com/tlepple/k8-training-workshop.git```

5. **Change to our new directory**	
	```
	cd ~/docker/compose/<YOUR NAMESPACE HERE>/k8-training-workshop
	```
6.  **Make the script executable:**
        ```
    chmod 0700 ~/docker/compose/<YOUR NAMESPACE HERE>/k8-training-workshop/setup_output_files.sh
	```
7. **Execute Script** - This will date the code tailored to you for the rest of the workshop.
	```
	. ~/docker/compose/<YOUR NAMESPACE HERE>/k8-training-workshop/setup_output_files.sh <YOUR NAMESPACE HERE>
	```

---

# **Configure Azure CLI connection** from Docker server.

 ```
cd ~
az login 
 ```

 *  This will return output similar to this:

 ```
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code <your specfic code>  to authenticate.
 ```
7.  Authenticate to Azure AD:   
    1. Open a chrome browser on your host and give it the URL `https://microsoft.com/devicelogin`.   
    2. It will ask you to enter the code: `<your specfic code>`.   
    3. From here you will select your Microsoft AD `Nexus-One` email account.  Example: `<your nexus one email address>`
    4. Then click the `Continue` button from the next screen.
    5. In the returned output choose `1` which should be associated with Tenant `NexusCognitive`

8.  **Configure `azure ad cli` to use our Projects Folder in Azure DevOps**

   ```bash
   az devops configure --defaults organization=https://dev.azure.com/Nexus-One project="NX1 Special Projects"
   ```

---

9.  **Create a new repo in Azure DevOps for this project:**
```bash
az repos create --name <YOUR NAMESPACE HERE>-k8-training-workshop
```
10.  **Configure Git CLI tools**
```bash

cd ~/docker/compose/<YOUR NAMESPACE HERE>/k8-training-workshop/output
git credential-cache exit

git config --global credential.helper manager-core

git config --global user.name "<YOUR NEXUS USERNAME>"
git config --global user.email <YOUR NEXUS EMAIL ADDRESS>
```
11.  **Validate your username is set correctly**
```bash
git config --get credential.helper
```

12.  **Expected Output:**
```bash
<YOUR NEXUS USERNAME>
```
13.  **Setup our local repo that will push to remote repo:**
```bash
git init
git branch -m main
```

14.  **Add and push items to our new repo:**
```bash
git add *.md
git commit -m "Initial commit markdown docs"
```

15.  **Validate the branch is set:**
```bash
git branch
```

16.  **Expected Output:**
```bash
* main
```
17.  **Set our remote branch stuff:**
```bash
git remote add origin https://Nexus-One@dev.azure.com/Nexus-One/NX1%20Special%20Projects/_git/<YOUR NAMESPACE HERE>-k8-training-workshop
```
18. **Validate the remote url:**
    ```bash
    git remote -v
    ```
     
19.  **Push these items into our new repo:**
```bash
git push -u origin main
```
20.  **This will prompt you for a password, give it your Azure DevOps PAT we set earlier:**

21.  **Open Azure DevOps** in your browser and navigate to `URL Here`
