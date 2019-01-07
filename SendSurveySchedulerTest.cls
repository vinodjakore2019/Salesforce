/**
* @author Vinod Jakore
* @date 07/01/2019
* @description SendSurveyEmailSchedulerTest is test class to test the code of SendSurveyEmail and SendSurveyEmailScheduler classes.
*/

@isTest
private class SendSurveyEmailSchedulerTest {
	 static testmethod void schedulerTest()
    {
        String CRON_EXP='0 18 1 * * ?';
	//Create test data for customer 1 with EN language
        contact con_en = new contact();
        con_en.FirstName='N26 customer1';
        con_en.LastName='ABCD';
        con_en.Languages__c = 'EN';
        con_en.Survey_Date__c = date.today();
        con_en.Email='vinodjakore@gmail.com';
        insert con_en;
	//Create test data for customer 2 with DE language
        contact con_de = new contact();
        con_de.FirstName='N26 customer2';
        con_de.LastName='ABCDEF';
        con_de.Languages__c = 'DE';
        con_de.Survey_Date__c = date.today();
        con_de.Email='vinodjakore@gmail.com';
        insert con_de;
        
        Test.startTest();
        String jobId= system.schedule('Send Survey EMail', CRON_EXP, new SendSurveyEmailScheduler());
        CronTrigger ct = [SELECT Id,CronExpression,TimesTriggered,NextFireTime FROM CronTrigger WHERE Id=:jobId];
        System.assertEquals(CRON_EXP,ct.CronExpression);
        System.assertEquals(0,ct.TimesTriggered);
        
        Test.stopTest();
        
    }
}
