# User Guide
There are two apps in this solution: a canvas app for end users and a model-driven app for developers and admins

## Contents
- [Demo Transcript App (canvas app)](#demo-transcript-app-canvas-app)
  - [Upload Audio File](#upload-audio-file)
  - [View Transcript](#view-transcript)
  - [Edit Transcript](#edit-transcript)
  - [Identify/Assign Speaker](#identify-assign-apeaker)
- [Demo Transcript Admin App (model driven)](#demo-transcript-admin-app-model-driven)


[← Back to Read Me](readme.md)

***

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

### View Transcript
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

#### Edit Transcript
Click the **Edit** button.  You can now update any of the text in the transcript text box.  After you make the changes, click **Save**

### Identify/Assign Speaker
If you'd like to replace the speaker number with the name of the speaker, select the speaker name from the dropdown.  If the name isn't list, click New Speaker button and fill out the **Name** field and click **Save**

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/7f3e495c-a2c9-429e-8e6a-e368373439a3)

After assigning the speaker click **Save**.  A pop-up will appear:

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/3fed044e-bdbd-4801-9165-21f19755fd37)

If you want to update every instance of the speaker number with the selected speaker, click **Yes**. Otherwise, click **No**. If you click **Yes**, it will take a little longer to save the changes.

[^ Top](#contents)
***

## Demo Transcript Admin App (model driven)

The other app exists mostly for developers, but might also prove useful for admins.  It gives you access to all three tables and the ability to view the additional metadata captured by Azure Speech to Text. 
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/c88bdb6f-4f18-45b9-b4cb-d8b0b4dd7560)

[^ Top](#contents)
