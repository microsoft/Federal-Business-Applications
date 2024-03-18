# Overview
This demo is designed to illustrate the "better together" story of Azure + Power Platform.  The demo includes a canvas app that allows users to upload an audio file (MP3 or WAV) and then transcribe the audio and then edit the transcription (e.g. to fix discrepancies). Under the "hood", the solution leverages Power Automate flows to connect to Azure Blob Storage and Azure Speech Services to store and transcribe the audio respectively.  The final output is then stored in Dataverse.

