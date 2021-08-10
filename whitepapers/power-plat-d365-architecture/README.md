# US Government Power Platform / D365 Architecture

We recorded a presentation covering US Gov Cloud specific architecture of Power Platform and D365 at a Meetup group talk.  The video recording can be found below,

https://www.youtube.com/watch?v=027gVhqt1l0&t=101s

![Gov Cloud Overview](files/Slide1.PNG)

## GCC
![GCC Overview](files/Slide2.PNG)

For GCC customers, you have the option of using Azure Commerical or Azure for Government subscriptions.  Today, the GCC Power Platform service will assume that the resources you want to use are only Azure for Government resources.

![GCC Connectors](files/Slide5.PNG)

A work around to leverage Azure Commerical resources from Power Platform GCC is to create a Azure Logic App in Azure Commerical and use that with the commerical connectors to get access to the resources you want to leverage,

![GCC Connector Work Around](files/Slide6.PNG)

Today, you have the option with the SQL Server connector in GCC to togggle between Azure for Government or Azure Commerical.  This will eventually make its way to other Azure connectors in Power Platform GCC as well.

![GCC SQL Server Connector](files/Slide7.PNG)

## GCC High
![GCC High Overview](files/Slide3.PNG)

## DOD
![DOD Overview](files/Slide4.PNG)
