# Overview
This demo is designed to illustrate the "better together" story of Azure + Power Platform.  The demo includes a canvas app that allows users to upload an audio file (MP3 or WAV) and then transcribe the audio and then edit the transcription (e.g. to fix discrepancies). Under the "hood", the solution leverages Power Automate flows to connect to Azure Blob Storage and Azure Speech Services to store and transcribe the audio respectively.  The final output is then stored in Dataverse.


![canvas app - main screen](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/45514b7e-ab60-4daa-95a6-cd227f1a45f0)

# Contents
- [Supported Clouds](#supported-clouds)
- [What's in the solution?](#whats-in-the-solution)
- [Limitations](#limitations)
- [Security and Protecting Keys](#security-and-protecting-keys)
- [User Guide](user-guid.md)
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

[^ Top](#contents)
***
# Developer Guide

This section will cover how the solution works.

## Demo Transcript app (canvas)
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/60e1f755-59e2-4748-b463-d7b5233b9846)

### App Properties & Settings
Several settings and properties were changed.  Note that any preview features should **not** be used for production apps. 

**Display -> Scale To Fit**  
Set to off to allow for responsive resizing. Recommend if different form factors maybe used by users (e.g. phone, tablet, laptop)  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/0478df24-4d16-491d-955d-f353d21ae58d)

**General -> Modern controls and themes**  
Set to on to allow for modern controls/themes in the app.  Note that some modern controls are in GA and others are still in preview at this time.   
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/608b1497-841b-4e9b-bbd6-79c6b5c062ce)


### Screens
The canvas app has two screens: 
1. Main Screen
2. Transcript Demo Screen

Both screens use containers to help control the flow of the controls when resizing the app for different resolutions.  Their layouts are based on the Sidebar screen template.

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/1ba43b2a-0c9e-4413-a5f2-f9153b7716f4)

### Main Screen

#### Properties

**OnVisible**: When the screen loads, several global variables are set:
- **glbShowSuccess**: Used to show/hide the Success message when upload is completed
- **glbSelectedFileName**: Stores the file name of the selected file
- **glbSelectedTranscript**: Stores the selected transcript from from the left hand gallery (galTranscripts_Main)
- **glbCurrentPhrase**: Used on the next screen, to identify the current recogonized phrase based on the current playback point in the audio controller
- **glbMode**: Used on the next screen to toggle between Edit and View display modes via the **Edit** Button
  
#### Controls
**frmUpload**:  
The form is connected to the SharePoint list. In my demo, it's a simple list with only one field, **Title**.  Some of properties have been updated:  
- **DefaultMode**: ```FormMode.New```
- **OnSuccess**: *When the form successfully creates the SPO list item, THEN run three functions concurrently (to improve performance)*
  ```
  Concurrent(
    //Hide the loading spinner
    Set(
        glbShowSpinner,
        false
    ),
    //Show the success message
    Set(
        glbShowSuccess,
        true
    ),
    //Reset the upload form
    ResetForm(frmUpload)
   )
   ```
- **Width**: ```Parent.Width ```

**Title_DataCard**: _This card is hidden and updated via variable (set by **attFileToUpload**)._
- **Default**: ```glbSelectedFileName```
- **Visible**: ```false```

**attFileToUpload**: This control has several properties that have been customized:
- **AccesibleLabel**: ``` "File to attach (upload) and transcribe" ```
- **AddAttachmentText**: ```"Select file"```
- **Color**:  _This changes color to red if selected file is not MP3 or WAV_
  ```
  If(
    Right(
        First(Self.Attachments).Name,
        3
    ) = "mp3" Or Right(
        First(Self.Attachments).Name,
        3
    ) = "wav",
    Color.Black,
    IsEmpty(Self.Attachments),
    Color.Black,
    Color.Red
   )
  ```
- **Height**: ```100```
- **MaxAttachments**: ```1```
   - _If you want to allow for batch uploads, increase this option, but performance may suffer for larger files. Also some other parts of the solution may need to be refactored if you allow more than 1 file at a time_
- **MaxAttachmentSize**: ```1000```
   - _In MB_
- **MaxAttachmentText**: *This code does some basic data validation to check if the selected file is MP3 or WAV* 
  ```
  If(
    Right(
        First(Self.Attachments).Name,
        3
    ) = "mp3" Or Right(
        First(Self.Attachments).Name,
        3
    ) = "wav",
    "File Selected. Please click Upload",
    "Error:  Only .mp3 and .wav file formats are supported"
   )
  ```
- **NoAttachmentsText**: ```"There is nothing selected."```
- **OnAddFile**: *Stores the first selected file in a variable. IF you allow for more than one attachment, you'll need to refactor this*
```
   Set(
    glbSelectedFileName,
    First(attFileToUpload.Attachments).Name
   )
  ```
- **OnRemoveFile**: *Clears the variable*
  ```
  Set(
    glbSelectedFileName,
    Blank()
   )
   ```
**btnUploadFile_Main**: Used to upload the selected file to SPO list.  
- **AccessibleLabel**: ```"Upload the selected file"```
- **DisplayMode**: _Default mode disabled. Only enabled (Edit mode) when attachment is selected and file is MP3 or WAV_
  ```
   If(
    IsEmpty(attFileToUpload.Attachments),
    DisplayMode.Disabled,
    Right(First(attFileToUpload.Attachments).Name,3) = "mp3" Or Right(First(attFileToUpload.Attachments).Name,3) = "wav",
    DisplayMode.Edit,
    DisplayMode.Disabled
   )
  ```
- **OnSelect**: _When clicked, shows the loading spinner and submits the form to SPO list_
   ```
   // Show the loading spinner
   Set(
       glbShowSpinner,
       true
   );
   //Submit the form (frmUpload) to upload file to SharePoint list
   SubmitForm(frmUpload)
   ```
- **Text**: ```"Upload"```

**btnCancelUpload_Main**: Clears the form (frmUpload)
- **OnSelect**: ```ResetForm(frmUpload)```
- **Text**: ```"Cancel"```

**galTranscripts_Main**: 
Displays **all** the available transcripts in the Transcripts table. Some properties were customized:
- **AccessibleLabel**: ```"All the available transcripts to review/edit"```
- **Items**: ```Transcripts```
- **OnSelect**: _When item is selected, store a copy of the **Recognized Phrases** for the selected transcript in a collection (**colPhrases**) and sort the collection in acensinding order by the '**Offset in Seconds**', then go to the **Transcript Demo Screen**_  
   ```
   ClearCollect(
       colPhrases,
       SortByColumns(
           Filter(
               'Recognized Phrases',
               Transcript.Transcript = ThisItem.Transcript
           ),
           "demo_offsetinseconds",
           SortOrder.Ascending
       )
   );
   //Store the currently selected transcript in a global variable
   Set(
       glbSelectedTranscript,
       ThisItem
   );
   //Navigate to the Transcript Demo Screen
   Navigate('Transcript Demo Screen')
   ```
- **Width**: ```Parent.Width-Parent.PaddingLeft*2```

### Transcript Demo Screen
This screen has several containers. Some of these are used to for pop-up windows, while most are used to structure the controls.  

#### Controls

**contSpinnerBg**: Contains the loading spinner and is only visible when **glbShowSpinner** = true  
**contPopUpUpdateAllSpeakersBg**: Is only visible when **gblShowPopUpUpdateAllSpeakers** = true  
**contPopUpAddSpeaker**: Only visible when **glbShowPopUpAddSpeaker** = true 

**timerTranscript**:   
Used to update variables based on the playhead of the audio control (**audRecordingPlayback**). Some of the properties have been customized:
- **Duration**: _This is in milliseconds. 1000 = 1 second_  
  ```1000```
- **OnTimerEnd**: _Every second, update the current phrase (glbCurrentPhrase)_
  ```
   Set(
       glbCurrentPhrase,
       LookUp(
           ShowColumns(
               colPhrases,
               "demo_display",
               "demo_offsetinseconds",
               "demo_outset",
               "demo_phrasenumber",
               "demo_speaker",
               "demo_SpeakerLookup",
               "demo_Transcript",
               "demo_recognizedphrasesid",
               "demo_durationinseconds"
           ),
           // Current phrase is between the offset in seconds and the outset
           demo_offsetinseconds <= Trunc(audRecordingPlayback.Time) And demo_outset >= Trunc(audRecordingPlayback.Time)
       )
      )
   ```
- **Repeat**: ```true```
- **Start**: ```glbStartTimer```
- **Visible**: ```false```

**audRecordingPlayback**  
Used to playback the original audio (stored in Azure Blob Storage)
- **Media**: ```glbSelectedTranscript.'Source URL'```
- **DisplayMode**: _If user is editing the current phrase, disable this so they can't move the playhead (and change the current phrase)_
  ```
  If(
    glbMode = DisplayMode.Edit,
    DisplayMode.Disabled,
    DisplayMode.Edit
   )
   ```
- **Fill**: ```PowerAppsTheme.Colors.Primary```
   - Note: PowerAppsTheme is the default theme.  You can replace the default theme with your own. 


