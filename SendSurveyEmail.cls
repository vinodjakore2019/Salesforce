/**
* @author Vinod Jakore
* @date 07/01/2019
* @description SendSurveyEmail batch class search for the contacts with survey date less than equals to todays date and sends Email to contact email Id depends upon Language mentioned in contact
*/
        
global class SendSurveyEmail implements Database.Batchable<sObject> {

    global List<String> errorMessages = new List<String>();

    global Database.QueryLocator start(Database.BatchableContext Bc){
        String query = 'Select Id,FirstName,Languages__c,Survey_Date__c,Email FROM Contact WHERE Survey_Date__c <= TODAY';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext Bc,List<Contact> scope){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         //Iterate through the accounts which contains Survey_Date__c is less than equals to todays date
       for(Contact con : scope){
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] sendingTo = new String[]{con.Email};
    	   mail.setToAddresses(sendingTo);
           mail.setTargetObjectId(con.Id);
      			
           //Check if language of the contact is English then send the email in English language
           if(con.Languages__c=='EN' || con.Languages__c=='en'){
               	mail.setSubject('Please fill out our survey');
               	String body = 'Hey ' + con.FirstName + ',<br/>';
      			body += 'Please fill out our survey: http://n26.com/survey/' + con.id + '<br/><br/>';
                body += 'Mit freundlichen grüßen / Kind Regards,<br/>';
                body += 'N26 bank <br/>';
                mail.setHtmlBody(body);
                mails.add(mail);
               //Check if language of the contact is English then send the email in English language
           }else if(con.Languages__c=='DE'|| con.Languages__c=='de'){
               mail.setSubject('Bitte füllen Sie unsere Umfrage aus');
               String body = 'Hey ' + con.FirstName + ',<br/>';
      		   body += 'Bitte füllen Sie unsere Umfrage aus: http://n26.com/survey/' + con.Id + '<br/><br/>';
               body += 'Mit freundlichen grüßen / Kind Regards,<br/>';
               body += 'N26 bank <br/>';
               mail.setHtmlBody(body);
               mails.add(mail);

           }
           
           //Once the email is ready to send to contact then make Survey Date field as null.
           con.Survey_Date__c = null;
    }
        
        if(!mails.isEmpty()) {
                try{
                    Messaging.sendEmail(mails);
                }
                catch (Exception ex) {
                    errorMessages.add('Unable to send email to : '+ ex.getStackTraceString());
                }
        }
        update scope;
    }
    global void finish(Database.BatchableContext Bc){
    	AsyncApexJob aaj = [Select Id, Status, NumberOfErrors, JobItemsProcessed, MethodName, TotalJobItems, CreatedBy.Email from AsyncApexJob 
	    where Id =:BC.getJobId()];
        // Send an email to the Send Survey Email job submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {aaj.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Send Survey Email JOB Salesforce Send Notification Batch: ' + aaj.Status);
        String bodyText='Total Job Items ' + aaj.TotalJobItems + ' Number of records processed ' + aaj.JobItemsProcessed + ' with '+ aaj.NumberOfErrors + ' failures.\n';
        bodyText += 'Number of Error Messages ' + errorMessages.size() + '\n';
        bodyText += 'Error Message' + String.join(errorMessages, '\n');
        mail.setPlainTextBody(bodyText);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
