# Installation Guide

## Word Template
Before you setup the solution, you must first load the Word template into a SharePoint document libray. You'll need to know the SharePoint site before importing the solution. 

## Import Solution

There are two versions of the solution: managed and unmanaged.  We **strongly** recommend you use the managed version if importing into an existing environment with other solutions.  If you want to customize the solution, you can use the unmanaged version or you can import that managed version and use an unmanaged solution to store your customizations.

Which ever version you use, the steps are basically the same:

1. Go to your environment
2. Click **Solutions**
3. Click **Import Solution**
4. Click **Browse** and select the file (managed or unmanaged)
5. Click **Next**
6. You will be prompted to update the connections. If none exist, you will need to create them.
   ![Screenshot of Power Apps Import a solution form](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/58f375fe-b9b8-412c-b682-49ef2d724554)

8. When setting up the Azure Blob Storage connection, please set the follow parameters  
   ![Screenshot of the Azure Blob Storge connection configuration prompt](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/d2d558ca-c3d6-4c4c-8f89-3519d198b1e2)

  - **Authentication type**: Access Key (Azure Government)
  - **Azure Storage account name or blob endpoint**: Azure storage account name
  - **Azure Storage Account Access Key**: Azure atorage acount access key 
8. After configuring all connections there should be a green check box next to each one
![Screenshot of the connections authenticated successfully](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/ad0d5703-6adc-4bbd-8464-616cc5a1b3fe)

9. Click **Next**
10. You will then be prompted to update the environment variables:
    ![Screenshot of environment variables](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/449875e2-5a36-4e97-9f12-bd2b204fb47e)

    - **Azure Speech to Text Region**: The Azure location/region used by the Azure Batch Speech to Text services
    - **Azure Speech to Text Key**: The key for the Azure Batch Speech to Text service
    - **Azure Blob Storage Source Container**: Path to the container that will receive the audio files
       - **Azure Blob Destination SAS URL**:  The SAS URL for the container the the transcripts go into.  <br>_Note: this SAS URL must be configured for anonymous access and have write/create priviledges._
    - **SharePoint Site**: The site where the Word document template is located
    - **Web API Endpoint**: For Databverse Web API calls
    
12. Click **Import**

The import process takes a few minutes.  

## Update Flow with Word Template

Due to limitations with the Word connector, you must hard code the Word template into the [PA - Create Transcript Document](developer-guide.md#pa---create-transcript-document) flow
Edit the flow and update the **Document Library** and **File** parameters

![image](https://github.com/user-attachments/assets/ac2bedd1-fe3d-485c-96dc-327607a69c52)

[▲ Top](#installation-guide)

[← Back to Read Me](readme.md)

