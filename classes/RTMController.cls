public with sharing class RTMController {

    public Boolean IsRtmAuthenticated { get; set; }
    public Boolean IsUpsertRtmTasks { get; set; }
    
    public String ImportRtmTasksType { get; set; }
    
    public String RTMAuthServicePath { get; set; }
    public String RTMTimeLine { get; set; }
    
    public static Boolean IsRtmSyncUpdate = false;
    
    public List<RtmCommon.ListResponse> RTMLists { get; set; }
    
    //Report properties
    public Boolean IsReport { get; set; }
    public String ErrorMessage { get; set; }
    public String InfoMessage { get; set; }
    public String WarningMessage { get; set; }
    public Integer NewSfTasks { get; set; }
    public Integer UpdatedSfTasks { get; set; }
    public Integer UpdatedRtmTasks { get; set; }
    
    public String RTMListId
    {
    	get
    	{
    		return rtm.ListId;
    	}
    } 

	RTMCommon rtm = null;

	public RTMController()
	{
		System.Debug('==RTMController==');
		IsUpsertRtmTasks = false;
		ImportRtmTasksType = '0';
		
		rtm = new RTMCommon();
		
		IsRtmAuthenticated = false;
		
		InitRtmAuth();
	}
	
	public RtmController(RtmCommon r)
	{
		rtm = r;
	}

	public Boolean CheckAuthentication()
	{
		System.Debug('==CheckAuthentication==');
		Boolean result = false;

		if(rtm.Frob != null && rtm.Frob.length() > 0)
		{
			System.Debug('==FROB: ' + rtm.Frob);
			try
			{
				if(rtm.AuthToken != null && rtm.AuthToken.length() > 0)
				{
					System.Debug('==AuthToken: ' + rtm.AuthToken);
					return rtm.CheckRTMAuthToken();
				}
				else
				{
					System.Debug('AuthToken is not defined');
					String authToken = rtm.GetRTMAuthToken();
					if(authToken.length() > 0)
					{
						rtm.SetRTMAuthToken(authToken);
						return true;
					}
				}
			}
			catch(System.Exception e)
			{
				HandleExceptions(e, false, 'CheckAuthentication');
				return false;
			}
		}
		return result;
	}

    public void InitRtmAuth()
    {
    	try
    	{
    		if(!CheckAuthentication())
    		{
    			rtm.SetRTMFrob(rtm.GetRTMFrob());
    			rtm.SetRTMAuthToken(null);

    			RTMAuthServicePath = rtm.GetRTMAuthUrl();
    		}
    		else
    		{
    			IsRtmAuthenticated = true;
    			RtmLists = rtm.GetRTMLists();
    		}
       	}
    	catch(System.Exception e)
    	{
    		HandleExceptions(e, false, 'InitRtmAuth');
    	}
    }
    
    /*
    public void InitRtmList()
    {
    	System.Debug('==InitRtmList==');
    	if(!CheckList())
    	{
    		System.Debug('==Try to Create RTM List==');
    		RTMTimeLine = rtm.GetTimeLine();
    		String sfListId = rtm.CreateRTMListForSFTasks(RTMTimeLine, null);
    		System.Debug('==Try to Create RTM List Result: ' + sfListId);
    		rtm.SetRTMListId(sfListId);
    	}
    }
    */
    
    private void CreateRtmList(String listName)
    {
    	try
    	{
   			RTMTimeLine = rtm.GetTimeLine();
   			String sfListId = rtm.CreateRTMListForSFTasks(RTMTimeLine, listName);
   			rtm.SetRTMListId(sfListId);
    	}
    	catch(System.Exception e)
    	{
    		HandleExceptions(e, false, 'CreateRtmList');
    	}
    }
    
    @future(callout=true)
    public static void AsyncRemoteCalls(String timeLine, Set<String> rtmTasksForUpdate)
    {
    	System.Debug('==AsyncRemoteCalls==');

    	RtmCommon rtm = new RtmCommon();
   	
		Integer counter = 0;    	
    	for(String rtmTaskString : rtmTasksForUpdate)
    	{
    		// add check amount of remote calls for updating current (rtmTaskString) task
    		// The amount should be predicted to avoid exception
			if(rtm.RemoteCallCounter == 10)
    		{
    			return;
    		}
    		
			RtmCommon.RtmDataForUpdate rtmTaskForUpdate = new RtmCommon.RtmDataForUpdate();
			rtmTaskForUpdate.Deserialize(rtmTaskString);
			
			rtm.UpdateTask(timeLine, rtmTaskForUpdate);
			
			counter++;
    	}
    }
    
    @future (callout=true)
    public static void AsyncInsertRtmTask(Set<Id> tasksIds)
    {
    	System.Debug('==AsyncInsertRtmTask==');
    	
    	// switch off update trigger
    	IsRtmSyncUpdate = true;
    	
    	RtmController rtmController = null;
    	
    	try
    	{
    		RtmCommon rtm = new RtmCommon();
    		rtmController = new RtmController(rtm);
    	
    		rtmController.InsertRtmTasks(tasksIds);
    	}
		catch(System.Exception e)
		{
			if(rtmController != null)
			{
				rtmController.HandleExceptions(e, true, 'AsyncInsertRtmTask');
			}
			else
			{
				System.Debug('AsyncInsertRtmTask Method RtmController object is not created ' );
			}
		}
    	
    	// switch on update trigger
    	IsRtmSyncUpdate = false;
    }

    @future (callout=true)
    public static void AsyncUpdateRtmTask(Set<Id> tasksIds)
    {
    	System.Debug('==AsyncUpdateRtmTask==');
    	
    	RtmController rtmController = null;

		try
		{
			RtmCommon rtm = new RtmCommon();
    		rtmController = new RtmController(rtm);
    		
			rtmController.UpdateRtmTasks(tasksIds);
		}
		catch(System.Exception e)
		{
			if(rtmController != null)
			{
				rtmController.HandleExceptions(e, true, 'AsyncUpdateRtmTask');
			}
			else
			{
				System.Debug('AsyncUpdateRtmTask Method RtmController object is not created ' );
			}
		}
    }
    
    /*    
    public Boolean CheckList()
    {
    	System.Debug('==CheckList==');
    	Boolean result = false;
    	
    	if(rtm.ListId != null && rtm.ListId.length() > 0)
    	{
    		//result = rtm.CheckRTMList(rtm.ListId);
    		result = true;
    	}
    	return result;
    }
    */
    
    public PageReference ContinueRtmAuth()
    {
    	InitRtmAuth();
    	
    	return null;
    }
    
    public PageReference AddRtmList()
    {
    	String listName = ApexPages.currentPage().getParameters().get('newRtmListName');
    	if(listName == null || listName.length() == 0)
    	{
    		return null;
    	}
    	
    	try
    	{
    		CreateRtmList(listName);
    		RtmLists = rtm.GetRTMLists();
    	}
    	catch(System.Exception e)
    	{
    		HandleExceptions(e, false, 'AddRtmList');
    	}
    	
    	return null;
    }
    
    public PageReference SaveRtmSettings()
    {
    	System.Debug('==SaveRtmSettings==');
    	InitRtmAuth();
    	
    	String listId = ApexPages.currentPage().getParameters().get('rtmListId');
    	if(listId == null || listId.length() == 0)
    	{
    		return null;
    	}

    	rtm.SetRTMListId(listId);    	
    	rtm.UpdateRtmUserData();
    	
    	return null;
    }
    
    public PageReference SyncRtmTasks()
    {
    	System.Debug('==SyncRtmTasks==');
   	
    	InitRtmAuth();
    	
    	Map<String, Task> allSfToRtmTasks = new Map<String, Task>();
    	
		List<Task> tasksForUpdate = new List<Task>();
		List<RtmCommon.RtmDataForUpdate> rtmTasksForUpdate = new List<RtmCommon.RtmDataForUpdate>();
		List<Task> tasksForInsert = new List<Task>();
		
		List<RtmCommon.ListResponse> rtmData = null;
		
		try
		{
			rtmData = rtm.GetRTMTasks();
		}
		catch(System.Exception e)
		{
			HandleExceptions(e, false, 'SyncRtmTasks');
			return null;
		}
		    	
    	for(Task sfTask : [SELECT Subject, ActivityDate, Priority, RTMActivityId__c, IsClosed, Status, LastModifiedDate FROM Task WHERE OwnerId =:UserInfo.getUserId() AND (RTMActivityId__c != null AND RTMActivityId__c != '')])
    	{
    		if(!allSfToRtmTasks.containsKey(sfTask.RTMActivityId__c))
    		{
    			allSfToRtmTasks.put(sfTask.RTMActivityId__c, sfTask);
    		}
    		else
    		{
    			// Data error one rtm id should assosiate only one salesforce task
    		}
    	}
    	
		for(RtmCommon.ListResponse listResponse : rtmData)
		{
			for(RtmCommon.TaskSeriesResponse taskSeries : listResponse.TaskSeriesList)
			{
				if(allSfToRtmTasks.containsKey(taskSeries.Task.Id))
				{
					Task task = allSfToRtmTasks.get(taskSeries.Task.Id);
					
					if(ImportRtmTasksType.equals('0'))
					{
						if(task.LastModifiedDate.getTime() > GetValueFromRtmDateTime(taskSeries.Modified).getTime())
						{
							RtmCommon.RtmDataForUpdate updatedTask = PrepareRtmTaskForUpdate(task, listResponse.Id, taskSeries);
							
							if(updatedTask != null)
							{
								rtmTasksForUpdate.add(updatedTask);
							}
						}
						else if(task.LastModifiedDate.getTime() < GetValueFromRtmDateTime(taskSeries.Modified).getTime())
						{
							Task updatedTask = PrepareSalesforceTaskForUpdate(task, taskSeries);
						
							if(updatedTask != null)
							{						
								tasksForUpdate.add(updatedTask);
							}
						}
					}
					else if(ImportRtmTasksType.equals('1'))
					{
						Task updatedTask = PrepareSalesforceTaskForUpdate(task, taskSeries);
						
						if(updatedTask != null)
						{						
							tasksForUpdate.add(updatedTask);
						}
					}
					else if(ImportRtmTasksType.equals('2'))
					{
						RtmCommon.RtmDataForUpdate updatedTask = PrepareRtmTaskForUpdate(task, listResponse.Id, taskSeries);
						
						if(updatedTask != null)
						{
							rtmTasksForUpdate.add(updatedTask);
						}
					}
				}
				else if(IsUpsertRtmTasks)
				{
					Task newTask = new Task();
					newTask.Subject = taskSeries.Name;
					newTask.Status = GetValueFromRtmStatus(taskSeries.Task.Completed);
					newTask.ActivityDate = GetValueFromRtmDueDate(taskSeries.Task.Due);
					newTask.Priority = GetValueFromRtmPriority(taskSeries.Task.Priority);
					newTask.RTMActivityId__c = taskSeries.Task.Id;
					
					tasksForInsert.add(newTask);
				}
			}
		}
    	
    	System.Debug('==== Sync Updated tasks:' + tasksForUpdate);
    	System.Debug('==== Sync Inserted tasks:' + tasksForInsert);
    	System.Debug('==== Sync Rtm Updated tasks:' + rtmTasksForUpdate);
    	
    	IsRtmSyncUpdate = true;
    	
    	for(Task updateTask : tasksForUpdate)
    	{
    		update updateTask;
    	}
    	
    	for(Task newTask : tasksForInsert)
    	{
    		insert newTask;
    	}
    	
    	try
    	{
    		if(rtmTasksForUpdate.size() > 0)
    		{
    			RTMTimeLine = rtm.GetTimeLine();
    		}
    	
    		Set<String> serializedRtmTasks = new Set<String>();
    		for(RtmCommon.RtmDataForUpdate rtmUpdateTask : rtmTasksForUpdate)
    		{
				serializedRtmTasks.add(rtmUpdateTask.Serialize());
    		}
    		
    		List<Set<String>> tasksForUpdateList = new List<Set<String>>();
    		Set<String> tasksForUpdateSet = new Set<String>();
    		Integer counter = 0;
    		for(String taskString : serializedRtmTasks)
    		{
    			if(counter < 2)
    			{
					tasksForUpdateSet.add(taskString);
    			}
    			else
    			{
    				counter = 0;
    				tasksForUpdateList.add(tasksForUpdateSet);
    				
    				tasksForUpdateSet = new Set<String>();
    				tasksForUpdateSet.add(taskString);
    			}
    			
    			counter++;
    		}
    		
    		if(tasksForUpdateSet.size() > 0)
    		{
    			tasksForUpdateList.add(tasksForUpdateSet);
    		}
    		
    		for(Integer asyncCallCounter = 0; asyncCallCounter < tasksForUpdateList.size() && asyncCallCounter < 10; asyncCallCounter++)
    		{
    			if(!RtmCommon.IsApexTest)
    			{
					RtmController.AsyncRemoteCalls(RTMTimeLine, tasksForUpdateList.get(asyncCallCounter));
    			}
    		}
    		
			if(serializedRtmTasks.size() > 20)
			{
				InfoMessage = 'There are ' + serializedRtmTasks.size() + ' tasks.';
				InfoMessage += ' Only 20 tasks can be processed by one click.';
				InfoMessage += '</br>';
				InfoMessage += ' Please, repeat your actions to finish the synchronization.';
				
				UpdatedRtmTasks = 20; 
			}
			else
			{
				UpdatedRtmTasks = serializedRtmTasks.size();
			}    		
    	}
    	catch(System.Exception e)
    	{
    		InfoMessage = '';
    		ErrorMessage = 'Error updating RTM Tasks.';
    		UpdatedRtmTasks = 0;
    		
    		HandleExceptions(e, false, 'SyncRtmTasks');
    	}
    	
    	IsRtmSyncUpdate = false;
    	
    	IsReport = true;
    	NewSfTasks = tasksForInsert.size();
    	UpdatedSfTasks = tasksForUpdate.size();
    	
    	return null;
    }
        
    public void UpdateUserData()
    {
    	rtm.UpdateRtmUserData();
    }
    
    public List<SelectOption> GetImportRtmTasksTypes()
    {
    	List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','latest updated task wins'));
        options.add(new SelectOption('1','rtm always wins'));
        options.add(new SelectOption('2','salesforce always wins'));
        
        return options;
    }

    public void RtmLogout()
    {
    	rtm.SetRTMFrob(rtm.GetRTMFrob());
    	rtm.SetRTMAuthToken(null);
    	rtm.SetRTMListId(null);
    	rtm.UpdateRtmUserData();

    	IsRtmAuthenticated = false;
    	RTMAuthServicePath = rtm.GetRTMAuthUrl();
    }
    
    public String GetValueFromRtmPriority(String rtmTaskPriority)
    {
    	// It is default value and it is required.
    	// It should be replaced for using direct picklist values in place of the constants
    	String result = 'Normal';
    	
    	if(rtmTaskPriority != null && rtmTaskPriority.length() > 0)
    	{
    		if(rtmTaskPriority == '1')
    		{
    			result = 'High'; 
    		}
    		else if (rtmTaskPriority == '2')
    		{
    			result = 'Normal';
    		}
    		else if (rtmTaskPriority == '3')
    		{
    			result = 'Low';
    		}
    	}
    	
    	return result;
    }
    
    public Date GetValueFromRtmDueDate(String rtmDateTime)
    {
    	rtmDateTime = rtmDateTime.toUpperCase();
    	System.Debug('-------- input rtmDate:' + rtmDateTime);
    	Date result = null;

    	if(rtmDateTime != null && rtmDateTime.length() > 0)
    	{
    		String rtmDate;
    		String rtmTime;
    		try
    		{
    			rtmDate = rtmDateTime.substring(0, rtmDateTime.indexOf('T'));
    			rtmTime = rtmDateTime.substring(rtmDateTime.indexOf('T') + 1, rtmDateTime.indexOf('Z'));
    		}
    		catch(System.Exception e)
    		{
    			System.Debug('RtmController Exception RTM date parsing');
    			System.Debug('Message:' + e.getMessage());
    			
    			return result;
    		}

			try
			{    		
    			result = Date.valueOf(rtmDate + ' ' + rtmTime);
			}
			catch(System.Exception e)
			{
				System.Debug('RtmController Exception create Salesforce datetime');
				System.Debug('Message:' + e.getMessage());
				
				return result;
			}	
    	}
    	
    	System.Debug('===== SF Date:' + result);
    	
    	return result;
    }
    
    public String GetValueFromRtmStatus(String rtmStatus)
    {
    	System.Debug('-------- input rtmStatus:' + rtmStatus);
    	String result = null;
    	
    	if(rtmStatus != null && rtmStatus.length() > 0)
    	{
    		result = 'Completed';
    	}
    	else
    	{
    		result = 'Not Started';
    	}

    	return result;
    }
    
    public Boolean GetBooleanValueFromRtmStatus(String rtmStatus)
    {
    	if(rtmStatus != null && rtmStatus.length() > 0)
    	{
    		if(GetValueFromRtmDateTime(rtmStatus) != null)
    		{
    			return true;
    		}
    		else
    		{
    			return false;
    		}
    	}
    	else
    	{
			return false;
    	}
    }
        
    public Datetime GetValueFromRtmDateTime(String rtmDateTime)
    {
    	rtmDateTime = rtmDateTime.toUpperCase();
    	Datetime result = null;

    	if(rtmDateTime != null && rtmDateTime.length() > 0)
    	{
    		String rtmDate;
    		String rtmTime;
    		try
    		{
    			rtmDate = rtmDateTime.substring(0, rtmDateTime.indexOf('T'));
    			rtmTime = rtmDateTime.substring(rtmDateTime.indexOf('T') + 1, rtmDateTime.indexOf('Z'));
    		}
    		catch(System.Exception e)
    		{
    			System.Debug('RtmController Exception RTM date parsing');
    			System.Debug('Message:' + e.getMessage());
    			
    			return result;
    		}

			try
			{    		
    			result = Datetime.valueOf(rtmDate + ' ' + rtmTime);
			}
			catch(System.Exception e)
			{
				System.Debug('RtmController Exception create Salesforce datetime');
				System.Debug('Message:' + e.getMessage());
				
				return result;
			}	
    	}
    	
    	return result;
    }
    
    public Task PrepareSalesforceTaskForUpdate(Task sfTask, RtmCommon.TaskSeriesResponse rtmTaskSeries)
    {
    	System.Debug('==PrepareSalesforceTaskForUpdate==');
    	
    	Task result = sfTask;
    	
    	Boolean shouldUpdate = false;
    	
    	if(!result.Subject.equals(rtmTaskSeries.Name))
    	{
    		shouldUpdate = true;
    		result.Subject = rtmTaskSeries.Name;
    	}
    	
    	String rtmStatus = GetValueFromRtmStatus(rtmTaskSeries.Task.Completed);
    	if(!result.Status.equals(rtmStatus))
    	{
    		shouldUpdate = true;
			result.Status = rtmStatus;
    	}
    	
    	Date rtmActivityDate = GetValueFromRtmDueDate(rtmTaskSeries.Task.Due);
    	
    	if(
    		(result.ActivityDate == null && rtmActivityDate != null) || 
    		(result.ActivityDate != null && rtmActivityDate != null && result.ActivityDate.daysBetween(rtmActivityDate) != 0)
    	)
    	{
    		shouldUpdate = true;
			result.ActivityDate = rtmActivityDate;
    	} 
    	
    	String rtmPriority = GetValueFromRtmPriority(rtmTaskSeries.Task.Priority);
    	if(!result.Priority.equals(rtmPriority))
    	{ 
    		shouldUpdate = true;
			result.Priority = rtmPriority;
    	} 
    	
    	if(shouldUpdate)
    	{
    		return result;
    	}
    	else
    	{
    		return null;
    	}
    }
    
    public RtmCommon.RtmDataForUpdate PrepareRtmTaskForUpdate(Task sfTask, String listId, RtmCommon.TaskSeriesResponse rtmTaskSeries)
    {
    	System.Debug('==PrepareRtmTaskForUpdate==');
    	
    	RtmCommon.RtmDataForUpdate result = new RtmCommon.RtmDataForUpdate();
    	
    	Boolean shouldUpdate = false;
    	
    	if(!sfTask.Subject.equals(rtmTaskSeries.Name))
    	{
    		shouldUpdate = true;
    		result.Subject = sfTask.Subject;
    	}
    	
    	Boolean rtmStatus = GetBooleanValueFromRtmStatus(rtmTaskSeries.Task.Completed);
    	System.Debug('==Status==:' + rtmStatus + ';' + sfTask.IsClosed);
    	if(sfTask.IsClosed != rtmStatus)
    	{
    		shouldUpdate = true;
			result.ShouldComplete = sfTask.IsClosed;
    	}
    	
    	Date rtmActivityDate = GetValueFromRtmDueDate(rtmTaskSeries.Task.Due);
    	
    	if(
    		(sfTask.ActivityDate != null && rtmActivityDate == null) || 
    		(sfTask.ActivityDate != null && rtmActivityDate != null && sfTask.ActivityDate.daysBetween(rtmActivityDate) != 0)
    	)
    	{
    		shouldUpdate = true;
			result.DueDate = sfTask.ActivityDate;
    	} 
    	
    	String rtmPriority = GetValueFromRtmPriority(rtmTaskSeries.Task.Priority);
    	if(!sfTask.Priority.equals(rtmPriority))
    	{ 
    		shouldUpdate = true;
			result.Priority = sfTask.Priority;
    	} 
    	
    	if(shouldUpdate)
    	{
    		result.ListId = listId;
	    	result.TaskSeriesId = rtmTaskSeries.Id;
	    	result.TaskId = rtmTaskSeries.Task.Id;
	    	
    		return result;
    	}
    	else
    	{
    		return null;
    	}
    }
        
    private void UpdateRtmTasks(Set<Id> tasksIds)
    {
  	    if(CheckAuthentication())
	    {
			RTMTimeLine = rtm.GetTimeLine();
        		
     		System.Debug('==TASK Updateing RTM==');
     		
     		List<RtmCommon.ListResponse> rtmData = rtm.GetRTMTasks();
     		
     		List<RtmCommon.RtmDataForUpdate> tasksDataForUpdate = new List<RtmCommon.RtmDataForUpdate>();
     		
     		for(Task task : [SELECT Subject, ActivityDate, Priority, Status, RTMActivityId__c, IsClosed FROM Task WHERE Id In :tasksIds])
     		{
	     		for(RtmCommon.ListResponse listResponse : rtmData)
	    		{
	    			for(RtmCommon.TaskSeriesResponse taskSeries : listResponse.TaskSeriesList)
	    			{
	    				if(taskSeries.Task.Id.equals(task.RTMActivityId__c))
	    				{
	    					RtmCommon.RtmDataForUpdate updatedTaskData = new RtmCommon.RtmDataForUpdate();
	    					
	    					updatedTaskData.ListId = listResponse.Id;
	    					updatedTaskData.TaskSeriesId = taskSeries.Id;
	    					updatedTaskData.TaskId = taskSeries.Task.Id;
	    					    			
			    			updatedTaskData.DueDate = task.ActivityDate;
			    			updatedTaskData.Priority = task.Priority;
			    			updatedTaskData.Subject = task.Subject;
			    			updatedTaskData.ShouldComplete = task.IsClosed;
    			
			    			tasksDataForUpdate.add(updatedTaskData);
	    				}    				
	    			}
	    		}
     		}
     		
     		for(RtmCommon.RtmDataForUpdate rtmItem : tasksDataForUpdate)
     		{
     			rtm.UpdateTask(RTMTimeLine, rtmItem);
     		}
    	}
    }
    
    private void InsertRtmTasks(Set<Id> tasksIds)
    {
  	    if(CheckAuthentication())
	    {
    	    if(rtm.ListId != null && rtm.ListId.length() > 0)
        	{
       			RTMTimeLine = rtm.GetTimeLine();
        		
        		List<Task> tasks = [SELECT Subject, ActivityDate, Priority, Status, RTMActivityId__c, IsClosed FROM Task WHERE Id In :tasksIds];
        		
        		for(Task task : tasks)
        		{
        			System.Debug('==TASK Inserted into RTM==');
        			String rtmTaskId = rtm.AddTask(task, RTMTimeLine);
        			
        			System.Debug('---------- rtm task id: ' + rtmTaskId);
        			task.RTMActivityId__c = rtmTaskId;
        		}
        		
        		for(Task task : tasks)
        		{
        			System.Debug('---------- update task rtm id: ' + task.RTMActivityId__c);
        			update task;
        		}
        	}
    	}
    }

    public void HandleExceptions(System.Exception ex, Boolean isAsync, String methodName)
    {
    	ApexPages.Message exceptionMessage = null;
    	 
    	if(ex instanceOf RtmCommon.UnresponsibleException)
    	{
    		exceptionMessage = new ApexPages.Message(ApexPages.severity.WARNING, 'RTM Service is unresponsible');
    	}
    	if(ex instanceOf RtmCommon.RemoteSiteConfigurationException)
    	{
    		exceptionMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Please check Setup->Security->Remote site settings. endpoint = https://www.rememberthemilk.com');
    	}
    	if(ex instanceOf RtmCommon.RtmErrorResponseException)
    	{
    		exceptionMessage = new ApexPages.Message(ApexPages.severity.Error, 'RTM Service response error');
    	}
    	if(exceptionMessage == null)
    	{
    		exceptionMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Undefined Error');
    	}
    	
    	if(!isAsync)
    	{
    		ApexPages.addMessage(exceptionMessage);
    	}
    	
   		System.Debug(methodName + ': ' + exceptionMessage);
    }
}