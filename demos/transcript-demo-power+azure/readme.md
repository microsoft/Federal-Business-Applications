# Overview
This demo is designed to illustrate the "better together" story of Azure + Power Platform.  The demo includes a canvas app that allows users to upload an audio file and then transcribe the audio and then edit the transcription (e.g. to fix discrepancies). Under the "hood", the solution leverages Power Automate flows to connect to Azure Blob Storage and Azure Speech Services to store and transcribe the audio respectively.  The final output is then stored in Dataverse.

![canvas app - main screen](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/80570fa5-7517-4e8c-8ece-fad400505d01)

# Contents
- [Release Notes](#release-notes)
- [Installation Guide](installation-guide.md)
- [Supported Clouds](#supported-clouds)
- [What's in the solution?](#whats-in-the-solution)
- [Limitations](#limitations)
- [Security and Protecting Keys](#security-and-protecting-keys)
- [User Guide](user-guide.md)
- [Developer Guide](developer-guide.md)

***

## Release Notes
| Version | Release Date | Change Log |
| :------ | :---------- | :--------- |
| 1.0.1.0 | 3/21/2024 | - | 
| 1.0.2.20 | 7/1/2024 | - Added GPT generated transcript summary (requires Generative AI enabled in environment) <br> - Added downloadable PDF transcript <br> - Removed SharePoint list dependency. App now uploades directly to Azure Blob Storage <br> - Other minor changes to UI/UX|

## Supported Clouds
This demo was built in a GCC-High tenant.  If you are using a GCC tenant, note that you will need an Azure Gov subscription to connect directly to [Azure Blob Storage](https://powerautomate.microsoft.com/en-us/connectors/details/shared_azureblob/azure-blob-storage/) and [Azure Speech to Text](https://powerautomate.microsoft.com/en-us/connectors/details/shared_cognitiveservicesspe/azure-batch-speech-to-text/) from Power Apps and Power Automate via the out of the box (OOTB) connectors.  There is a workaround described [here](https://github.com/microsoft/Federal-Business-Applications/wiki/PowerApps-Connecting-from-GCC-to-any-Endpoint-including-Commercial-Azure). 

[^ Top](#contents)

## Prerequisites
You must have the following to use this solution:
1. [Power Apps Premium license](https://powerapps.microsoft.com/en-us/pricing/)
2. [Azure Government](https://azure.microsoft.com/en-us/explore/global-infrastructure/government/) Subscription
3. [Azure Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
4. **Two** [Azure Blob Storage Containers](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction) (source for audio and destination for transcripts)
5. [Azure Batch Speech to Text](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/batch-transcription) key
6. [Generative AI Features enabled](https://github.com/microsoft/Federal-Business-Applications/blob/main/whitepapers/copilot/README.md#phase-1-opt-in-with-azure-commercial-azure-openai)
7. SharePoint Site & Document Library
   
[^ Top](#contents)

## What's in the solution?
- Apps
  - Demo Transcript App (Canvas)
  - Demo Transcript Admin App (Model Driven)
- Flows
  - 01 - Power Apps - Upload to Azure Blob
  - 02 - Azure - Create Transcript
    - 02b Child Flow - Loop Until Transcript is Complete
    - 02c Child Flow - Get Transcript Results
    - 02d Child Flow - Parse Transcript and Load into a Dataverse
    - 02e Child Flow - Summarize Transcript
  - PA - Create Transcript Document
- Tables
  - Transcripts
  - Recogonized Phrases
  - Speakers
- Environment Variables - *Note: these will need to be updated on import*
  - SharePoint Site
  - Speech to Text Key
  - Speech to Text Region
  - Azure Blob Destination SAS URL
    - *note: this requires a SAS URI be generated and the container must allow for anonmyous access.  Additional info, and other more secure methods are described [here](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/batch-transcription-create?pivots=rest-api#specify-a-destination-container-url)*
  - Web API Endpoint
  - Azure Blob Storage Source Container
- Web Resources
  - Icons for each table
- Connection References - *Note: these will need to be updated on import*
  - Approvals 
  - Azure Batch Speech to Text
  - Azure Blob Storage
  - Microsoft Dataverse
  - SharePoint
  - One Drive for Business
  - Word Online (Business)

[^ Top](#contents)

## Limitations
As of 3/18/2024, there appears to be some limitatins with what you can do with the OOTB Azure Speech Service Connector and Azure Blob Storage Connector.  As a result, this solution implements two workarounds:
1. The flows connecting to Azure Speech Services (02a-02c) use the [HTTP connector](https://learn.microsoft.com/en-us/training/modules/http-connectors/) to directly reference the [Azure Batch Speech-to-Text API](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/batch-transcription).
2. Because the [Azure Blob Storage trigger](https://learn.microsoft.com/en-us/connectors/azureblob/#triggers) doesn't get triggered by the creation of files in a subfolder, this solution uses a loop to wait for the transcription to be completed in flow 02b.

[^ Top](#contents)

## Security and Protecting Keys
This solution is **NOT** intended for production or senstive data. If you intend to use this, please replace the environment variable Speech to Text Key (which is an unencrypted text string) into an Secret envrionment variable (leveraging Azure Key Vault). For more check out this: [Use environment variables for Azure Key Vault secrets](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables-azure-key-vault-secrets)

[^ Top](#contents)
***




