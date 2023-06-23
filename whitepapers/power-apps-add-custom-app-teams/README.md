# Add to Teams Workaround for GCC 
In commercial tenants, there is [an “Add to Teams” menu option](https://powerapps.microsoft.com/en-us/blog/add-your-canvas-apps-to-microsoft-teams/) to easily add a Power App to Microsoft Teams.  

<img src="https://powerappsblogscdn.azureedge.net/wp-content/uploads/2021/05/side-panel.png" alt="Add to Teams side panel" width="500px">

This “easy button” is not available in the US government clouds today (as of June 2023). This document outlines the steps to follow to add canvas app as an app in Teams that can be used by users in your tenant.

# Requirements
You will need necessary permissions to upload an app to your tenant.  For more on the required permissions see [Manage custom and side-loaded app policies and settings](https://learn.microsoft.com/en-us/microsoftteams/teams-custom-app-policies-and-settings)

This will only work for GCC tenants. As of today (June 2023), side loading apps in Teams is not supported in GCC-High, DoD or higher. 

This document assumes you already have a canvas app ready to be published to Microsoft Teams. You will need the App URL located on the app’s details page. 

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/e1e82293-d748-445f-9daf-cc7af837a57a" alt="Screenshot of Power Apps example canvas app's Details Screen with the Web Link indicated with a red arrow" width="500px">

For more on creating a canvas app, see [What are canvas apps?](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/getting-started)

# Steps
1. [Create Teams App Package](#create-teams-app-package)
   - [Create Icons](#create-icons)
   - [Create App Manifest](#create-app-manifest)
   - [Tip: Use Developer Portal](#tip-use-developer-portal)
3. [Before you publish](#before-you-publish)
4. [Publish App](#publish-app)
   - [Option 1: "Side Loading"](#option-1-side-loading)
   - [Option 2: Publish to Your Org](#option-2-publish-to-your-org)






# Create Teams App Package
Before you can publish a canvas app to teams, you must “wrap” the app in a Teams app package.

A Teams app package has two components:
*	App Manifest
*	App Icons

## Create Icons
You’ll need two icons

### Color Icon
The color version of your icon displays in most Teams scenarios and must be 192x192 pixels. Your icon symbol (96x96 pixels) can be any color, but it must sit on a solid or fully transparent square background.

Teams automatically crops your icon to display a square with rounded corners in multiple scenarios and a hexagonal shape in bot scenarios. To crop the symbol without losing any detail, include 48 pixels of padding around your symbol.

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/f11a46b9-8c13-4b1e-aa7a-ab03bcd9eaca" alt="Image of the color icon with dimesniosn indicated along with examples of how the icon is dispalyed in various parts of Microsoft Teams" width="500px">

### Outline icon
An outline icon displays in two scenarios:
* When your app is in use and “hoisted” on the app bar on the left side of Teams.
* When a user pins your app's message extension.
  
The icon must be 32x32 pixels. It can be white with a transparent background or transparent with a white background (no other colors are permitted). The outline icon should not have any extra padding around the symbol.

<img  alt="Image of the the outline icon with dimensions indicated and exmaples of how the icon appears in Microsoft Teams" src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/3f583831-5be4-43a5-8c5d-aeaba621d9a4" width="500px">

For more, see [App Icons](https://learn.microsoft.com/en-us/microsoftteams/platform/concepts/build-and-test/apps-package#app-icons)

[Back to top](#steps)

## Create App Manifest
The App Manifest is a JSON file that describes how your app is configured, including its capabilities, required resources, and other important attributes.

Here is the latest schema: [Manifest schema reference](https://learn.microsoft.com/en-us/microsoftteams/platform/resources/schema/manifest-schema)

Here is an example of the Manifest JSON:
```
{
    "$schema": "https://developer.microsoft.com/en-us/json-schemas/teams/v1.16/MicrosoftTeams.schema.json",
    "version": "1.0.0",
    "manifestVersion": "1.16",
    "id": "3011e0d5-51e9-4cf5-bbf6-b891ad87c96f",
    "packageName": "com.package.name",
    "name": {
        "short": "JWR Test App",
        "full": "JWR Test App for Documentation"
    },
    "developer": {
        "name": "Microsoft Federal",
        "mpnId": "",
        "websiteUrl": "https://www.microsoft.com",
        "privacyUrl": "https://privacy.microsoft.com/en-us/privacystatement",
        "termsOfUseUrl": "https://www.microsoft.com/en-us/legal/terms-of-use"
    },
    "description": {
        "short": "App used to help with documentation ",
        "full": "This app exists to help me document the process of publishing a canvas app to Teams (when the \"Add to Teams\" button is not available)"
    },
    "icons": {
        "outline": "outline.png",
        "color": "color.png"
    },
    "accentColor": "#FFFFFF",
    "staticTabs": [
        {
            "entityId": "ce251a7e-37ac-4898-afb8-ae1c64eaca25",
            "name": "JWR Test App",
            "contentUrl": "https://apps.gov.powerapps.us/play/e/[ENVIRONMENT GUID]/a/[APP GUID]tenantId=[TENANT GUID]",
            "scopes": [
                "personal"
            ]
        },
        {
            "entityId": "about",
            "scopes": [
                "personal"
            ]
        }
    ],
    "validDomains": [
        "apps.gov.powerapps.us"
    ]
}
```
[Back to top](#steps)

## Tip: Use Developer Portal
While you can create the app package manually, we recommend using the Developer Portal app in Teams.  Note: as of June 2023, the Developer Portal is listed as GCC Beta.  It may or may not be available in your tenant depending on your administrator’s settings. 

To get started, Add the Developer Portal (if not already installed) For more see: [Add an app to Microsoft Teams](https://support.microsoft.com/en-us/office/add-an-app-to-microsoft-teams-b2217706-f7ed-4e64-8e96-c413afd02f77)

Open Developer Portal and Click **+ New app**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/05e4a470-61ec-4b0c-9d99-fe7f166b9031" alt="Screenshot of Microsoft Teams Developer Portal app with +New app button indicated with a red arrow" width="500px">

Next give the app a name

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/3f04f29b-9f9c-49e1-a559-317ec449e02e" alt="Screenshot of Microsoft Teams Add app dialog" width="500px">

Next, fill in the fields.  

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/671392c8-91c4-4323-a889-db10cc80b4ea" alt="Screenshot of Microsoft Teams Developer Portal Basic Information tab" width="500px">

The following are required:
*	**Short Name** (defaults to what you typed on the previous screen)
*	**Short Description**
*	**Long Description**
*	**Developer Information**
*	**Website**
*	**Privacy Policy URL**
*	**Terms of Service URL**
  
Then click on **Branding** and attach the two icons and select Accent color

<img alt="Screenshot of Microsoft Teams Developer Portal with Branding tab indicated with a red arrow"  src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/b1d5adb7-021c-43f5-a736-aebef37a4503" width="500px">

Then click **App features** and select **Personal App**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/35bb11ec-fa2d-4c0e-93bd-512fc73bb16a" alt="Screenshot of Microsoft Teams Developer Portal App features tab with Personal app button indicated with a red arrow" width="500px">

Then click **Create your first personal app tab**

<img alt="Screenshot of the Create your first personal app tab button"  src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/b5260a0e-84b5-4c36-bcb5-5b7abb67d8fa" width="500px">

Fill in the required fields.  Tip: Paste the app URL copied from Power Apps details page for **Content URL** and click **Confirm**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/c433562c-9b65-477d-9218-8ba075312a42" alt="Screenshot of the form to Add a tab to your personal app" width="500px">

Then click **Save**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/3926e25f-02b6-4fc8-80ef-929f1fe9b27d" alt="Screenshot of Microft Teams Personal app screen with Save button indicated with a red arrow" width="500px">

[Back to top](#steps)

# Before you publish
Use the built in validation tool to confirm the app is ready to be published.
On the **Dashboard**, in Team store validation, click **View details** 

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/dbf40a00-06f6-4d0e-a200-dcfb0eb6535e" alt="Screenshot of Microsoft Teams Developer Portal app Dashboard Teams Store validation tile">

Address any errors and warnings before downloading the package

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/f5fb20cc-158c-4d6e-9d04-49cf2f1cee35" alt="Scrreenshot of the details screen with three errors listed" width="500px">

Use the App submission checklist then click Download app package

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/24a6df38-8be1-4374-8358-b2769d121095" alt="Screenshot of the App submission checklist indicated with a red outline and an arrow indicating the Download app packaged button" width="500px">

[Back to top](#steps)

# Publish App
Below are two different methods to publishing your app in Microsoft Teams. 
* **[Option 1](#option-1-side-loading):** *"Side Loading"* is useful if the app is for you or a small number of people (e.g. your team)
* **[Option 2](#option-2-publish-to-your-org):** *Publish to Your Org* allows you to make your app available in the Teams store for your entire organization. **This requires a Teams Admin approval**.

If you don't have the necessary permissions to publish the app yourself, your Teams Administrator can do it from the Teams Admin center.  Click here for more details: [Publish a custom app by uploading an app package](https://learn.microsoft.com/en-us/microsoftteams/upload-custom-apps)

## Option 1: "Side Loading"

Click **Apps** on the left rail, then click **Manage your Apps**, then click **Upload App**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/60245531-fbbe-4259-8dfc-5f667e9da870" alt="Screenshot of Microsoft Teams with Apps button on left rail indicated with a red arrow and the Upload an app button indicated with a red arrow" width="500px">

Click **Upload a custom app**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/73cd762a-fb77-4ac3-a739-0bb2f166ad96" alt="Screenshot of the pop-up Upload an app dialog with two buttons. The Upload a custom app button is indicated with a red arrow">

Select Zip file
Confirm details are correct and click **Add**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/3b343b8b-1915-4ba9-a3f6-e25f219f9398" alt="Screenshot of the app details with the Add button" width="500px">

Wait a few moments and then the app should load. Note: the **About** tab is created automatically. 

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/1ade0751-ac44-42fd-aba9-5264a93db801" alt="Screenshot of the app loaded into teams" width="500px">

For more see [Upload your custom app](https://learn.microsoft.com/en-us/microsoftteams/platform/concepts/deploy-and-publish/apps-upload)

[Back to top](#steps)

## Option 2: Publish to Your Org

If you’d like your app to be available to your entire organization, you can submit it for approval and when it’s approved, it will appear in the Built for your org section of the Teams App Store:

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/037a1d29-938d-498f-b281-1349822dd823" alt="Screenshot of Microsoft Teams with the Built in your org tab indicated with a red arrow">

Click **Apps** and then click **Upload an app**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/60245531-fbbe-4259-8dfc-5f667e9da870" alt="Screenshot of Microsoft Teams with Apps button on left rail indicated with a red arrow and the Upload an app button indicated with a red arrow" width="500px">

Click **Submit an app to your org**

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/dee6a35a-c351-429b-b626-10844f11a54e" alt="Screenshot of the pop-up Upload an app dialog with two buttons. The Submit an app to your org button is indicated with a red arrow" width="500px">

Choose the Zip file
If successful, you should see the following confirmation pop-up

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/74f139a5-99a1-4ca1-983f-db54ce869619" alt="Screenshot of the success pop-up with the View your requests button">

Click **View your requests** to see your request and monitor it’s progress

<img src="https://github.com/microsoft/Federal-Business-Applications/assets/12347531/cce53ded-9f7a-4f07-a4d1-e3883f19bbff" alt="Screenshot of your pending requests">

At this point, your Teams Admin will need to approve (or reject) your app.  We strongly recommend working with your Teams Admin before, during and after the upload process to ensure as smooth deployment.

For more see: [User requests for admins](https://learn.microsoft.com/en-us/MicrosoftTeams/user-requests-approve-apps)

[Back to top](#steps)
