# Click To Dial From D365 Using Teams

This sample shows you how to initiate outbound calling in D365 via Teams using deep links. While most tenants can leverage the Teams integrations being incorporated into the D365 product, there may be scenarios where that capability has not yet been made available in your tenant.

> [!IMPORTANT]
> This solution requires that you have outbound calling enabled for Teams and the appropriate license assigned to your users.

## Solution Steps Overview

    * Create a new solution file
    * Add the Phone Call entity table to the new solution file, including the existing Quick Create form
    * Create a new custom field in the Phone entity table, of type Yes/No 
    * Update the javascript to reference the name of your custom field
    * Add the javascript file as a web resource in your solution file, then add the library to the Quick Create form's OnLoad properties
    * Add the new custom field to the Quick Create form, and assign the initiatePhoneCallWindow function to the OnChange event
    * Save and Publish All Customizations 

## Create a new solution file

From the [PowerApps Portal](https://make.powerapps.com/), create a new solution file in your environment.

## Add the Phone Call entity

From within your solution file, select "Add Existing" -> "Table".

![add phone entity step 1](files/images/addExistingTable1.jpg)

Select the Phone Call entity

![add phone entity step 2](files/images/addExistingTable2.jpg)

Click the option for "Select Components", click Forms, and select the "Quick Create" form.

![add phone entity step 3](files/images/addExistingTable3.jpg)
![add phone entity step 4](files/images/addExistingTable4.jpg)

## Add a custom column to the Phone Call

Within the solution file you created, select the Phone Call entity that you just added, and choose the option to add a column.
Note the developer prefix associated with your publisher, as you will need this in the following step. Set the data type to "Yes/No" so you can use the default dropdown or toggle controls.

![add a new custom column](files/images/addNewColumn.jpg)

## Update your javascript

The [Javascript Library](https://github.com/microsoft/Federal-Business-Applications/blob/main/demos/d365-click-to-dial-teams/files/DialFromTeams.js) will need to be updated to include your custom property.
Update the following line in the code, so that the name of your custom property is placed between the quotation marks.
 (The name should use the publisherPrefix_propertyName syntax)

```javascript
# var callFromTeams = formContext.getAttribute("").getValue();
```

## Add your javascript file as a web resource

With the solution file, select New->Other->Web Resource.

![add web resource step 1](files/images/addNewWebResource.jpg)
![add web resource step 2](files/images/addNewWebResource2.jpg)

## Update the Quick Create form

Within your solution file, select the Quick Create form, and configure the OnLoad event of the form so that it references your javascript library

![update form step 1](files/images/updateForm1.jpg)

Place the new custom field on the form, and configure the OnChange event. Ensure that the "Pass execution context as first parameter" is checked. Then Save and Publish all customizations.

![update form step 2](files/images/updateForm2.jpg)
