global class SendSurveyScheduler implements schedulable 
{
    global void execute(SchedulableContext sc)
    {
        SendSurveyEmail sse = new SendSurveyEmail();
        system.debug('In Schedulable context execute method :started execution');
        database.executeBatch(sse);
    }
}