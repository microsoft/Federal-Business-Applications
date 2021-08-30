
/*Function - Update Phone Call Record - used to populate mandatory or helpful fields after the call has been initiated*/
function updatePhoneCallRecord(formContext, notes){

    formContext.getAttribute("subject").setValue("Outbound Call");
    formContext.getAttribute("description").setValue(notes);
    
}
/*Function - Open Requested Url Window - uses the window.open method instead of an XMLHttpRequest due to the CORS security 
    constraints when using deeplinks from a non teams.microsoft.com domain */
function openRequestedUrlWindow(url, windoName){

    var windowObjRef = window.open(url,windoName);

    return windowObjRef;

};

/*Function - Initiate Phone Call Window - Builds the teams deep link URL and passes it to a new window. 
    Due to default security policies around cross-origin requests, the new window object's attributes are inaccessible from the calling window and vise-versa */
function initiatePhoneCallWindow(executionContext ){


    var formContext = executionContext.getFormContext(); // get formContext

    var callFromTeams = formContext.getAttribute("").getValue(); //Custom Column here -- use the format of publisherprefix_columnname--ex: new_callfromteams

    if(callFromTeams){

        var phoneNumber = formContext.getAttribute("phonenumber").getValue();
        
        if(!phoneNumber || phoneNumber.length <9){

            alert("You must enter a 9 digit phone number");
            return;
         }

        var phoneNumberSanitized = phoneNumber.replace(/[^0-9]/g, '');

        if(!phoneNumberSanitized || phoneNumberSanitized.length <9){

           alert("You must enter a 9 digit phone number");
           return;
        }else{
            
           const teamsURL = new URL("https://teams.microsoft.com/l/call/0/0"); 
           teamsURL.searchParams.append("users","4:" + phoneNumberSanitized);
           var url = teamsURL.href;
           var windowName = "Outbound Phone Call";
           var windoObj = openRequestedUrlWindow(url,windowName);

           if(windoObj){

                var description = "Call initiated from Teams";
                updatePhoneCallRecord(formContext, description);

           }else{

               var error = "Unable to complete the outbound call";
               updatePhoneCallRecord(formContext, error);
           }
           
           

        }
    }else{
        /* This is used to accomodate the avaiable onChange event, so the call does not re-trigger if the switch is set back to No/False */
    }


    
}