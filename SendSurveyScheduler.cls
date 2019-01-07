global class SendSurveyEmailScheduler implements schedulable 
{
    global void execute(SchedulableContext sc)
    {
        SendSurveyEmail sse = new SendSurveyEmail();
        database.executeBatch(sse);
    }
}
