# Developer Guide

This document is for developers to help them understand *how* the solution works. Note: not every single control will be detailed.  (e.g. controls like Back buttons will not be explained.)

## Contents
- [Demo Transcript app (canvas)](#Demo-Transcript-app-canvas)
  - [App Properties & Settings](#App-Properties-Settings)
  - [Screens](#Screens)
  - [Main Screen](#main-screen)
    - [Properties](#properties)
    - [Controls](#main-screen-controls)
  - [Transcript Demo Screen](#Transcript-Demo-Screen)
    - [Controls](#controls-1)
- [Flows](#flows)
  - [01 - SPO - When Audio File Uploaded to SPO - Copy to Azure Blob](#01---spo---when-audio-file-uploaded-to-spo---copy-to-azure-blob)
  - [02 - Azure - When Audio File Created in Blob Storage - Create Transcript](#02---azure---when-audio-file-created-in-blob-storage---create-transcript)
  - [02a Child Flow- Create Transcription (HTTP)](#02a-child-flow--create-transcription-http)
  - [02b Child Flow - Loop Until Transcript Complete](#02b-child-flow---loop-until-transcript-complete)
  - [02c Child Flow - Get Transcript Results](#02c-child-flow---get-transcript-results)
  - [02d Child Flow - Parse Transcript and Load into Dataverse](#02d-child-flow---parse-transcript-and-load-into-dataverse)
    
***

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

[^Top](#contents)

### Screens
The canvas app has two screens: 
1. Main Screen
2. Transcript Demo Screen

Both screens use containers to help control the flow of the controls when resizing the app for different resolutions.  Their layouts are based on the Sidebar screen template.

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/1ba43b2a-0c9e-4413-a5f2-f9153b7716f4)

[^Top](#contents)

### Main Screen
This screen is used to upload audio files and select transcripts to view/edit. 
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/09573b6d-538c-4e8a-b49c-3b5d98b92a45)


#### Properties

**OnVisible**: When the screen loads, several global variables are set:
- **glbShowSuccess**: Used to show/hide the Success message when upload is completed
- **glbSelectedFileName**: Stores the file name of the selected file
- **glbSelectedTranscript**: Stores the selected transcript from from the left hand gallery (galTranscripts_Main)
- **glbCurrentPhrase**: Used on the next screen, to identify the current recogonized phrase based on the current playback point in the audio controller
- **glbMode**: Used on the next screen to toggle between Edit and View display modes via the **Edit** Button
  <a name="main-screen-controls">
#### Controls
**frmUpload**:  
The form is connected to the SharePoint list. In my demo, it's a simple list with only one field, **Title**.  Some of properties have been updated:  
- **DefaultMode**: ```FormMode.New```
- **OnSuccess**: When the form successfully creates the SPO list item, THEN run three functions concurrently (to improve performance)
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

**Title_DataCard**: This card is hidden and updated via variable (set by **attFileToUpload**).
- **Default**: ```glbSelectedFileName```
- **Visible**: ```false```

**attFileToUpload**: This control has several properties that have been customized:
- **AccesibleLabel**: ``` "File to attach (upload) and transcribe" ```
- **AddAttachmentText**: ```"Select file"```
- **Color**:  This changes color to red if selected file is not MP3 or WAV
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
   - If you want to allow for batch uploads, increase this option, but performance may suffer for larger files. Also some other parts of the solution may need to be refactored if you allow more than 1 file at a time
- **MaxAttachmentSize**: ```1000```
   - _In MB_
- **MaxAttachmentText**: This code does some basic data validation to check if the selected file is MP3 or WAV 
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
- **OnAddFile**: Stores the first selected file in a variable. IF you allow for more than one attachment, you'll need to refactor this
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
- **DisplayMode**: Default mode disabled. Only enabled (Edit mode) when attachment is selected and file is MP3 or WAV
  ```
   If(
    IsEmpty(attFileToUpload.Attachments),
    DisplayMode.Disabled,
    Right(First(attFileToUpload.Attachments).Name,3) = "mp3" Or Right(First(attFileToUpload.Attachments).Name,3) = "wav",
    DisplayMode.Edit,
    DisplayMode.Disabled
   )
  ```
- **OnSelect**: When clicked, shows the loading spinner and submits the form to SPO list
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
- **OnSelect**: When item is selected, store a copy of the **Recognized Phrases** for the selected transcript in a collection (**colPhrases**) and sort the collection in acensinding order by the '**Offset in Seconds**', then go to the **Transcript Demo Screen**  
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

[^Top](#contents)

### Transcript Demo Screen
This screen has several containers. Some of these are used to for pop-up windows, while most are used to structure the controls.  

![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/63b34025-87b9-4ea2-afd6-b1bff33ca32e)


#### Controls

All controls (except one) are stored in horizontal and vertical containers to allow for responsive design when the user's screen resolution and aspect ratio change.  Briefly, here are the containers and what they do:

- **contSpinnerBg**:  
  Contains the loading spinner and is only visible when **glbShowSpinner** = true  
- **[contPopUpUpdateAllSpeakersBg](#contPopUpUpdateAllSpeakersBg)**:  
  Is only visible when **gblShowPopUpUpdateAllSpeakers** = true  
- **[contPopUpAddSpeaker](#contPopUpAddSpeaker)**:  
  Only visible when **glbShowPopUpAddSpeaker** = true 
- **contMainTranscriptVert**:  
  Contains the main UI for this screen including playback and edit controls

**timerTranscript**:   
Used to update variables based on the playhead of the audio control (**audRecordingPlayback**). Some of the properties have been customized:
- **Duration**: This is in milliseconds. 1000 = 1 second  
  ```1000```
- **OnTimerEnd**: Every second, update the current phrase (glbCurrentPhrase)
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

**The following controls are located inside container(s). The path/location will be indicated in paranthesis.**  

**audRecordingPlayback**  _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/4d4feed5-64ae-4b99-bb2c-9d0fe8815037)

Used to playback the original audio (stored in Azure Blob Storage)
- **Media**: ```glbSelectedTranscript.'Source URL'```
- **DisplayMode**: If user is editing the current phrase, disable this so they can't move the playhead (and change the current phrase)
  ```
  If(
    glbMode = DisplayMode.Edit,
    DisplayMode.Disabled,
    DisplayMode.Edit
   )
   ```
- **Fill**: ```PowerAppsTheme.Colors.Primary```
   - Note: PowerAppsTheme is the default theme.  You can replace the default theme with your own.  
     ![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/05fc98ea-a851-426d-b878-1ca3d53fea08)

 - **Media**: ```glbSelectedTranscript.'Source URL'```
 - **OnEnd**: ```Set(glbStartTimer,false);```
 - **OnPause**: ```Set(glbStartTimer,false);```
 - **OnStart**: ```Set(glbStartTimer,true);```
 - **StartTime**: ```glbJumpToTime```
 - **Width**: ```Parent.Width```

**btnEdit_Transcript** _(contMainTranscriptVert->contFooterTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/21d4b135-ab8f-4761-8b3f-9527367f5cd6)

_Note: only visible when **NOT** in edit mode_
- **AccessibleLabel**: ```"Edit the current phrase"```
- **OnSelect**:
  ```
  Set(
    glbMode,
    DisplayMode.Edit
  )
  ```
- **Text**:```"Edit"```
- **Visible** ```Not(glbMode=DisplayMode.Edit)```

**btnSave_Transcript** _(contMainTranscriptVert->contFooterTranscriptHoriz)_   
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/6b7670e6-c99f-4693-9158-2262df8cd618)

_Note: only visible when in edit mode_  
- **AccessibleLabel**: ```"Save edits to current phrase"```
- **OnSelect** If the user selects a speaker in the dropdown, display Add Speaker Pop Up  
  ```
  If(
      !IsBlank(drpSelectSpeaker_Transcript.Selected),
      Set(
          gblShowPopUpUpdateAllSpeakers,
          true
      ),
      //Otherwise just save changes
      Select(btnSaveHidden)
  );
  ```
- **Text**: ```"Save"```
- **Visible**: ```glbMode=DisplayMode.Edit```

**btnCancel_Transcript**_(contMainTranscriptVert->contFooterTranscriptHoriz)_     
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/c26cdcec-d1a9-494e-b872-d759a875108d)

  _Note: Only visible when in Edit mode_  
- **AccessibleLabel**:```"Cancel the edits to the current phrase"```
- **Appearance**: ```'ButtonCanvas.Appearance'.Outline```
- **OnSelect**: Resets controls and app to View mode
  ```
  Set(
    glbMode,
    DisplayMode.View
  );
  Reset(drpSelectSpeaker_Transcript);
  Reset(txtCurrentPhrase_Transcript)
  ```
- **Text**: ```"Cancel"```
- **Visible**: ```glbMode=DisplayMode.Edit```

**txtCurrentPhrase_Transcript** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/98c3429a-cd78-4f37-b203-525eab121cf1)

- **AccessibleLabel**: ```"Transcript of the current phrase (based current time code)"```
- **DisplayMode**: If variable glbMode is blank, default to View mode
  ```Coalesce(glbMode,DisplayMode.View)```
- **Mode**: ```'TextInputCanvas.Mode'.Multiline```
- **Value**: Get the current phrase based on the current playback position (audRecordingPlayback). Return the first phrase where the current playback time is greater than or equal to the phrase's offset in seconds (i.e. in point) and less than or equal to the outset.
  ```
  LookUp(
    colPhrases,
    'Offset in Seconds' <= Int(audRecordingPlayback.Time) And Outset >= Round(
        audRecordingPlayback.Time,
        2
    )
  ).Display
  ```
- **Width**: ```Parent.Width```

**lblCurrentSpeaker_Transcript** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contSpeakerTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/22d1f4da-33fc-46bc-9526-fd5e9653ae52)

- **Text**: If the speaker dropdown has a selected name, use that. If not, use the value of the speaker name from the current phrase (glbCurrentPhrase). If no name exists, get the speaker value (number) from the current phrase
  ```
  "Speaker: " & Coalesce(
    drpSelectSpeaker_Transcript.Selected.Name,
    glbCurrentPhrase.demo_SpeakerLookup.Name,
    glbCurrentPhrase.demo_speaker
  )
  '''
- **Visible**: ```!IsBlank(glbCurrentPhrase)```

**lblSelectSpeaker_Transcript** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contSpeakerTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/4d0bf4e0-766c-4cb1-ac55-da19173be8c6)

  _Note: only visible when app is in Edit mode_  
- **Align**: ```'TextCanvas.Align'.End```
- **Text**: ```"Select Speaker"```
- **Visible**: ```glbMode=DisplayMode.Edit```

**drpSelectSpeaker_Transcript**  _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contSpeakerTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/8e22e6c4-70e6-4328-8a15-2e41d61326d8)

- **AccessibleLabel**: ```"Select speaker from this drop down"```
- **Items**: ```Filter(Speakers, 'Speakers (Views)'.'Active Speakers')```
- **Visible**: ```glbMode=DisplayMode.Edit```

**icoClearSelectSpeaker_Transcript**  _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contSpeakerTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/c58b5e2f-3201-4899-8fb8-263c48b76709)

  _Note: only visible when speaker is selected in dropdown_  
- **AccessibleLabel**: ```"Clear selected speaker dropdown"```
- **BorderStyle**: ```BorderStyle.None```
- **Color**: ```PowerAppsTheme.Colors.Primary```
- **Fill**: ```ColorValue("#F5F5F5")```
- **Icon**: ```Icon.Cancel```
- **Height**: ```drpSelectSpeaker_Transcript.Height```
- **OnSelect**: ```Reset(drpSelectSpeaker_Transcript)```
- **PaddingTop**: ```10```
- **PaddingBottom**, **PaddingRight**, **PaddingLeft**: ```Self.PaddingTop```
- **Visible**: ```!IsBlank(drpSelectSpeaker_Transcript.Selected)```
- **Width**: ```Self.Height```

**btnNewSpeaker_Transcript** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contSpeakerTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/08151b97-e2bb-404b-9638-b85eed23d579)

- **AccessibleLabel**: ```"Add new speaker"```
- **Appearance**: ```'ButtonCanvas.Appearance'.Subtle```
- **OnSelect**: Show the Add Speaker Pop Up
  ```
  Set(
      glbShowPopUpAddSpeaker,
      true
  )
  ```
- **Text**: ```"+ New Speaker"```
- **Visible**: ```glbMode=DisplayMode.Edit```

**lblSourceFileName_Transcript** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contDetailsTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/465e84fc-d20b-41ea-b3c0-cb8d5c7f876b)

- **FillPortions**: ```4```
- **Text**: ```"Source: " & glbSelectedTranscript.'Source File Name'```

**btnJumpToInPoint** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contDetailsTranscriptHoriz)_    
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/28f01fac-1537-425b-99f8-f7c3c532327f)  

- **AccessibleLabel**: ```"Jump to In Point"```
- **Appearance**: ```'ButtonCanvas.Appearance'.Outline```
- **OnSelect**: ```Set(glbJumpToTime,glbCurrentPhrase.demo_offsetinseconds)```
- **Text**: ```"↦"1```
- **Visible**: ```glbMode=DisplayMode.View```

**lblInPoint_Transcript** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contDetailsTranscriptHoriz)_  
 ![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/483a374f-8295-48de-b13d-a6f060a828ed)  
 - **Text**: Display the current phrase's in point (Offset in Seconds) in HH:MM:SS format
   ```
   " In: " & Text(
    RoundDown(
        glbCurrentPhrase.demo_offsetinseconds / 3600,
        0
    ),
    "00"
    ) & ":" & Text(
        RoundDown(
            If(
                Mod(
                    glbCurrentPhrase.demo_offsetinseconds,
                    3600
                ) > 0,
                Mod(
                    glbCurrentPhrase.demo_offsetinseconds,
                    3600
                ) / 60,
                glbCurrentPhrase.demo_offsetinseconds / 60
            ),
            0
        ),
        "00"
    ) & ":" & Text(
        Mod(
            glbCurrentPhrase.demo_offsetinseconds,
            60
        ),
        "00"
      )
    ```
- **Visible**: ```!IsBlank(glbCurrentPhrase)```
- **Width**: ```120```

**lblOutpoint_Transcript**: _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contDetailsTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/d11bac0b-e3fc-4b3b-8dbf-72ce79db931a)  
- **Align**: ```'TextCanvas.Align'.End```
- **Text**: Display current phrase's out point (outset) in HH:MM:SS
  ```
   "Out: " & Text(
      RoundDown(
          glbCurrentPhrase.demo_outset / 3600,
          0
      ),
      "00"
  ) & ":" & Text(
      RoundDown(
          If(
              Mod(
                  glbCurrentPhrase.demo_outset,
                  3600
              ) > 0,
              Mod(
                  glbCurrentPhrase.demo_outset,
                  3600
              ) / 60,
              glbCurrentPhrase.demo_outset / 60
          ),
          0
      ),
      "00"
  ) & ":" & Text(
      Mod(
          glbCurrentPhrase.demo_outset,
          60
      ),
      "00"
  ) & " "
  ```
- **Visible**: ```!IsBlank(glbCurrentPhrase)```
- **Width**: ```120```

**lblJumpToTime_Transcript** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contDetailsTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/1a360425-3a9f-48af-af57-909b9ed26a7e)  
- **Align**: ```'TextCanvas.Align'.End```
- **FontColor**: If variable glbJumpToTime exceeds the total duration of the audio file, display red text
  ```
  If(
    glbJumpToTime > RoundUp(
        glbSelectedTranscript.Duration,
        0
    ),
    Color.Red,
    Color.Black
  )
  ```
- **Text**: If variable glbJumpToTime exceeds the total duration of the audio file, display error message, otherwise "Jump To"
  ```
  If(
    glbJumpToTime > RoundUp(
        glbSelectedTranscript.Duration,
        0
    ),
    "Cannot exceed total duration ",
    "Jump To "
  )
  ```
**txtJumpToTime_Transcript** _(contMainTranscriptVert->contMainBodyTranscriptHoriz->contMainBodyTranscriptVert->contDetailsTranscriptHoriz)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/d847eef6-59ae-4fa9-bcd6-d2b8efd336d1)  
Allows user to type time code (HH:MM:SS) to jump to part of recording (and transcript)

- **AccessibleLabel**: ```"Type the time you want to jump to (Hours:Minutes:Seconds)"```
- **FontColor**:
  ```
  If(
    glbJumpToTime > RoundUp(
        glbSelectedTranscript.Duration,
        0
    ),
    Color.Red,
    Color.Black
  )
  ```
- **OnChange**: 
  ```
  //If string value doesn't equal 8 (the length of the string 00:00:00), do nothing
  If(
      Len(Self.Value) = 8,
      //Convert string (HH:MM:SS format) into seconds and store in variable glbJumpToTime
      Set(
          glbJumpToTime,
          Value(
              Left(
                  Self.Value,
                  2
              )
          ) * 3600 + Value(
              Mid(
                  Self.Value,
                  4,
                  2
              )
          ) * 60 + Value(
              Right(
                  Self.Value,
                  2
              )
          )
      );
      //Refresh current phrase
      Set(
          glbCurrentPhrase,
          LookUp(
              colPhrases,
          // Current phrase is between the offset in seconds and the outset
              demo_offsetinseconds <= Trunc(audRecordingPlayback.Time) And demo_outset >= Trunc(audRecordingPlayback.Time)
          )
      )
  )
  ```
- **Value**: Display current playback time in HH:MM:SS
  ```
  Text(
      RoundDown(
          audRecordingPlayback.Time / 3600,
          0
      ),
      "00"
  ) & ":" & Text(
      RoundDown(
          audRecordingPlayback.Time / 60,0
      ),
      "00"
  ) & ":" & Text(
      Mod(
          audRecordingPlayback.Time,
          60
      ),
      "00"
  )
  ```
- **Width**: ```100```

<a name="contPopUpAddSpeaker"></a>
**contPopUpAddSpeaker**  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/edbb1d88-5c0b-46b0-9255-ef5f0dceb74e)

Only visible when user clicks + New Speaker button (btnNewSpeaker_Transcript)
- **Fill**: ```RGBA(255, 255, 255, 1)```
- **Height**: ```txtCurrentPhrase_Transcript.Height-10```
- **PaddingLeft**: ```10```
- **PaddingRight**: ```5```
- **PaddingTop**: ```5```
- **Border Radius** (**RadiusBottomLeft**, **RadiusBottomRight**, **RadiusTopLeft**, **RadiusTopRight**): ```20```
- **Visible**: ```glbShowPopUpAddSpeaker```
- **X**: ```contMainBodyTranscriptHoriz.Width+contMainBodyTranscriptHoriz.X-Self.Width```
- **Y**: ```contMainBodyTranscriptHoriz.Y+contSpeakerTranscriptHoriz.Height+5```
  
**frmAddSpeaker** _(contPopUpAddSpeaker)_  
Submits new speaker name to Speakers table  
- **DataSource**: ```Speakers```
- **DefaultMode**: ```FormMode.New```
- **OnSelect**: Reset form and set glbShowPopUpAddSpeaker to false
  ```
  Set(
    glbShowPopUpAddSpeaker,
    false
  );
  ResetForm(frmAddSpeaker)
  ```

**btnAddSpeakerSave** _(contPopUpAddSpeaker->contPopUpAddSpeakerButtons)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/221e4be6-985b-468d-8d2d-be65ae77c297)

- **AccessibleLabel**: ```"Save the new speaker"```
- **DisplayMode**: If Name field is blank, disable button
  ```
  If(
    IsBlank(Name_DataCard_Value.Value),
    DisplayMode.Disabled,
    DisplayMode.Edit
  )
  ```
- **OnSelect**: ```SubmitForm(frmAddSpeaker);```
- **Text**: ```"Save"```

**btnAddSpeakerCancel** _(contPopUpAddSpeaker->contPopUpAddSpeakerButtons)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/f288d3da-a2be-4203-928c-625bb8efc987)
- **AccessibleLabel**: ```"Cancel adding the new speaker"```
- **Appearance**: ```'ButtonCanvas.Appearance'.Secondary```
- **OnSelect**: Reset form and hide the Add New Speaker pop-up
  ```
  Set(
    glbShowPopUpAddSpeaker,
    false
  );
  ResetForm(frmAddSpeaker)
  ```
- **Text**: ```"Cancel"```

**contPopUpUpdateAllSpeakersBg** <a name="contPopUpUpdateAllSpeakersBg"></a>
Full screen container that has an opqaue fill and is only visible when **gblShowPopUpUpdateAllSpeakers** = **true**
- **Fill**: ```RGBA(255, 255, 255, 0.65)```
- **Height**: Parent.Height
- **LayoutAlignItems**: ```LayoutAlignItems.Center```
- **LayoutJustifyContent**: ```LayoutJustifyContent.Center```
- **Visible**: ```gblShowPopUpUpdateAllSpeakers```
- **Width**: ```Parent.Width```


**contPopUpUpdateAllSpeakers** _(contPopUpUpdateAllSpeakersBg)_  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/341528f9-2ae8-46e5-92d5-63041fda8e0a)
- **DropShadow**: ```DropShadow.ExtraBold```
- **Fill**: ```RGBA(255, 255, 255, 1)```
- **Height**: ```Self.Width*.6```
- **LayoutAlignItems**: ```LayoutAlignItems.Center```
- **LayoutJustifyContent**: ```LayoutJustifyContent.Center```
- **Border Radius** (**RadiusBottomLeft**, **RadiusBottomRight**, **RadiusTopLeft**, **RadiusTopRight**): ```25```

**btnPopUpUpdateAllSpeakersYes**  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/5c28730e-97a4-47e8-840c-fec5aa5db699)
- **AccessibleLabel**: Dynamcially update accessible label based on the current phrase and the selected speaker name
  ```
  "Yes - For all the speakers equal to " &
  glbCurrentPhrase.demo_speaker &
  " please update Speaker (Lookup) to  " &
  drpSelectSpeaker_Transcript.Selected.Name
  ```
- **OnSelect**:
  ```
  //If user clicks Yes button
  //THEN hide the Update All Speakers pop-up
  Set(
      gblShowPopUpUpdateAllSpeakers,
      false
  );
  //THEN set flag (glbUpdateAllSpeakers) to true
  Set(
      gblUpdateAllSpeakers,
      true
  );
  //Then select the hidden button (with the actual save formulas)
  Select(btnSaveHidden);
  ```
- **Text**: ```"Yes"```

**btnPopUpUpdateAllSpeakersNo**  
![image](https://github.com/microsoft/Federal-Business-Applications/assets/12347531/d0d07751-9058-4a01-aa02-44ad298e468f)  
- **AccessibleLabel**: ```"Please do not update all speakers to the selected speaker"```
- **Appearance**: ```'ButtonCanvas.Appearance'.Secondary```
- **OnSelect**:
  ```
  //IF user clicks No
  //THEN hide the Update All Speakers pop-up
  Set(
      gblShowPopUpUpdateAllSpeakers,
      false
  );
  //THEN set flag (gblUpdateAllSpeakers) to FALSE
  Set(
      gblUpdateAllSpeakers,
      false
  );
  //Then select the hidden button (with the actual save formulas)
  Select(btnSaveHidden);
  ```
- **Text**: ```"No"```

**btnSaveHidden**  
This button is hidden, but is called by various other buttons.  This is one technique to create reusable code/functions in Power Apps  
- **AccessibleLabel**: ```"This is a hidden control - used for saving the edits to the current phrase"```
- **OnSelect**: 
  ```
  /*
      This section of code is used to update the current recognized phrase.  
      Optionally: if the Speaker was updated, it also can loop through and update all instances of a Speaker Lookup for the selected Speaker. 
      This loop only happens if the user clicks Yes when the Update All Speakers popup appears
  */
  // Show Spinner
  Set(
      glbShowSpinner,
      true
  );
  //Patch the current recognized phrase with contents of the Current Phrase input (txtCurrentPhrase)
  Patch(
      'Recognized Phrases',
      LookUp(
          'Recognized Phrases',
          'Offset in Seconds' <= Int(audRecordingPlayback.Time) And Outset >= Round(
              audRecordingPlayback.Time,
              2
          )
      ),
      {
          Display: txtCurrentPhrase_Transcript.Value,
          'Speaker Lookup': drpSelectSpeaker_Transcript.Selected
      }
  );
  // If user selected "Yes" to Update All Speakers, then loop through and update every phrase record with selected speaker
  If(
      gblUpdateAllSpeakers,
      // Collect all Recognized Phrases that match the current speaker (e.g. 1)
      ClearCollect(
          colUpdateAllPhrasesForSelectedSpeaker,
          Filter(
              'Recognized Phrases',
              Speaker = LookUp(
                  colPhrases,
                  'Offset in Seconds' > Int(audRecordingPlayback.Time) And Outset > Round(
                      audRecordingPlayback.Time,
                      2
                  )
              ).Speaker
          )
      );
      //Then loop through the phrases (colUpdateAllPhrasesForSelectedSpeaker) and update Speaker Lookup to the currently selected speaker (drpSelectSpeaker)
      ForAll(
          colUpdateAllPhrasesForSelectedSpeaker As AllPhrases,
          Patch(
              'Recognized Phrases',
              LookUp(
                  'Recognized Phrases' As CurrentPhrase,
                  CurrentPhrase.'Recognized Phrases' = AllPhrases[@demo_recognizedphrasesid]
              ),
              {'Speaker Lookup': drpSelectSpeaker_Transcript.Selected}
          )
      )
  );
  //Do remaining functions concurrently to save time:
  Concurrent(
  //Reload the Recognized Phrases into a local collection (will playback performance, but will be slow to load for larger Transcripts)
      ClearCollect(
          colPhrases,
          SortByColumns(
              Filter(
                  'Recognized Phrases',
                  Transcript.Transcript = glbSelectedTranscript.Transcript
              ),
              "demo_offsetinseconds",
              SortOrder.Ascending
          )
      ),
  //Refresh Current Phrase (glbCurrentPhrase)
      Set(
          glbCurrentPhrase,
          LookUp(
              ShowColumns(
                  'Recognized Phrases',
                  "demo_display",
                  "demo_durationinseconds",
                  "demo_offsetinseconds",
                  "demo_outset",
                  "demo_phrasenumber",
                  "demo_speaker",
                  "demo_SpeakerLookup",
                  "demo_Transcript",
                  "demo_recognizedphrasesid"
              ),
              demo_offsetinseconds <= Trunc(audRecordingPlayback.Time) And demo_outset >= Trunc(audRecordingPlayback.Time)
          )
      ),
  //Reset variable (glbMode) to View Mode (DisplayMode.View
      Set(
          glbMode,
          DisplayMode.View
      ),
  //Reset Speaker Drop Down
      Reset(drpSelectSpeaker_Transcript)
  );
  //Hide Spinnner
  Set(
      glbShowSpinner,
      false
  );
  ```
- **Visible**: ```false```


[^Top](#contents)


## Flows
[^Top](#contents)
### 01 - SPO - When Audio File Uploaded to SPO - Copy to Azure Blob
[^Top](#contents)
### 02 - Azure - When Audio File Created in Blob Storage - Create Transcript
[^Top](#contents)
### 02a Child Flow- Create Transcription (HTTP)
[^Top](#contents)
### 02b Child Flow - Loop Until Transcript Complete
[^Top](#contents)
### 02c Child Flow - Get Transcript Results
[^Top](#contents)
### 02d Child Flow - Parse Transcript and Load into Dataverse
[^Top](#contents)
