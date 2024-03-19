# Overview
This demo is designed to illustrate the "better together" story of Azure + Power Platform.  The demo includes a canvas app that allows users to upload an audio file (MP3 or WAV) and then transcribe the audio and then edit the transcription (e.g. to fix discrepancies). Under the "hood", the solution leverages Power Automate flows to connect to Azure Blob Storage and Azure Speech Services to store and transcribe the audio respectively.  The final output is then stored in Dataverse.


![canvas app - main screen](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/45514b7e-ab60-4daa-95a6-cd227f1a45f0)

# Contents
- [Supported Clouds](#supported-clouds)
- [What's in the solution?](#whats-in-the-solution)
- [Limitations](#limitations)
- [Security and Protecting Keys](#security-and-protecting-keys)
- [User Guide](#user-guide)
- [Developer Guide](#developer-guide)

***

## Supported Clouds
This demo was built in a GCC-High tenant.  If you are using a GCC tenant, note that you will need an Azure Gov subscription to connect directly to [Azure Blob Storage](https://powerautomate.microsoft.com/en-us/connectors/details/shared_azureblob/azure-blob-storage/) and [Azure Speech to Text](https://powerautomate.microsoft.com/en-us/connectors/details/shared_cognitiveservicesspe/azure-batch-speech-to-text/) from Power Apps and Power Automate via the out of the box (OOTB) connectors.  There is a workaround described [here](https://github.com/microsoft/Federal-Business-Applications/wiki/PowerApps-Connecting-from-GCC-to-any-Endpoint-including-Commercial-Azure). 

[^ Top](#contents)

## Prerequisites
You must have the following to use this solution:
1. Power Apps Premium license
2. Azure Government Subscription
3. Azure Storage Account
4. **Two** Azure Blob Storage Containers (source for audio and destination for transcripts)
5. Azure Batch Speech to Text key
6. SharePoint List with attachments enabled
   
[^ Top](#contents)

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
- Environment Variables - *Note: these will need to be updated on import*
  - SharePoint Site
  - SharePoint List
  - Speech to Text Key
  - Speech to Text Region
  - Azure Blob Destination SAS URL
    - *note: this requires a SAS URI be generated and the container must allow for anonmyous access.  Additional info, and other more secure methods are described [here](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/batch-transcription-create?pivots=rest-api#specify-a-destination-container-url)*
- Web Resources
  - Icons for each table
- Connection References - *Note: these will need to be updated on import*
  - Azure Batch Speech to Text
  - Azure Blob Storage
  - Microsoft Dataverse
  - SharePoint

[^ Top](#contents)

## Limitations
As of 3/18/2024, there appears to be some limitatins with what you can do with the OOTB Azure Speech Service Connector and Azure Blob Storage Connector.  As a result, this solution implements two workarounds:
1. The flows connecting to Azure Speech Services (02a-02c) use the HTTP connector to directly reference the [Azure Batch Speech-to-Text API](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/batch-transcription).
2. Because the [Azure Blob Storage trigger](https://learn.microsoft.com/en-us/connectors/azureblob/#triggers) doesn't get triggered by the creation of files in a subfolder, this solution uses a loop to wait for the transcription to be completed in flow 02b.

[^ Top](#contents)

## Security and Protecting Keys
This solution is **NOT** intended for production or senstive data. If you intend to use this, please replace the environment variable Speech to Text Key (which is an unencrypted text string) into an Secret envrionment variable (leveraging Azure Key Vault). For more check out this: [Use environment variables for Azure Key Vault secrets](https://learn.microsoft.com/en-us/power-apps/maker/data-platform/environmentvariables-azure-key-vault-secrets)

[^ Top](#contents)
***
# User Guide
There are two apps in this solution: a canvas app for end users and a model-driven app for developers and admins

[^ Top](#contents)

## Demo Transcript App (canvas app)
This app is designed to let users upload an audio file, then edit the subsquent transcript that is generated.  

[^ Top](#contents)

### Upload Audio File
To get started, upload click the attachment control
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/54e6defe-62f3-4476-9769-014f2420029e)

Please select MP3 or WAV file.  Note: this demo oly supports these two formats, but [Azure Batch Speech to Text supports the following formats](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/batch-transcription-audio-data?tabs=portal#supported-audio-formats-and-codecs):
- WAV
- MP3
- OPUS/OGG
- FLAC
- WMA
- AAC
- ALAW in WAV container
- MULAW in WAV container
- AMR
- WebM
- M4A
- SPEEX

Once selected, click **Upload**.  The audio file is then uploaded as an attachment to a new item in your SharePoint list.  *Note: this is only required due to current [limitations](#limitations) with Azure Blob Storage connector in Power Apps.*

Behind the scenes, Power Automate executes a series of flows to generate the transcript (via Azure Batch Speech to Text services) and then load the transcript into Dataverse

[^ Top](#contents)

### View/Edit Transcript
After the transcript is loaded into Dataverse, the transcript will appear in the app on the left hand side. You may need to refresh the app to see the latest data. 

Click the transcript you'd like to view/edit

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/a6eefbc0-8ef4-4db9-b7e4-db8a455d7960)

This takes you to the next screen.  Click the play button to start audio playback.  As the audio plays, the current phrase will appear and update to nmatch the playhead's time code.

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/bbc37e6e-8995-4667-b214-2a24a8833757)

There two things you can edit:
1. Text of the current phrase
2. Identify/Assign speaker

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/9558df96-cbab-4ce4-bbe2-4cdffd920f1a)

[^ Top](#contents)

#### Edit Transcript Text
Click the **Edit** button.  You can now update any of the text in the transcript text box.  After you make the changes, click **Save**

### Identify/Assign Speaker
If you'd like to replace the speaker number with the name of the speaker, select the speaker name from the dropdown.  If the name isn't list, click New Speaker button and fill out the **Name** field and click **Save**

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/7f3e495c-a2c9-429e-8e6a-e368373439a3)

After assigning the speaker click **Save**.  A pop-up will appear:

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/3fed044e-bdbd-4801-9165-21f19755fd37)

If you want to update every instance of the speaker number with the selected speaker, click **Yes**. Otherwise, click **No**. If you click **Yes**, it will take a little longer to save the changes.

## Demo Transcript Admin App (model driven)

The other app exists mostly for developers, but might also prove useful for admins.  It gives you access to all three tables and the ability to view the additional metadata captured by Azure Speech to Text. 
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/c88bdb6f-4f18-45b9-b4cb-d8b0b4dd7560)

[^ Top](#contents)
***
# Developer Guide

This section will cover how the solution works.

## Demo Transcript app (canvas)
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/60e1f755-59e2-4748-b463-d7b5233b9846)

The canvas app has two screens: 
1. Main Screen
2. Transcript Demo Screen

### Main Screen

**OnVisible**: When the screen loads, several global variables are set:
- glbShowSuccess: Used to show/hide the Success message when upload is completed
- glbSelectedFileName: Stores the file name of the selected file
- glbSelectedTranscript: Stores the selected transcript from from the left hand gallery (galTranscripts_Main)
- glbCurrentPhrase: Used on the next screen, to identify the current recogonized phrase based on the current playback point in the audio controller
- glbMode: Used on the next screen to toggle between Edit and View display modes via the Edit Button 

**frmUpload**: The form is connected to the SharePoint list. In my demo, it's a simple list with only one field, **Title**.  

**attFileToUpload**: When the user selects a file via this control, the 

