# User Guide
There are two apps in this solution: a canvas app for end users and a model-driven app for developers and admins

## Contents
- [Demo Transcript App (canvas app)](#demo-transcript-app-canvas-app)
  - [Upload Audio File](#upload-audio-file)
  - [View Transcript](#view-transcript)
  - [Edit Transcript](#edit-transcript)
  - [Identify/Assign Speaker](#identify-assign-apeaker)
- [Demo Transcript Admin App (model driven)](#demo-transcript-admin-app-model-driven)


[← Back to Read Me](readme.md#contents)

***

## Demo Transcript App (canvas app)
This app is designed to let users upload an audio file, then edit the subsquent transcript that is generated.  

[^ Top](#contents)

### Upload Audio File
To get started, upload click the attachment control

![image](https://github.com/user-attachments/assets/acc8c6eb-48b8-46ce-8992-77817582fd2a)

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

Next, enter how many speakers are in the recording.  Azure Speech to Text services can diarize up to 36 speakers, but you need to tell hit how many to expect for the service to work well.  

Once selected, click **Upload**.  The audio file is then uploaded as an attachment to a new item in your SharePoint list.  *Note: this is only required due to current [limitations](#limitations) with Azure Blob Storage connector in Power Apps.*

Behind the scenes, Power Automate executes a series of flows to generate the transcript (via Azure Batch Speech to Text services) and then load the transcript into Dataverse. This can take 30-60 minutes depending on the length of the audio file. 

[^ Top](#contents)

### View Transcript
After the transcript is loaded into Dataverse, the transcript will appear in the app on the right hand side. You may need to refresh the app to see the latest data. 

![Screenshot of the Transcript Demo main screen with available transcripts to view/edit](https://github.com/user-attachments/assets/ef4f7de4-47b0-45db-a5b3-f5664fd1c383)

Click the **Details** button for the transcript you'd like to view/edit

This takes you to the next screen.  

![image](https://github.com/user-attachments/assets/feb2bc91-5aa1-41b3-a83a-0934e6d6e82b)

There are three tabs:
- Summary
- Playback
- Transcript (PDF)

#### Summary

This is the AI generated summary of the transcript.  Always review any GPT created text for errors. If you want to update the summary, click Edit and make changes, then click Save to store those changes.

![image](https://github.com/user-attachments/assets/fc0baa2b-f751-4736-aa62-a79dec48048e)


Click **Save** to store changes or **Cancel** to clear any changes. 

#### Playback
Click this tab to playback the audio file and view the transcript created by Azure Speech to Text services.


Click the play button to start audio playback.  As the audio plays, the current phrase will appear and update to nmatch the playhead's time code.

![image](https://github.com/user-attachments/assets/c96cf728-4671-41b4-b82f-4851baf705f4)

To navigate to a specific point in the audio file, you can use the gallery on the left and select the phrase. You can also use the playhead to scrub forwards or backwards.  There are also two buttons that let you go to the **In Point** or **Out Point** of the current phrase. Lastly, there is the **Jump To**: field that you can enter a specific time code (in HH:MM:SS).  



[^ Top](#contents)

#### Edit Transcript
If you want to edit the current phrase or update/add the speaker, click **Edit**. 

![image](https://github.com/user-attachments/assets/e80d9a83-cae5-46e2-aa91-ec65e937a05d)

There two things you can edit:
1. Text of the current phrase
2. Identify/Assign speaker

##### Edit Current Phrase
You can now update any of the text in the transcript text box.  After you make the changes, click **Save**

##### Identify/Assign Speaker
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
