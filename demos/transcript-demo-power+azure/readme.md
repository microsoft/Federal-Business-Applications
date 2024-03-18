# Overview
This demo is designed to illustrate the "better together" story of Azure + Power Platform.  The demo includes a canvas app that allows users to upload an audio file (MP3 or WAV) and then transcribe the audio and then edit the transcription (e.g. to fix discrepancies). Under the "hood", the solution leverages Power Automate flows to connect to Azure Blob Storage and Azure Speech Services to store and transcribe the audio respectively.  The final output is then stored in Dataverse.


![canvas app - main screen](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/45514b7e-ab60-4daa-95a6-cd227f1a45f0)

## Supported Clouds
This demo was built in a GCC-High tenant.  If you are using a GCC tenant, note that you will need an Azure Gov subscription to connect directly to [Azure Blob Storage](https://powerautomate.microsoft.com/en-us/connectors/details/shared_azureblob/azure-blob-storage/) and [Azure Speech to Text](https://powerautomate.microsoft.com/en-us/connectors/details/shared_cognitiveservicesspe/azure-batch-speech-to-text/) from Power Apps and Power Automate via the out of the box connectors.  There is a workaround described [here](https://github.com/microsoft/Federal-Business-Applications/wiki/PowerApps-Connecting-from-GCC-to-any-Endpoint-including-Commercial-Azure). 

## Prerequisites
You must have the following to use this solution:
1. Power Apps Premium license
2. Azure Government Subscription
3. Azure Storage Account + Azure Blob Storage Container
5. Azure Speech to Text
6. SharePoint List with attachments enabled

## What's in the solution?
- Apps
  - Demo Transcript App (Canvas)
  - Demo Transcript Admin App (Model Driven)
- Flows
  - 01 - SPO - When Audio File Uploaded to SPO - Copy to Azure Blob
  - 02 - Azure - When Audio File Created in Blob Storage - Create Transcript
    - 02a Child Flow - Create Transcription (HTTP)
    - 02b Child Flow - Loop Until Transcript is Complete
    - 02c Child Flow - Get Transcript Results
    - 02d Child Flow - Parse Transcript and Load into a Dataverse
- Tables
  - Transcripts
  - Recogonized Phrases
  - Transcript
- Environment Variables - Note: these will need to be updated on import
  - SharePoint Site
  - SharePoint List
  - Speech to Text Key
  - Speech to Text Region
 
