# Integrate Microsoft Forms with Power BI in US Gov Clouds

There is a great YouTube video that shows how you can easily create a Power BI report off of O365 Forms data.

[Easiest Way to Get Microsoft Forms Data in Power BI](https://www.youtube.com/watch?v=HupBVO1P8_M)

This video, only shows how to do this for a Commerical O365 tenant.  You can do the exact same process in the US Sovereign clouds as well.  You just need to replace the commerical endpoint referenced in the video with the following for the specific US Gov Cloud endpoints.

Also make sure that you get the actual Forms id that will replace the text "<ACTUAL_FORM_ID_GOES_HERE>"

### GCC
```
https://forms.office.com/formapi/DownloadExcelFile.ashx?formid=<ACTUAL_FORM_ID_GOES_HERE>&timezoneOffset=240&minResponseId=1&maxResponseId=1000
```
### GCC High
```
https://forms.osi.office365.us/formapi/DownloadExcelFile.ashx?formid=<ACTUAL_FORM_ID_GOES_HERE>&timezoneOffset=240&minResponseId=1&maxResponseId=1000
```
### DOD
```
https://forms.osi.apps.mil/formapi/DownloadExcelFile.ashx?formid=<ACTUAL_FORM_ID_GOES_HERE>&timezoneOffset=240&minResponseId=1&maxResponseId=1000
```
