# US Government Power Platform / D365 Architecture

## US Government Specific Documentation

* [Power Automate US Government Docs](https://docs.microsoft.com/en-us/power-automate/us-govt)
* [Power Apps US Government Docs](https://docs.microsoft.com/en-us/power-platform/admin/powerapps-us-government)
* [D365 US Government Docs](https://docs.microsoft.com/en-us/power-platform/admin/microsoft-dynamics-365-government)

## US Government Cloud Video Recordings
Below is a presentation recording covering US Gov Cloud specific architecture of Power Platform and D365 at a Meetup group talk.  The video recording can be found below,

[Power Platform / D365 US Government Cloud Overview](https://www.youtube.com/watch?v=027gVhqt1l0&t=101s)

There's also a great video that overviews all of Microsoft's Sovereign Clouds,

[Microsoft Sovereign Clouds - Power CAT Live](https://www.youtube.com/watch?v=DMg3uQ5EFLI)

## US Government Cloud Offerings

![Gov Cloud Overview](files/Slide1.PNG)

## GCC Architecture
![GCC Overview](files/Slide2.PNG)

### Azure Commerical vs Azure for Government in GCC

For GCC customers, you have the option of using Azure Commerical or Azure for Government subscriptions.  Today, the GCC Power Platform service will assume that the resources you want to use are only Azure for Government resources.

![GCC Connectors](files/Slide5.PNG)

A work around to leverage Azure Commerical resources from Power Platform GCC is to create a Azure Logic App in Azure Commerical and use that with the commerical connectors to get access to the resources you want to leverage,

![GCC Connector Work Around](files/Slide6.PNG)

Today, you have the option with the SQL Server connector in GCC to togggle between Azure for Government or Azure Commerical.  This will eventually make its way to other Azure connectors in Power Platform GCC as well.

![GCC SQL Server Connector](files/Slide7.PNG)

## GCC High Architecture
![GCC High Overview](files/Slide3.PNG)

## DOD Architecture
![DOD Overview](files/Slide4.PNG)
