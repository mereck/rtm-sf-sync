@isTest
class TestRtmChangeRtmTaskTrigger
{
    static testMethod void TestInsertTrigger()
    {
        System.debug(TestRtmContext.PackageVersion);
        
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon.IsApexTest = true;
            
            Task newTask = new Task();
            newTask.Subject = 'TestCompletedTaskSubject';
            newTask.ActivityDate = Date.newInstance(2009, 11, 9); 
            newTask.Priority = 'Normal'; 
            newTask.Status = 'Completed';
            
            Test.startTest();
            insert newTask;
            Test.stopTest();
            
            List<Task> testResult = [SELECT RTMActivityId__c FROM Task WHERE Id =: newTask.Id];
            
            System.assertEquals(testResult.size(), 1);
            System.assertEquals(testResult.get(0).RTMActivityId__c, '79149141');
        }
    }

    static testMethod void TestUpdateTrigger()
    {
        System.debug(TestRtmContext.PackageVersion);
        
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon.IsApexTest = true;
                    
            Task testTask = new Task();
            testTask.Subject = 'TestCompletedTaskSubject';
            testTask.ActivityDate = Date.newInstance(2009, 11, 9); 
            testTask.Priority = 'Normal'; 
            testTask.Status = 'Completed';
            testTask.RTMActivityId__c = 'testRtmId';
            
            insert testTask;

            testTask.Subject = 'TestCompletedTaskSubject2';
            testTask.ActivityDate = Date.newInstance(2009, 11, 12);
            testTask.Priority = 'High';                    
            testTask.Status = 'Not Started';

            Test.startTest();           
            update testTask; 
            
            testTask.Status = 'Completed';
            update testTask;
            Test.stopTest();
            
            System.assertEquals(testTask.RTMActivityId__c, 'testRtmId');
        }
    }
}