@isTest
class TestRtmController
{
    static RtmController GetCustomTestObject(RtmCommon rtm)
    {
        RtmCommon.IsApexTest = true;
        
        System.assertEquals(RtmCommon.IsApexTest, true);
        
        return new RtmController(rtm);
    }
    
    static testMethod void TestCustomTestObject()
    {
        System.debug(TestRtmContext.PackageVersion);
        
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = new RtmCommon();
            
            RtmController controller = GetCustomTestObject(rtm);
            
            System.assert(controller != null);
        }
    }
    
    static testMethod RtmController GetTestObject()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon.IsApexTest = true;
            
            System.assertEquals(RtmCommon.IsApexTest, true);            
            
            return new RtmController();
        }
        return null; 
    }

    static testMethod void TestProperties()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = new RtmCommon();
            rtm.SetRtmListId('RtmControllerListId');
            
            RtmController controller = GetCustomTestObject(rtm);
            
            String testResultListId = controller.RTMListId;
            
            System.assertEquals(testResultListId, 'RtmControllerListId');
        }
    }
    
    static testMethod void TestAsyncInsertRtmTask()
    {
        TestRtmContext.SwitchRtmSync = false;
        User testUser = TestRtmContext.GetTestUser();
        System.runAs(testUser)
        {
            Set<Id> testTasks = new Set<Id>();
            
            Task task1 = new Task();
            task1.OwnerId = testUser.Id;
            task1.Subject = 'TestCompletedTaskSubject';
            task1.ActivityDate = Date.newInstance(2009, 11, 9); 
            task1.Priority = 'Normal'; 
            task1.Status = 'Completed';
            
            insert task1;
            
            Task task2 = new Task();
            task2.OwnerId = testUser.Id;
            task2.Subject = 'TestNotStartedTaskSubject';
            task2.ActivityDate = Date.newInstance(2009, 11, 9); 
            task2.Priority = 'Normal';
            task2.Status = 'Not Started';
            
            insert task2;
            
            testTasks.add(task1.Id);
            testTasks.add(task2.Id);
            
            RtmCommon.IsApexTest = true;
            
            Test.startTest();
            RtmController.AsyncInsertRtmTask(testTasks);
            Test.stopTest();
            
            List<Task> testResult = [SELECT Subject, RTMActivityId__c FROM Task WHERE Id IN :testTasks];
            
            System.assertEquals(testResult.size(), 2);
            
            for(Task testTask : testResult)
            {
                System.assertEquals(testTask.RTMActivityID__c, '79149141');
            }
        }
    }
    
    static testMethod void TestAsyncUpdateRtmTask()
    {
        TestRtmContext.SwitchRtmSync = false;
        User testUser = TestRtmContext.GetTestUser();
        System.runAs(testUser)
        {
            RtmCommon.IsApexTest = true;
            
            Set<Id> tasksIds = new Set<Id>();
            
            Task task1 = new Task();
            task1.OwnerId = testUser.Id;
            task1.Subject = 'TestCompletedTaskSubject';
            task1.ActivityDate = Date.newInstance(2009, 11, 9); 
            task1.Priority = 'High'; 
            task1.Status = 'Completed';
            task1.RTMActivityId__c = '63766922';
            
            Task task2 = new Task();
            task2.OwnerId = testUser.Id;
            task2.Subject = 'TestNotStartedTaskSubject';
            task2.ActivityDate = Date.newInstance(2009, 11, 9); 
            task2.Priority = 'Normal';
            task2.Status = 'Not Started';
            task2.RTMActivityId__c = '73742256';
			
			insert task1;            
            insert task2;
            
            tasksIds.add(task1.Id);
            tasksIds.add(task2.Id);
            

            Test.startTest();
            RtmController.AsyncUpdateRtmTask(tasksIds);
            Test.stopTest();

            for(Task testTask : [SELECT Subject, ActivityDate, Priority, Status, RTMActivityId__c, IsClosed FROM Task WHERE Id IN: tasksIds])
            {
            	if(testTask.RTMActivityId__c.equals('73742256'))
            	{
            		System.assertEquals(testTask.IsClosed, false);
            	}
            	if(testTask.RTMActivityId__c.equals('63766922'))
            	{
            		System.assertEquals(testTask.IsClosed, true);
            	}            
            }
        }
    }
    
    static testMethod void TestAsyncRemoteCalls()
    {
        User testUser = TestRtmContext.GetTestUser();
        System.runAs(testUser)
        {
            RtmCommon.IsApexTest = true;
            
            RtmCommon.RtmDataForUpdate rtmData1 = new RtmCommon.RtmDataForUpdate();
            
            rtmData1.ListId = 'TestListId';
        	rtmData1.TaskSeriesId = 'TestTaskSeriedId';
        	rtmData1.TaskId = 'TestTaskId';
        
        	rtmData1.ShouldComplete = true;
        	rtmData1.DueDate = Date.newInstance(2010, 2, 28);
        	rtmData1.Priority = 'High';
        	rtmData1.Subject = 'TestTaskSubject';
            
            Set<String> tasks = new Set<String>();
            tasks.add(rtmData1.serialize());

            Test.startTest();
            RtmController.AsyncRemoteCalls('rtm_timeline', tasks);
            Test.stopTest();
            
            System.assertEquals(rtmData1.DueDate, Date.newInstance(2010, 2, 28));
        }
    }
    
    static testMethod void TestCheckAuthentication()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            
            Boolean testResult = controller.CheckAuthentication();
            
            System.assertEquals(testResult, true);
            
            RtmCommon rtm = new RtmCommon();
            rtm.SetRTMFrob(null);
            
            controller = GetCustomTestObject(rtm);
            
            testResult = controller.CheckAuthentication();
            
            System.assertEquals(testResult, false);
            
            rtm = new RtmCommon();
            rtm.SetRTMFrob('testRtmFrob');
            rtm.SetRTMAuthToken('');
            
            controller = GetCustomTestObject(rtm);
            
            testResult = controller.CheckAuthentication();
            System.assertEquals(testResult, true);
            
            rtm = new RtmCommon();
            rtm.SetRTMFrob('testRtmFrob');
            rtm.SetRTMAuthToken('testRtmAuthToken');
            
            controller = GetCustomTestObject(rtm);
            
            testResult = controller.CheckAuthentication();
            System.assertEquals(testResult, false);
            
            rtm = new RtmCommon();
            rtm.SetRTMFrob('testRtmFrob');
            rtm.SetRTMAuthToken('141daf3b5a7019772494e6289771c1e11a2ead61');
            
            controller = GetCustomTestObject(rtm);
            
            testResult = controller.CheckAuthentication();
            System.assertEquals(testResult, true);
        }
    }
    
    static testMethod void TestInitRtmAuth()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = new RtmCommon();
            rtm.SetRTMFrob(null);
            
            RtmController controller = GetCustomTestObject(rtm);
            controller.InitRtmAuth();
            
            System.assertEquals(controller.IsRtmAuthenticated, null);
            System.assertEquals(controller.RTMAuthServicePath, rtm.GetRTMAuthUrl());
            
            rtm = new RtmCommon();
            rtm.SetRTMFrob('testRtmFrob');
            rtm.SetRTMAuthToken('141daf3b5a7019772494e6289771c1e11a2ead61');
            
            controller = GetCustomTestObject(rtm);
            controller.InitRtmAuth();
            
            System.assertEquals(controller.IsRtmAuthenticated, true);
            System.assertEquals(controller.RtmLists.size(), rtm.GetRTMLists().size());          
        }
    }
    
    static testMethod void TestContinueRtmAuth()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            PageReference continuePageReference = controller.ContinueRtmAuth();
            
            System.assertEquals(true, continuePageReference == null);
        }
    }
    
    static testMethod void TestAddRtmList()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            controller.AddRtmList();
            
            PageReference testPage = Page.RTM_Settings;
            Test.setCurrentPage(testPage);
            ApexPages.currentPage().getParameters().put('newRtmListName', 'testRtmListName');
            
            PageReference addRtmListPageReference = controller.AddRtmList();
            System.assertEquals(addRtmListPageReference == null, true);
        }
    }

    static testMethod void TestSaveRtmSettings()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = new RtmCommon();
            rtm.SetRTMListId(null);
            
            RtmController controller = GetCustomTestObject(rtm);
            controller.SaveRtmSettings();
            
            System.assertEquals(rtm.ListId, null);
            
            PageReference testPage = Page.RTM_Settings;
            Test.setCurrentPage(testPage);
            ApexPages.currentPage().getParameters().put('rtmListId', 'TestListId');
            
            controller.SaveRtmSettings();
            System.assertEquals(rtm.ListId, 'TestListId');
        }
    }

    static testMethod void TestSyncRtmTasks()
    {
        TestRtmContext.SwitchRtmSync = false;
        User testUser = TestRtmContext.GetTestUser();
        System.runAs(testUser)
        {
            Task task1 = new Task();
            task1.OwnerId = testUser.Id;
            task1.Subject = 'TestCompletedTaskSubject';
            task1.ActivityDate = Date.newInstance(2009, 11, 9); 
            task1.Priority = 'Normal'; 
            task1.Status = 'Completed';
            task1.RTMActivityId__c = '78568424';
            
            insert task1;
            
            Task task2 = new Task();
            task2.OwnerId = testUser.Id;
            task2.Subject = 'TestNotStartedTaskSubject';
            task2.ActivityDate = Date.newInstance(2009, 11, 9); 
            task2.Priority = 'Normal';
            task2.Status = 'Not Started';
            task2.RTMActivityId__c = '78627378';
            
            insert task2;
            
            RtmController controller = GetTestObject();
            controller.SyncRtmTasks();
            
            task1 = [SELECT IsClosed FROM Task WHERE Id =: task1.Id];
            System.assertEquals(task1.IsClosed, true);
            
            task2 = [SELECT IsClosed FROM Task WHERE Id =: task2.Id];
            System.assertEquals(task2.IsClosed, false);
        }
        TestRtmContext.SwitchRtmSync = true;
    }
    
    static testMethod void TestUpdateUserData()
    {
        User testUser = TestRtmContext.GetTestUser();
        insert testUser;
        System.runAs(testUser)
        {
            RtmCommon rtm = new RtmCommon();
            rtm.SetRTMFrob('testRtmFrob');
            rtm.SetRtmAuthToken('testRtmAuthToken');
            rtm.SetRtmListId('testRtmListId');
            
            RtmController controller = GetCustomTestObject(rtm);
            controller.UpdateUserData();
            
            User testResult = [SELECT RTM_Frob__c, RTM_Auth_Token__c, RTM_List_ID__c  FROM User WHERE Id =: testUser.Id];
            
            System.assertEquals(testResult.RTM_Frob__c, 'testRtmFrob');
            System.assertEquals(testResult.RTM_Auth_Token__c, 'testRtmAuthToken');
            System.assertEquals(testResult.RTM_List_ID__c, 'testRtmListId');
        }
    }
    
    static testMethod void TestRtmLogout()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            controller.RtmLogout();
            
            System.assertEquals(controller.IsRtmAuthenticated, false);
        }
    }
    
    static testMethod void TestHandleExceptions()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
        	RtmCommon.UnresponsibleException unresponsibleException = new RtmCommon.UnresponsibleException();
        	RtmCommon.RemoteSiteConfigurationException remoteConfigException = new RtmCommon.RemoteSiteConfigurationException();
        	RtmCommon.RtmErrorResponseException errorResponseException = new RtmCommon.RtmErrorResponseException();
        	
            RtmController controller = GetTestObject();
            controller.HandleExceptions(unresponsibleException, true, 'TestMethodName');
            controller.HandleExceptions(remoteConfigException, true, 'TestMethodName');
            controller.HandleExceptions(errorResponseException, true, 'TestMethodName');
            
            System.assertEquals(ApexPages.getMessages().size(), 0);
            
            controller.HandleExceptions(unresponsibleException, false, 'TestMethodName');
            controller.HandleExceptions(remoteConfigException, false, 'TestMethodName');
            controller.HandleExceptions(errorResponseException, false, 'TestMethodName');
            
            System.assertEquals(ApexPages.getMessages().size(), 3);
        }
    }
    
    static testMethod void TestGetValueFromRtmPriority()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            String highPriority = controller.GetValueFromRtmPriority('1');
            
            System.assertEquals(highPriority, 'High');
            
            String normalPriority = controller.GetValueFromRtmPriority('2');
            
            System.assertEquals(normalPriority, 'Normal');
            
            String lowPriority = controller.GetValueFromRtmPriority('3');
            
            System.assertEquals(lowPriority, 'Low');
        }    	
    }
    
    static testMethod void TestGetValueFromRtmDueDate()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            Date dueDate = controller.GetValueFromRtmDueDate('2010-02-11T11:22:33Z');
            
            System.assertEquals(dueDate, Date.newInstance(2010, 2, 11));
            
            Date wrongDueDate = controller.GetValueFromRtmDueDate('2010-13-1111:22:33');
            
            System.assertEquals(wrongDueDate, null);
        }    	
    }
    
    static testMethod void TestGetValueFromRtmStatus()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            
            String completedStatus = controller.GetValueFromRtmStatus('');
            
            System.assertEquals(completedStatus, 'Not Started');
            
            String notStartedStatus = controller.GetValueFromRtmStatus('N');
            
            System.assertEquals(notStartedStatus, 'Completed');
        }    	
    }
    
    static testMethod void TestGetBooleanValueFromRtmStatus()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            
            Boolean completedStatus = controller.GetBooleanValueFromRtmStatus('2010-2-10T10:00:05Z');
            
            System.assertEquals(completedStatus, true);
            
            Boolean notStartedStatus = controller.GetBooleanValueFromRtmStatus('');
            
            System.assertEquals(notStartedStatus, false);
        }    	
    }
    
    static testMethod void TestGetValueFromRtmDateTime()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmController controller = GetTestObject();
            
            DateTime rtmDateTime = controller.GetValueFromRtmDateTime('2010-10-12T11:22:33Z');
            
            System.assertEquals(rtmDateTime, DateTime.newInstance(2010,10,12,11,22,33));
            
            rtmDateTime = controller.GetValueFromRtmDateTime('2010-10-12T11:22:33');
            
            System.assertEquals(rtmDateTime, null);
        }    	
    }

    static testMethod void TestPrepareSalesforceTaskForUpdate()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
        	Task sfTask = new Task();
        	sfTask.Subject = 'TestSfName';
        	sfTask.ActivityDate = Date.newInstance(2010, 2, 22);
        	sfTask.Priority = 'High';
        	sfTask.Status = 'Completed';
        	
        	RtmCommon.TaskResponse rtmTask = new RtmCommon.TaskResponse();
        	rtmTask.Completed = '';
        	rtmTask.Due = '2010-2-25T00:00:00Z';
        	rtmTask.Priority = '2';
        	
        	RtmCommon.TaskSeriesResponse rtmTaskSeries = new RtmCommon.TaskSeriesResponse();
        	rtmTaskSeries.Name = 'TestRtmName';
        	rtmTaskSeries.Task = rtmTask;
        	
            RtmController controller = GetTestObject();
            Task result = controller.PrepareSalesforceTaskForUpdate(sfTask, rtmTaskSeries);
            
            System.assertEquals(result.Subject, 'TestRtmName');
			System.assertEquals(result.ActivityDate, Date.newInstance(2010,2,25));
			System.assertEquals(result.Priority, 'Normal');
			System.assertEquals(result.Status, 'Not Started');
        }    	
    }

    static testMethod void TestPrepareRtmTaskForUpdate()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
        	Task sfTask = new Task();
        	sfTask.Subject = 'TestSfName';
        	sfTask.ActivityDate = Date.newInstance(2010, 2, 22);
        	sfTask.Priority = 'High';
        	sfTask.Status = 'Not Started';
        	
        	insert sfTask;
        	
        	sfTask = [SELECT Id, Subject, ActivityDate, Priority, Status, IsClosed FROM Task WHERE Id =: sfTask.Id];
        	
        	RtmCommon.TaskResponse rtmTask = new RtmCommon.TaskResponse();
        	rtmTask.Id = 'RtmTaskId';
        	rtmTask.Completed = '2010-1-20T10:15:30Z';
        	rtmTask.Due = '2010-2-25T00:00:00Z';
        	rtmTask.Priority = '2';
        	
        	RtmCommon.TaskSeriesResponse rtmTaskSeries = new RtmCommon.TaskSeriesResponse();
        	rtmTaskSeries.Id = 'RtmTaskSeriesId';
        	rtmTaskSeries.Name = 'TestRtmName';
        	rtmTaskSeries.Task = rtmTask;
        	
            RtmController controller = GetTestObject();
            RtmCommon.RtmDataForUpdate result = controller.PrepareRtmTaskForUpdate(sfTask, 'TestRtmListId', rtmTaskSeries);
            
            System.assertEquals(result.Subject, 'TestSfName');
			System.assertEquals(result.DueDate, Date.newInstance(2010,2,22));
			System.assertEquals(result.Priority, 'High');
			System.assertEquals(result.ShouldComplete, false);
			
			System.assertEquals(result.ListId, 'TestRtmListId');
			System.assertEquals(result.TaskSeriesId, 'RtmTaskSeriesId');
	    	System.assertEquals(result.TaskId, 'RtmTaskId');
        }    	
    }
}