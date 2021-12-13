# Populating Dataverse with ArcGIS Feature Service Data

## Overview

This document will describe one method of using Microsoft Power Automate to query the ArcGIS Feature Service REST API and load the resulting data into a Dataverse table.  It assumes the reader is comfortable with querying the ArcGIS REST API and with creating Flows in Power Automate.  Further information on the ArcGIS REST API can be found in the [ArcGIS REST API Documentation](https://developers.arcgis.com/rest/).  Further information on Power Automate can be found in the [Power Automate Documentation](https://docs.microsoft.com/en-us/power-automate/).

The document describes the process in three parts.
#### Obtain an OAUTH 2.0 authentication token from the ArcGIS web service.  
An OAUTH 2.0 token is required to access secured ArcGIS resources.  As of this writing, the default lifespan of the ArcGIS OAUTH 2.0 tokens is two hours with a configurable maximum lifespan of two weeks.  In order to make sure our flow has a valid token, we will ensure that the flow obtains a new token automatically each time it runs.  The API calls for this part of the process are outlined in the [ArcGIS Token API documentation](https://developers.arcgis.com/labs/rest/get-an-access-token/).

#### Connect to the Feature Service and query Feature attributes.  
We will connect to the ArcGIS Feature Service sample endpoint and return an array of Features.  For each Feature, we will return the following attributes:  TRL_NAME, ELEV_FT, CITY_JUR, PARK_NAME, and FID, and load them into a Dataverse Table.  The API calls for this part of the process are outlined in the [ArcGIS Feature Layer API Documentation](https://developers.arcgis.com/labs/rest/query-a-feature-layer/).

#### Load Epoch data Types from ArcGIS into the Common Data Service.
The ArcGIS Feature Service can return dates in Epoch format (number of milliseconds since 1/1/1970).  [Epoch format details](https://en.wikipedia.org/wiki/Unix_time).  These data types may need to be converted before being loaded into a Dataverse Table.  This document will discuss strategies for loading Epoch data types.

## Prerequisites

### ArcGIS Developer Account
To complete the first section, you will need an ArcGIS Developer account.  If you do not have one, you can create an ArcGIS Developer account at the [ArcGIS Developer Signup Page](https://developers.arcgis.com/sign-up/)

### ArcGIS Application
To complete the second section, you will need to have a registered Application in ArcGIS.  If you do not have an Application you can create one by following steps 1-4 in the [ArcGIS Documentation](https://developers.arcgis.com/labs/rest/get-an-access-token/)

### Create a Table to Store Data
We will query the service for information about trails.  To store this information, create an Table called ArcGIS in Dataverse with the custom fields below.  Note that the Primary Name field should be TRL_NAME:

| Field Name | Data Type |
| --------- | :---: |
| TRL_NAME | Text |
| CITY_JUR | Text |
| ELEV_FT | Whole Number |
| FID | Whole Number |
| PARK_NAME | Text |

![Dataverse Fields](files/1.png)

## Step by Step Example  

1.	To obtain an OAUTH 2.0 token, you will need the Client ID and Client Secret for your Application.  These can be found in the OAUTH 2.0 area of your Dashboard as shown in the screenshot below. 

![ArcGIS Application](files/2.png)

2.	In the Power Apps Maker portal, create a new Instant Cloud Flow. 

![Instant Cloud Flow](files/3.png)
