/**
* @author Vinod Jakore
* @date 07/01/2019
* @description SendSurveyEmailScheduler is used to schedule the SendSurveyEmail class
*/

global class SendSurveyEmailScheduler implements schedulable 
{
    global void execute(SchedulableContext sc)
    {
        SendSurveyEmail sse = new SendSurveyEmail();
        database.executeBatch(sse);
    }
}
