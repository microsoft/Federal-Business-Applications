# Installation Guide
There are two versions of the solution: managed and unmanaged.  We **strongly** recommend you use the managed version if importing into an existing environment with other solutions.  If you want to customize the solution, you can use the unmanaged version or you can import that managed version and use an unmanaged solution to store your customiations.

Which ever version you use, the steps are basically the same:

1. Go to your environment
2. Click **Solutions**
3. Click **Import Solution**
4. Click **Browse** and select the file (managed or unmanaged)
5. Click **Next**
6. You will be prompted to update the connections. If none exist, you will need to create them.  
   ![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/ba369542-a53c-4ee3-a64f-28eb82500351)

7. When setting up the Azure Blob Storage connection, please set the follow parameters  
   ![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/d2d558ca-c3d6-4c4c-8f89-3519d198b1e2)

  - **Authentication type**: Access Key (Azure Government)
  - **Azure Storage account name or blob endpoint**: Azure storage account name
  - **Azure Storage Account Access Key**: Azure atorage acount access key 
8. After configuring all connections there should be a green check box next to each one
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/37ba1855-70d1-45e5-b93b-514526188e00)
9. Click **Next**
10. You will then be prompted to update the environment variables:
    ![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/3a1d53c3-8de9-4b21-9d38-7a0fb2197eb5)
    - **Speech to Text Region**: The Azure location/region used by the Azure Batch Speech to Text services
    - **Speech to Text Key**: The key for the Azure Batch Speech to Text service
    - **SharePoint Site**: The site where the SharePoint list is located
    - **SharePoint List**: SharePoint list used to temporarily store the audio file as an attachment
    - **Azure Blob Destination SAS URL**:  The SAS URL for the container the the transcripts go into.  _Note: this SAS URL must be configured for anonymous access and have write/create priviledges._
11. Click **Import**

The import process takes a few minutes.  

You may get an warning: 
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/b6e3caaa-875a-49e0-b78c-6c18c5af9aa9)
If you do, you will need to go into the solution and turn on the parent flow (02 - Azure - When Audio File Created in Blob Storage - Create Transcript).  This bug may be addressed in further releases. 



