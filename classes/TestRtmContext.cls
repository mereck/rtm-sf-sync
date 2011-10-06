public without sharing class TestRtmContext
{
    private static User testUser = null;
    
    public static Boolean SwitchRtmSync = true;
    
    public static String PackageVersion = 'RTM Sync version 1.17'; 
    
    public static User GetTestUser()
    {
        if(testUser == null)
        {
            Profile p = [select id from profile where name='Standard User'];
            testUser = new User();
            testUser.alias = 'rtm_user';
            testUser.email= 'test_rtm_user@8th-sphere.com';
            testUser.emailencodingkey='UTF-8';
            testUser.lastname = 'Testing';
            testUser.languagelocalekey = 'en_US'; 
            testUser.localesidkey = 'en_US';
            testUser.profileid = p.Id; 
            testUser.timezonesidkey = 'America/Los_Angeles';
            testUser.Username = 'test_rtm_user@8th-sphere.com';
            testUser.RTM_Frob__c = 'rtm_frob';
            testUser.RTM_Auth_Token__c = '141daf3b5a7019772494e6289771c1e11a2ead61';
            testUser.RTM_List_ID__c = 'rtm_list';
            testUser.IsRTMTaskBind__c = SwitchRtmSync;
        }
        
        return testUser;
    }
    
    public static List<RtmCommon.ListResponse> GetTestRtmLists()
    {
        List<RtmCommon.ListResponse> result = new List<RtmCommon.ListResponse>();
        
        RtmCommon.ListResponse list1 = new RtmCommon.ListResponse();
        list1.Id = '100653'; list1.Name = 'Inbox';
        RtmCommon.ListResponse list2 = new RtmCommon.ListResponse();
        list2.Id = '387549'; list2.Name = 'High Priority';
        RtmCommon.ListResponse list3 = new RtmCommon.ListResponse();
        list3.Id = '387546'; list3.Name = 'New List';
        RtmCommon.ListResponse list4 = new RtmCommon.ListResponse();
        list4.Id = '100654'; list4.Name = 'Personal';
        RtmCommon.ListResponse list5 = new RtmCommon.ListResponse();
        list5.Id = '100655'; list5.Name = 'Study';
        RtmCommon.ListResponse list6 = new RtmCommon.ListResponse();
        list6.Id = '100656'; list6.Name = 'Work';
        RtmCommon.ListResponse list7 = new RtmCommon.ListResponse();
        list7.Id = '100657'; list7.Name = 'Sent';
        
        result.add(list1);
        result.add(list2);
        result.add(list3);
        result.add(list4);
        result.add(list5);
        result.add(list6);
        result.add(list7);
        
        return result;
    }
    
    public static List<RtmCommon.ListResponse> GetTestRtmTasks()
    {
        List<RtmCommon.ListResponse> result = new List<RtmCommon.ListResponse>();
        
        result.add(GetRtmList1());
        result.add(GetRtmList2());
        result.add(GetRtmList3());
        result.add(GetRtmList4());
        result.add(GetRtmList5());
        result.add(GetRtmList6());
        result.add(GetRtmList7());
        result.add(GetRtmList8());
        result.add(GetRtmList9());
        
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList1()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '9405702';      
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList2()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '9405701';
        
        RtmCommon.TaskSeriesResponse taskSeries1 = new RtmCommon.TaskSeriesResponse();
        taskSeries1.Id = '44697893';
        taskSeries1.Name = 'sync pivotal tracker stories to toggl';

        RtmCommon.TaskResponse task1 = new RtmCommon.TaskResponse();
        task1.Id = '63766922';

        taskSeries1.Task = task1;
        
        result.TaskSeriesList.add(taskSeries1);
                        
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList3()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '9405700';      
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList4()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '10503627';     
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList5()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '10503706';
        
        RtmCommon.TaskSeriesResponse taskSeries1 = new RtmCommon.TaskSeriesResponse();
        taskSeries1.Id = '51574857';
        taskSeries1.Name = '1';
        
        RtmCommon.TaskResponse task1 = new RtmCommon.TaskResponse();
        task1.Id = '73742256';

        taskSeries1.Task = task1;
        
        result.TaskSeriesList.add(taskSeries1);
                
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList6()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '9405699';
        
        RtmCommon.TaskSeriesResponse taskSeries1 = new RtmCommon.TaskSeriesResponse();
        taskSeries1.Id = '44692844';
        taskSeries1.Name = 'Try out Remember The Milk';
        
        RtmCommon.TaskResponse task1 = new RtmCommon.TaskResponse();
        task1.Id = '63758436';

        taskSeries1.Task = task1;
        
        result.TaskSeriesList.add(taskSeries1);
                
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList7()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '10970004';     
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList8()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '9405703';      
        return result;
    }
    
    private static RtmCommon.ListResponse GetRtmList9()
    {
        RtmCommon.ListResponse result = new RtmCommon.ListResponse();
        result.Id = '9405698';
        
        RtmCommon.TaskSeriesResponse taskSeries1 = new RtmCommon.TaskSeriesResponse();
        taskSeries1.Id = '54933554';
        taskSeries1.Name = 'test_rtm_task_11';
        
        RtmCommon.TaskResponse task1 = new RtmCommon.TaskResponse();
        task1.Id = '78626944';
        
        taskSeries1.Task = task1;
        
        result.TaskSeriesList.add(taskSeries1);
        
        RtmCommon.TaskSeriesResponse taskSeries2 = new RtmCommon.TaskSeriesResponse();
        taskSeries2.Id = '54933980';
        taskSeries2.Name = 'test_rtm_22';
        
        RtmCommon.TaskResponse task2 = new RtmCommon.TaskResponse();
        task2.Id = '78627378';
        
        taskSeries2.Task = task2;
        
        result.TaskSeriesList.add(taskSeries2);
        
        RtmCommon.TaskSeriesResponse taskSeries3 = new RtmCommon.TaskSeriesResponse();
        taskSeries3.Id = '54898562';
        taskSeries3.Name = 'remember_to_test_rtm_tasks!';
        
        RtmCommon.TaskResponse task3 = new RtmCommon.TaskResponse();
        task3.Id = '78568424';
        
        taskSeries3.Task = task3;
        
        result.TaskSeriesList.add(taskSeries3);
                                
        return result;
    }
}