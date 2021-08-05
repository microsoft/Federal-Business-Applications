# Signing up for a Power Apps Developer Plan with Government Identities
If you have a .gov or a .mil email address or are using a work account in a GCC, GCC High or DOD cloud environment, you will not be able to sign up for the free Power Apps Developer Plan with those email accounts.  The Power Apps Developer Plan requires using a commerical Azure Active Directory identity to sign up.

If you don't have a commercial work account, follow the steps below to setup a free commercial Azure Active Direcotry account.

1. Create a new Azure Subscription

    https://azure.microsoft.com/en-us/free/

2. Once you have created the subscription, you can now create new Azure Active Directory users in the AAD tenant that was created for your subscription.

    https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/add-users-azure-active-directory#add-a-new-user

3. Go to the Power Apps Developer Plan signup page and use the newly created AAD account above.

    https://powerapps.microsoft.com/en-us/developerplan/

4. Now you are all setup to use the Power Apps Developer Plan.  Azure Active Directory is free with the Azure subscription.  Unless you are using other resources in the Azure subscription, there is no cost required.
