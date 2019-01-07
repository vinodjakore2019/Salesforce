global class SendSurveyEmail implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext Bc){
        String query = 'Select Id,FirstName,Desc__c,Languages__c,Survey_Date__c,Email FROM Contact WHERE Survey_Date__c <= TODAY';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext Bc,List<Contact> scope){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
       for(Contact con : scope){
           if(con.desc__c=='' || con.desc__c== null){
     			con.desc__c='updated by send survey schedular';
            }
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] sendingTo = new String[]{con.Email};
    	   mail.setToAddresses(sendingTo);
           if(con.Languages__c=='EN' || con.Languages__c=='en'){
               	mail.setSubject('Please fill out our survey');
               	String body = 'Hey ' + con.FirstName + ',';
      			body += 'Please fill out our survey: http://n26.com/survey/' + con.id;
      			mail.setHtmlBody(body);
               mails.add(mail);
           }else if(con.Languages__c=='DE'|| con.Languages__c=='de'){
               mail.setSubject('Bitte füllen Sie unsere Umfrage aus');
               	String body = 'Hey ' + con.FirstName + ',';
      			body += 'Bitte füllen Sie unsere Umfrage aus: http://n26.com/survey/' + con.Id;
               mail.setHtmlBody(body);
               mails.add(mail);

           }
           con.Survey_Date__c = null;
    }
        Messaging.sendEmail(mails);
        update scope;
    }
    global void finish(Database.BatchableContext Bc){
        
    }
}