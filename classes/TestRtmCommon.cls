@isTest
class TestRtmCommon
{
    static testMethod RtmCommon GetTestObject()
    {
        System.debug(TestRtmContext.PackageVersion);
        
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon.IsApexTest = true;
            
            System.assertEquals(RtmCommon.IsApexTest, true);
            
            return new RtmCommon();
        } 
        return null;
    }
 
    static testMethod void TestProperties()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            System.assertEquals(rtm.Frob, 'rtm_frob');
            System.assertEquals(rtm.AuthToken, '141daf3b5a7019772494e6289771c1e11a2ead61');
            System.assertEquals(rtm.ListId, 'rtm_list');
        }
    }
    
    static testMethod void TestAuthUrl()
    {
        String rtmAuthUrl = 'https://www.rememberthemilk.com/services/auth/?api_key=381cedf876d1255bbda1c9c386f64937&api_sig=dca41989e578405cb75633e50d122840&frob=rtm_frob&perms=delete';
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            System.assertEquals(rtm.GetRTMAuthUrl(), rtmAuthUrl);
        }
    }

    static testMethod void TestGetRtmLists()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            System.assertEquals(rtm.GetRTMLists().size(), TestRtmContext.GetTestRtmLists().size());

            Integer listSize = rtm.GetRTMLists().size();
            Integer testListSize = 0;           
            for(RtmCommon.ListResponse testList : TestRtmContext.GetTestRtmLists())
            {
                for(RtmCommon.ListResponse testResultList : rtm.GetRTMLists())
                {
                    if(testResultList.Id == testList.Id && testResultList.Name == testList.Name)
                    {
                        testListSize++;
                        continue;
                    }
                }               
            }
            
            System.assertEquals(listSize, testListSize);
        }
    }
    
    static testMethod void TestGetRtmTasks()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();

            List<RtmCommon.ListResponse> testRtmTasks = TestRtmContext.GetTestRtmTasks();
            List<RtmCommon.ListResponse> rtmTasks = rtm.GetRtmTasks();
            
            System.assertEquals(testRtmTasks.size(), rtmTasks.size());

            Integer listSize = rtmTasks.size();
            Integer testListSize = 0;
                        
            for(RtmCommon.ListResponse testList : testRtmTasks)
            {
                for(RtmCommon.ListResponse testResultList : rtmTasks)
                {
                    if(testResultList.Id.equals(testList.Id))
                    {
                        System.assertEquals(testResultList.TaskSeriesList.size(), testList.TaskSeriesList.size());

                        if(testResultList.TaskSeriesList.size() == 0 && testList.TaskSeriesList.size() == 0)
                        {
                            testListSize++;
                        }
                        else
                        {
                            Integer testResultTaskSeriesSize = testResultList.TaskSeriesList.size();
                            Integer testTaskSeriesSize = 0;
                            
                            for(RtmCommon.TaskSeriesResponse testTaskSeries : testList.TaskSeriesList)
                            {
                                for(RtmCommon.TaskSeriesResponse taskSeries : testResultList.TaskSeriesList)
                                {
                                    if(testTaskSeries.Name.equals(taskSeries.Name) && testTaskSeries.Id.equals(taskSeries.Id))
                                    {
                                        if(testTaskSeries.Task.Id.equals(taskSeries.Task.Id))
                                        {
                                            testTaskSeriesSize++;
                                            continue;
                                        }
                                    }
                                }
                            }
                            
                            System.assertEquals(testTaskSeriesSize, testResultTaskSeriesSize);
                            
                            if(testTaskSeriesSize == testResultTaskSeriesSize)
                            {
                                testListSize++;
                            }
                        }
                        continue;
                    }
                }               
            }
            
            System.assertEquals(listSize, testListSize);
        }
    }
    
    static testMethod void TestGetTimeLine()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            String timeLineResponse = rtm.GetTimeLine();
            
            System.assertEquals(timeLineResponse, '129953056');
        }
    }
    
    static testMethod void TestCreateRTMListForSFTasks()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            String timeLine = '129953056';
            
            String result = rtm.CreateRTMListForSFTasks(timeLine, 'SF List');
            
            System.assertEquals(result, '11057156');
            
            //test timeline exception
            try
            {
                rtm.CreateRTMListForSFTasks(null, 'SF List');
            }
            catch(RtmCommon.TimeLineRequiredException e)
            {
                System.assert(true);
            }           
        }
    }
    
    static testMethod void TestAddTask()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            String timeLine = '129953056';
            Task sfTask = new Task();
            sfTask.Subject = 'TestAddSFTask';
            sfTask.ActivityDate = Date.newInstance(2009, 11, 27);
            sfTask.Priority = 'Normal';
            
            String rtmTaskId = rtm.AddTask(sfTask, timeLine);
            
            System.assertEquals(rtmTaskId, '79149141');
        }
    }
    
    static testMethod void TestAddClosedTask()
    {
        User testUser = TestRtmContext.GetTestUser();
        System.runAs(testUser)
        {
            RtmCommon rtm = GetTestObject();
            
            Account testAccount = new Account(name = 'TestAccount');
            insert testAccount;
            
            Contact testContact = new Contact(AccountId = testAccount.Id, Lastname='TestLastName', Firstname='TestFirstName');
            insert testContact;
            
            Case testCase = new Case(AccountId = testAccount.Id, ContactId = testContact.Id, Status = 'New', Type = 'Help Request', Origin = 'Email', Subject = 'TestCaseSubject');
            insert testCase;
            
            String timeLine = '129953056';
            Task sfTask = new Task();
            sfTask.WhatId = testCase.Id;
            sfTask.WhoId = testContact.Id;
            sfTask.OwnerId = testUser.Id;
            sfTask.Subject = 'TestTaskSubject';
            sfTask.ActivityDate = Date.newInstance(2009, 11, 9); 
            sfTask.Priority = 'Normal'; 
            sfTask.Status = 'Completed';
            sfTask.ReminderDateTime = null;
            
            System.assertEquals(sfTask.Status, 'Completed');                        
            String testResult = rtm.AddTask(sfTask, timeLine);
            
            System.assertEquals(testResult, '79149141');
            
            //test timeline exception
            try
            {
                rtm.AddTask(sfTask, '');
            }
            catch(RtmCommon.TimeLineRequiredException e)
            {
                System.assert(true);
            }
        }
    }
    
    static testMethod void TestCheckRTMAuthToken()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            Boolean testResult = rtm.CheckRTMAuthToken();
            
            System.assertEquals(testResult, true);
        }       
    }
    
    static testMethod void TestGetRTMFrob()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            String testResult = rtm.GetRTMFrob();
            
            System.assertEquals(testResult, '0a56717c3561e53584f292bb7081a533c197270c');
        }       
    }
    
    static testMethod void TestGetRTMAuthToken()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            String testResult = rtm.GetRTMAuthToken();
            
            System.assertEquals(testResult, '141daf3b5a7019772494e6289771c1e11a2ead61');
        }       
    }
    
    static testMethod void TestUpdateTask()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            RtmCommon.RtmDataForUpdate updateData = new RtmCommon.RtmDataForUpdate();
            updateData.ListId = 'testListId';
            updateData.TaskSeriesId = 'testTaskSeriesId';
            updateData.TaskId = 'testTaskId';
            updateData.DueDate = Date.newInstance(2010, 02, 22);
            updateData.Subject = 'Test Task Subject';
            updateData.Priority = 'Normal';
            updateData.ShouldComplete = false;
            
            Boolean updateResult = rtm.UpdateTask('testTimeLine', updateData);
            
            System.assertEquals(updateResult, true);
            
            updateData.ShouldComplete = true;           
            
            updateResult = rtm.UpdateTask('testTimeLine', updateData);
            
            System.assertEquals(updateResult, true);
            
            //test timeline exception
            try
            {
                rtm.UpdateTask(null, updateData);
            }
            catch(RtmCommon.TimeLineRequiredException e)
            {
                System.assert(true);
            }
        }
    }
    
    static testMethod void TestHandleRtmErrorResponse()
    {
        System.runAs(TestRtmContext.GetTestUser())
        {
            RtmCommon rtm = GetTestObject();
            
            RtmCommon.ErrorResponse errorResponse = new RtmCommon.ErrorResponse(1, 'Test Error Message');
            
            try
            {
            	rtm.HandleRtmErrorResponse(errorResponse);
            }
            catch(RtmCommon.RtmErrorResponseException e)
            {
            	System.assert(true);
            }
        }
    }
    
    static testMethod void TestRtmDataForUpdateSerialization()
    {
    	RtmCommon.RtmDataForUpdate serializedObject = new RtmCommon.RtmDataForUpdate();
    	
    	serializedObject.ListId = 'TestListId';
    	serializedObject.TaskSeriesId = 'TestTaskSeriesId';
    	serializedObject.TaskId = 'TestTaskId';
    	serializedObject.DueDate = Date.newInstance(2010, 3, 15);
    	serializedObject.Priority = 'TestPriority';
    	serializedObject.ShouldComplete = true;
    	serializedObject.Subject = 'Test Subject';
    	
    	String serializedString = serializedObject.Serialize();
    	
    	RtmCommon.RtmDataForUpdate deserializedObject = new RtmCommon.RtmDataForUpdate();
    	deserializedObject.Deserialize(serializedString);
    	
    	System.assertEquals(serializedObject.ListId, deserializedObject.ListId);
    	System.assertEquals(serializedObject.TaskSeriesId, deserializedObject.TaskSeriesId);
    	System.assertEquals(serializedObject.TaskId, deserializedObject.TaskId);
    	System.assertEquals(serializedObject.DueDate, deserializedObject.DueDate);
    	System.assertEquals(serializedObject.Priority, deserializedObject.Priority);
    	System.assertEquals(serializedObject.ShouldComplete, deserializedObject.ShouldComplete);
    	System.assertEquals(serializedObject.Subject, deserializedObject.Subject);    	
    	
    	RtmCommon.RtmDataForUpdate serializedObjectEmpty = new RtmCommon.RtmDataForUpdate();
    	String serializedStringEmpty = serializedObjectEmpty.Serialize();
    	
    	RtmCommon.RtmDataForUpdate deserializedObjectEmpty = new RtmCommon.RtmDataForUpdate();
    	deserializedObjectEmpty.Deserialize(serializedStringEmpty);
    }
}