public class HelpScriptPageController
{
    public PageReference DeleteAllTasks()
    {
        for(Task task : [SELECT Id FROM Task])
        {
            delete task;
        }
        
        return null;
    }
}