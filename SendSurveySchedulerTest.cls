@isTest
private class SendSurveySchedulerTest {
	 static testmethod void schedulerTest()
    {
        String CRON_EXP='0 35 11 * * ?';
        //create test data
        contact con = new contact();
        con.FirstName='N26 customer';
        con.LastName='ABCD';
        con.Languages__c = 'EN';
        con.Survey_Date__c = date.today();
        con.Email='vinodjakore@gmail.com';
        insert con;
        
        Test.startTest();
        String jobId= system.schedule('Send Survey EMail', CRON_EXP, new SendSurveyScheduler());
        CronTrigger ct = [SELECT Id,CronExpression,TimesTriggered,NextFireTime FROM CronTrigger WHERE Id=:jobId];
        System.assertEquals(CRON_EXP,ct.CronExpression);
        System.assertEquals(0,ct.TimesTriggered);
        
        Test.stopTest();
        
    }
}