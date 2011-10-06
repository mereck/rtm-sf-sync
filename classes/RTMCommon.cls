public with sharing class RTMCommon {

    public static Boolean IsApexTest = false;

    static final String BaseUrl = 'https://www.rememberthemilk.com';
    static final String ApiKey = '381cedf876d1255bbda1c9c386f64937';
    static final String SecretKey = '40f6951caf0fcc20';
   
    static final String ServicePath = '/services/rest/';
    static final String AuthServicePath = '/services/auth/';
    
    static final String RTMTaskList = 'Salesforce';

    User currentUser;
    
    public RTMCommon()
    {
        currentUser = [SELECT Username, RTM_Frob__c, RTM_Auth_Token__c, RTM_List_ID__c FROM User WHERE Id =:UserInfo.getUserId()];
        RemoteCallCounter = 0;
    }
    
    public String Frob
    {
        get
        {
            return currentUser.RTM_Frob__c;
        }
    }
    
    public String AuthToken
    {
        get
        {
            return currentUser.RTM_Auth_Token__c;
        }
    }
    
    public String ListId
    {
        get
        {
            return currentUser.RTM_List_ID__c;
        }
    }
    
    public Integer RemoteCallCounter { get; set; }
    
    public String GetRTMAuthUrl()
    {
        System.Debug('==GetRTMAutssshUrl==');
        String result = '';
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('frob', this.Frob);
        parameters.put('perms', 'delete');
        
        parameters.put('api_sig', GetApiSig(parameters));
        
        result = this.GetRTMUrl(this.GetAuthServiceUrl(), parameters);

        System.Debug('Result:' + result);
        return result;
    }
    
    public List<ListResponse> GetRTMLists()
    {
        System.Debug('==GetRTMLists==');
        List<ListResponse> result = null;
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('method', 'rtm.lists.getList');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        Response response = ProcessResponse(responseText);
        
        ListCollectionResponse listCollectionResponse = response instanceOf ListCollectionResponse ? (ListCollectionResponse)response : null;
                
        if(listCollectionResponse == null)
        {
        	HandleRtmErrorResponse(response);
        }
        else
        {
            result = listCollectionResponse.Lists;
        }
                        
        System.Debug(responseText);
        return result;
    }
    
    public List<ListResponse> GetRTMTasks()
    {
        System.Debug('==GetRTMTasks1==');
        List<ListResponse> result = null;
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('method', 'rtm.tasks.getList');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        ListCollectionResponse listCollectionResponse = response instanceOf ListCollectionResponse ? (ListCollectionResponse)response : null;
                
        if(listCollectionResponse == null)
        {
        	HandleRtmErrorResponse(response);
        }
        else
        {
            result = listCollectionResponse.Lists;
        }
                        
        System.Debug(responseText);
        return result;
    }
    
    /*
    public Boolean CheckRTMList(String listId)
    {
        System.Debug('==CheckRTMList==');
        Boolean result = false;
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('method', 'rtm.lists.getList');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        System.Debug(responseText);
        return result;
    }
    */
    
    public String CreateRTMListForSFTasks(String timeLine, String listName)
    {
        System.Debug('==CreateRTMListForSFTasks==');
        String result = '';
        
        String escapedListName = '';
        
        if(timeLine == null || timeLine.length() == 0)
        {
            throw new TimeLineRequiredException();          
        }
        
        if(listName == null || listName.length() == 0)
        {
            escapedListName = RTMTaskList;
        }
        else
        {
            escapedListName = listName;
        }
                
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('name', escapedListName);
        parameters.put('timeline', timeLine);
        parameters.put('method', 'rtm.lists.add');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        ListResponse listResponse = response instanceOf ListResponse ? (ListResponse)response : null;
                
        if(listResponse == null)
        {
			HandleRtmErrorResponse(response);
        }
        else
        {
            result = listResponse.Id;
        }
        
        return result;
    }
    
    public String AddTask(Task sfTask, String timeLine)
    {
        System.Debug('==AddTasks==');
        String result = '';
        
        if(timeLine == null || timeLine.length() == 0)
        {
            throw new TimeLineRequiredException();          
        }
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('list_id', ListId);
        parameters.put('name', sfTask.Subject);
        parameters.put('timeline', timeLine);
        parameters.put('method', 'rtm.tasks.add');
       
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        ListResponse listResponse = response instanceOf ListResponse ? (ListResponse)response : null;
                
        if(listResponse == null)
        {
			HandleRtmErrorResponse(response);
        }
        else
        {
            TaskSeriesResponse taskSeries = null;
            TaskResponse task = null;
            
            if(listResponse.TaskSeriesList.size() > 0)
            {
                taskSeries = listResponse.TaskSeriesList.get(0);
            }
            
            if(taskSeries != null)
            {
                task = taskSeries.Task;
                result = task.Id;
            }
                        
            if(sfTask.ActivityDate != null)
            {
                if(task != null)
                {
                    SetDueDate(timeLine, listResponse.Id, taskSeries.Id, task.Id, sfTask.ActivityDate);
                }
            }
            
            if(sfTask.Priority != null)
            {
            	if(task != null)
            	{
            		SetPriority(timeLine, listResponse.Id, taskSeries.Id, task.Id, sfTask.Priority);
            	}	
            }
            
            String taskStatusValue = sfTask.Status != null ? sfTask.Status : ''; 
            if(taskStatusValue.equals('Completed'))
            {
            	if(task != null)
            	{
            		SetComplete(timeLine, listResponse.Id, taskSeries.Id, task.Id);
            	}
            }
        }
                
        return result;
    }
    
    public Boolean UpdateTask(String timeLine, RtmDataForUpdate rtmDataForUpdate)
    {
        System.Debug('==UpdateTask==');
        Boolean result = true;
        
        if(timeLine == null || timeLine.length() == 0)
        {
            throw new TimeLineRequiredException();          
        }
        
        if(rtmDataForUpdate.ShouldComplete != null)
        {
            if(rtmDataForUpdate.ShouldComplete)
            {
                SetComplete(timeLine, rtmDataForUpdate.ListId, rtmDataForUpdate.TaskSeriesId, rtmDataForUpdate.TaskId);
            }
            else
            {
                SetUncomplete(timeLine, rtmDataForUpdate.ListId, rtmDataForUpdate.TaskSeriesId, rtmDataForUpdate.TaskId);
            }
        }
        
        if(rtmDataForUpdate.DueDate != null)
        {
        	SetDueDate(timeLine, rtmDataForUpdate.ListId, rtmDataForUpdate.TaskSeriesId, rtmDataForUpdate.TaskId, rtmDataForUpdate.DueDate);
        }
        
        if(rtmDataForUpdate.Priority != null)
        {
        	SetPriority(timeLine, rtmDataForUpdate.ListId, rtmDataForUpdate.TaskSeriesId, rtmDataForUpdate.TaskId, rtmDataForUpdate.Priority);
        }
        
        if(rtmDataForUpdate.Subject != null)
        {
        	SetName(timeLine, rtmDataForUpdate.ListId, rtmDataForUpdate.TaskSeriesId, rtmDataForUpdate.TaskId, rtmDataForUpdate.Subject);
        }
                
        return result;
    }
    
    private Boolean SetName(String timeLine, String listId, String taskSeriesId, String taskId, String taskName)
    {
        System.Debug('==SetName==');
        Boolean result = false;
       
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('list_id', listId);
        parameters.put('taskseries_id', taskSeriesId);
        parameters.put('task_id', taskId);
        parameters.put('name', taskName);
        parameters.put('timeline', timeLine);
        parameters.put('method', 'rtm.tasks.setName');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        return result;
    }
        
    private Boolean SetDueDate(String timeLine, String listId, String taskSeriesId, String taskId, Date dueDate)
    {
        System.Debug('==SetDueDate==');
        Boolean result = false;
        
        String dueDateString = dueDate.year() + '-' + dueDate.month() + '-' + dueDate.day();
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('list_id', listId);
        parameters.put('taskseries_id', taskSeriesId);
        parameters.put('task_id', taskId);
        parameters.put('due', dueDateString);
        //parameters.put('has_due_time ', '0');
        parameters.put('parse', '1');
        parameters.put('timeline', timeLine);
        parameters.put('method', 'rtm.tasks.setDueDate');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        return result;
    }
    
    private Boolean SetPriority(String timeLine, String listId, String taskSeriesId, String taskId, String taskPriority)
    {
        System.Debug('==SetPriority==');
        Boolean result = false;
       
        String priority = '';
        
        if(taskPriority.length() > 0)
        {
            if(taskPriority.equalsIgnoreCase('Normal'))
            {
                priority = '2';
            }
            if(taskPriority.equalsIgnoreCase('High'))
            {
                priority = '1';
            }
            if(taskPriority.equalsIgnoreCase('Low'))
            {
                priority = '3';
            }
        }
                
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('list_id', listId);
        parameters.put('taskseries_id', taskSeriesId);
        parameters.put('task_id', taskId);
        parameters.put('priority', priority);
        parameters.put('timeline', timeLine);
        parameters.put('method', 'rtm.tasks.setPriority');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        return result;
    }
    
    private Boolean SetComplete(String timeLine, String listId, String taskSeriesId, String taskId)
    {
        System.Debug('==SetComplete==');
        
        Boolean result = false;
       
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('list_id', listId);
        parameters.put('taskseries_id', taskSeriesId);
        parameters.put('task_id', taskId);
        parameters.put('timeline', timeLine);
        parameters.put('method', 'rtm.tasks.complete');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        return result;
    }
    
    private Boolean SetUncomplete(String timeLine, String listId, String taskSeriesId, String taskId)
    {
        System.Debug('==SetUncomplete==');
        
        Boolean result = false;
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('list_id', listId);
        parameters.put('taskseries_id', taskSeriesId);
        parameters.put('task_id', taskId);
        parameters.put('timeline', timeLine);
        parameters.put('method', 'rtm.tasks.uncomplete');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        return result;
    }
        
    public String GetTimeLine()
    {
        System.Debug('==GetTimeLine==');
        
        String result = '';
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        parameters.put('method', 'rtm.timelines.create');
        
        parameters.put('api_sig', GetApiSig(parameters));

        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        
        Response response = ProcessResponse(responseText);
        
        TimeLineResponse timeLineResponse = response instanceOf TimeLineResponse ? (TimeLineResponse)response : null;
                
        if(timeLineResponse == null)
        {
			HandleRtmErrorResponse(response);
        }
        else
        {
            result = timeLineResponse.TimeLine;
        }

        return result;
    }

    public Boolean CheckRTMAuthToken()
    {
        System.Debug('==CheckRTMAuthToken==');
        
        String rtmMethod = 'rtm.auth.checkToken';
        Boolean result = false;
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('method', rtmMethod);
        parameters.put('api_key', ApiKey);
        parameters.put('auth_token', this.AuthToken);
        
        parameters.put('api_sig', GetApiSig(parameters));
        
        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        Response response = ProcessResponse(responseText);
        
        AuthResponse authResponse = response instanceOf AuthResponse ? (AuthResponse)response : null;
                
        if(AuthResponse == null)
        {
			HandleRtmErrorResponse(response);
        }
        else
        {
            System.Debug('Token: ' + authResponse.Token);
            if(this.AuthToken == authResponse.Token)
            {
                result = true;
            }
        }
                
        return result;
    }
    
    public String GetRTMFrob()
    {
        String rtmMethod = 'rtm.auth.getFrob';
        String result = '';
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('method', rtmMethod);
        parameters.put('api_key', ApiKey);
        parameters.put('perms', 'delete');
        
        parameters.put('api_sig', GetApiSig(parameters));
        
        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        Response response = ProcessResponse(responseText);
        
        FrobResponse frobResponse = response instanceOf FrobResponse ? (FrobResponse)response : null;
                
        if(frobResponse == null)
        {
			HandleRtmErrorResponse(response);
        }
        else
        {
            result = frobResponse.Frob;
        }
        
        return result;
    }
    
    public String GetRTMAuthToken()
    {
        System.Debug('==GetRTMAuthToken==');
        
        String rtmMethod = 'rtm.auth.getToken';
        String result = '';
        
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('method', rtmMethod);
        parameters.put('api_key', ApiKey);
        parameters.put('frob', this.Frob);
        
        parameters.put('api_sig', GetApiSig(parameters));
        
        String responseText = ProcessRequest(GetServiceUrl(), parameters);
        Response response = ProcessResponse(responseText);
        
        AuthResponse authResponse = response instanceOf AuthResponse ? (AuthResponse)response : null;
                
        if(AuthResponse == null)
        {
			HandleRtmErrorResponse(response);
        }
        else
        {
            System.Debug('Token: ' + authResponse.Token);
            result = authResponse.Token;
        }
        
        return result;      
    }
    
    public String ProcessRequest(String serviceUrl, Map<String, String> parameters)
    {
    	System.Debug('==ProcessRequest==');
    	
        String result = '';
                
        String urlBuilder = this.GetRTMUrl(serviceUrl, parameters);
        HTTP httpObject = new HTTP();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(urlBuilder);
        request.setMethod('POST');
        request.setBody(''); 
        
        HttpResponse response = null;
        if(!IsApexTest)
        {
        	try
        	{
        		RemoteCallCounter++;
            	response = httpObject.send(request);
        	}
        	catch(System.CalloutException ex)
        	{
        		throw new RemoteSiteConfigurationException();
        	}
            result = response.getBody();
        }
        else
        {
            String rtmMethod = parameters.get('method');
            result = TestRtmResponses.GetTestRtmData(rtmMethod);
        }

        System.Debug('Response Body: ' + result);
        System.Debug(result.length());
        
        if(result.length() == 0)
        {
            throw new UnresponsibleException(); 
        }
                            
        return result;      
    }
    
    public Response ProcessResponse(String requestResult)
    {
        Response result = null;
        XmlStreamReader xmlReader = new XmlStreamReader(requestResult);
        
        while(xmlReader.hasNext())
        {
            if(xmlReader.getEventType() == XmlTag.START_ELEMENT)
            {
                if(xmlReader.getLocalName() == 'rsp')
                {
                    String statValue = xmlReader.getAttributeValue(null, 'stat');
                    if(statValue == 'ok')
                    {
                        result = ProcessSuccessResponse(xmlReader);
                    }
                    if(statValue == 'fail')
                    {
                        result = ProcessErrorResponse(xmlReader);
                    }
                }
            }
            xmlReader.next();
        }
        
        return result;
    }
    
    public void SetRTMFrob(String frob) 
    {
        currentUser.RTM_Frob__c = frob;
    }
    
    public void SetRTMAuthToken(String authToken)
    {
        currentUser.RTM_Auth_Token__c = authToken;
    }
    
    public void SetRTMListId(String listId)
    {
        currentUser.RTM_List_ID__c = listId;
    }
    
    public void UpdateRtmUserData()
    {
        this.UpdateUserData();      
    }

    private String GetRTMUrl(String serviceUrl, Map<String, String> parameters)
    {
        String result = serviceUrl;
        
        List<String> parametersKeys = new List<String>();
        for(String key : parameters.keySet())
        {
            parametersKeys.add(key);
        }
        parametersKeys.sort();
        
        for(String key : parametersKeys)
        {
            if(result.length() == serviceUrl.length())
            {
                result += '?';
            }
            else
            {
                result += '&';
            }
            
            result += key;
            result += '=';
            result += EncodingUtil.urlEncode(parameters.get(key), 'UTF-8');
        }
        
        System.Debug(result);   
        
        return result;
    }
    
    private void UpdateUserData()
    {
        System.Debug('Update Frob: ' + currentUser.RTM_Frob__c);
        System.Debug('Update Token: ' + currentUser.RTM_Auth_Token__c);
        System.Debug('Update RTM List: ' + currentUser.RTM_List_ID__c);
        System.Debug('Update User Id: ' + currentUser.Id);
        update currentUser;
    }
    
    private String GetApiSig(Map<String, String> parameters)
    {
        String result = SecretKey;
        
        List<String> parametersKeys = new List<String>();
        for(String key : parameters.keySet())
        {
            parametersKeys.add(key);
        }
        parametersKeys.sort();
        
        for(String key : parametersKeys)
        {
            result += key;
            result += parameters.get(key);          
        }

        return EncodingUtil.convertToHex((Crypto.generateDigest('MD5', Blob.valueOf(result))));
    }
    
    private String GetServiceUrl()
    {
        return BaseUrl + ServicePath;   
    }
    
    private String GetAuthServiceUrl()
    {
        return BaseUrl + AuthServicePath;
    }
    
    private ErrorResponse ProcessErrorResponse(XmlStreamReader reader)
    {
    	System.Debug('==ProcessErrorResponse==');
    	
        ErrorResponse result = null;
        
        while(reader.hasNext())
        {
            if(reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == '')
            {
            }
            reader.next();
        }
                
        return result;  
    }
    
    private Response ProcessSuccessResponse(XmlStreamReader reader)
    {
        System.Debug('==ProcessSuccessResponse==');
        
        Response result = null;

        while(reader.hasNext())
        {
            if(reader.getEventType() == XmlTag.START_ELEMENT)
            {
                if(reader.getLocalName() == 'frob')
                {
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS)
                    {
                        FrobResponse frobResponse = new FrobResponse();
                        frobResponse.Frob = reader.getText();
                        result = frobResponse;
                    }
                }
                if(reader.getLocalName() == 'timeline')
                {
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS)
                    {
                        TimeLineResponse timeLineResponse = new TimeLineResponse();
                        timeLineResponse.TimeLine = reader.getText();
                        result = timeLineResponse;
                    }
                }
                if(reader.getLocalName() == 'auth')
                {
                    System.Debug('--auth--');
                    reader.next();
                    result = ParseAuthResponse(reader);
                }
                // get list, task
                if(reader.getLocalName() == 'transaction')
                {
                    System.Debug('--transaction--');
                    reader.next();
                    result = ParseTransactionResponse(reader);
                }
                if(reader.getLocalName() == 'lists')
                {
                    System.Debug('--lists--');
                    result = ParseListsCollectionResponse(reader, true);
                }
                if(reader.getLocalName() == 'tasks')
                {
                    System.Debug('--tasks--');
                    result = ParseListsCollectionResponse(reader, false);
                }
            }
            reader.next();
        }
        return result;
    }
    
    private AuthResponse ParseAuthResponse(XmlStreamReader xmlReader)
    {
        System.Debug('==ParseAuthResponse==');
        
        AuthResponse result = new AuthResponse();

        while(xmlReader.hasNext())
        {
            if(xmlReader.getEventType() == XmlTag.START_ELEMENT)
            {
                if(xmlReader.getLocalName() == 'token')
                {
                    System.Debug('--token--');
                    xmlReader.next();
                    if(xmlReader.getEventType() == XmlTag.CHARACTERS)
                    {
                        result.Token = xmlReader.getText();
                    }
                }
                if(xmlReader.getLocalName() == 'perms')
                {
                    System.Debug('--perms--');
                    xmlReader.next();
                    if(xmlReader.getEventType() == XmlTag.CHARACTERS)
                    {
                        result.Perms = xmlReader.getText();
                    }
                }
                if(xmlReader.getLocalName() == 'user')
                {
                    RTMUser rtmUser = new RTMUser(); 
                    System.Debug('--user--');
                    rtmUser.Id = xmlReader.getAttributeValue(null, 'id');
                    rtmUser.UserName = xmlReader.getAttributeValue(null, 'username');
                    rtmUser.FullName = xmlReader.getAttributeValue(null, 'fullname');
                    
                    System.Debug('User Id: ' + rtmUser.Id);
                    System.Debug('User Name: ' + rtmUser.UserName);
                    System.Debug('User Full Name: ' + rtmUser.FullName);

                    result.User = rtmUser;
                }
            }
            xmlReader.next();
        }

        return result;
    }
       
    private ListCollectionResponse ParseListsCollectionResponse(XmlStreamReader xmlReader, Boolean listOnly)
    {
        System.Debug('==ParseListsCollectionResponse==');
        
        ListCollectionResponse result = new ListCollectionResponse();

        ListResponse rtmList = null;
        TaskSeriesResponse taskSeries = null;
        
        xmlReader.next();
        while(xmlReader.hasNext())
        {
            if(xmlReader.getEventType() == XmlTag.START_ELEMENT)
            {
                if(xmlReader.getLocalName() == 'list' || xmlReader.getLocalName() == 'taskseries' || xmlReader.getLocalName() == 'task')
                {
                    Boolean isInResultList = false;
                    if(xmlReader.getLocalName() == 'list')
                    {
                        rtmList = new ListResponse(); 
                        System.Debug('--list--');
                        rtmList.Id = xmlReader.getAttributeValue(null, 'id');
                        rtmList.Name = xmlReader.getAttributeValue(null, 'name');
                        
                        System.Debug('List Id: ' + rtmList.Id);
                        System.Debug('List Name: ' + rtmList.Name);
                        
                        isInResultList = true;
                    }
                    
                    if(!listOnly)
                    {
                        if(xmlReader.getLocalName() == 'taskseries' || xmlReader.getLocalName() == 'task')
                        {
                            Boolean isSeriesInResultList = false;
                            if(xmlReader.getLocalName() == 'taskseries')
                            {
                                System.Debug('--taskseries--');
                                taskSeries = new TaskSeriesResponse();
                                
                                taskSeries.Id = xmlReader.getAttributeValue(null, 'id');
                                taskSeries.Name = xmlReader.getAttributeValue(null, 'name');
                                taskSeries.Created =  xmlReader.getAttributeValue(null, 'created');
                    			taskSeries.Modified = xmlReader.getAttributeValue(null, 'modified');
                                
                                isSeriesInResultList = true;
                            }
                            
                            if(xmlReader.getLocalName() == 'task')
                            {
                                TaskResponse task = new TaskResponse();
                                task.Id = xmlReader.getAttributeValue(null, 'id');
                    			task.Due = xmlReader.getAttributeValue(null, 'due');
                    			task.Added = xmlReader.getAttributeValue(null, 'added');
                    			task.Completed = xmlReader.getAttributeValue(null, 'completed');
                    			task.Deleted = xmlReader.getAttributeValue(null, 'deleted');
                    			task.Priority = xmlReader.getAttributeValue(null, 'priority');
                    
                                if(taskSeries != null)
                                {
                                    taskSeries.Task = task;
                                }
                            }
                            
                            if(rtmList != null)
                            {
                                if(!isSeriesInResultList)
                                {
                                    rtmList.TaskSeriesList.add(taskSeries);
                                }
                            }
                        }
                    }
                    
                    if(isInResultList)
                    {
                        result.Lists.add(rtmList);
                    }
                }
            }
            xmlReader.next();
        }

        return result;
    }
    
    public ListResponse ParseTransactionResponse(XmlStreamReader xmlReader)
    {
        System.Debug('==ParseTransactionResponse==');
        
        ListResponse result = new ListResponse();

        while(xmlReader.hasNext())
        {
            if(xmlReader.getEventType() == XmlTag.START_ELEMENT)
            {
                if(xmlReader.getLocalName() == 'list')
                {
                    System.Debug('--tr list--');
                    result.Id = xmlReader.getAttributeValue(null, 'id');
                    result.Name = xmlReader.getAttributeValue(null, 'name');
                    
                    System.Debug('List Id: ' + result.Id);
                    System.Debug('List Name: ' + result.Name);
                    
                    result.TaskSeriesList = ParseTaskSeriesResponse(xmlReader);
                }
            }
            xmlReader.next();
        }

        return result;
    }
    
    public List<TaskSeriesResponse> ParseTaskSeriesResponse(XmlStreamReader xmlReader)
    {
        System.Debug('==ParseTaskSeriesResponse==');
        
        List<TaskSeriesResponse> result = new List<TaskSeriesResponse>();

        while(xmlReader.hasNext())
        {
            System.Debug('===========' + xmlReader.getLocalName());
            if(xmlReader.getEventType() == XmlTag.START_ELEMENT)
            {
                if(xmlReader.getLocalName() == 'taskseries')
                {
                    System.Debug('--taskseries--');
                    TaskSeriesResponse taskSeries = new TaskSeriesResponse();

                    taskSeries.Id = xmlReader.getAttributeValue(null, 'id');
                    taskSeries.Created =  xmlReader.getAttributeValue(null, 'created');
                    taskSeries.Modified = xmlReader.getAttributeValue(null, 'modified');
                    taskSeries.Name = xmlReader.getAttributeValue(null, 'name');
                    
                    taskSeries.Task = ParseTaskResponse(xmlReader);
                    
                    result.add(taskSeries);
                }
            }
            xmlReader.next();
        }

        return result;
    }
    
    public TaskResponse ParseTaskResponse(XmlStreamReader xmlReader)
    {
        System.Debug('==ParseTaskResponse==');
        
        TaskResponse result = new TaskResponse();

        while(xmlReader.hasNext())
        {
            if(xmlReader.getEventType() == XmlTag.START_ELEMENT)
            {
                if(xmlReader.getLocalName() == 'task')
                {
                    System.Debug('--task--');
                    result.Id = xmlReader.getAttributeValue(null, 'id');
                    result.Due = xmlReader.getAttributeValue(null, 'due');
                    result.Added = xmlReader.getAttributeValue(null, 'added');
                    result.Completed = xmlReader.getAttributeValue(null, 'completed');
                    result.Deleted = xmlReader.getAttributeValue(null, 'deleted');
                    result.Priority = xmlReader.getAttributeValue(null, 'priority');
                }
            }
            xmlReader.next();
        }

        return result;
    }
    
    public void HandleRtmErrorResponse(Response response)
    {
    	System.Debug('==HandleRtmErrorResponse==');
    	
		ErrorResponse errorResponse = response instanceOf ErrorResponse ? (ErrorResponse)response : null;
        if(errorResponse != null)
        {
        	System.Debug(errorResponse.Message);
        	
        	throw new RtmErrorResponseException(errorResponse);
        }
        else
        {
        	System.Debug('Undefined Error');
        }
    }
            
    class RtmUser
    {
        public String Id {get;set;}
        public String UserName {get;set;}
        public String FullName {get;set;}
    }
        
    public abstract class Response
    {}

    class FrobResponse extends Response
    {
        public String Frob{get;set;}
    }  
    
    class AuthResponse extends Response
    {
        public String Token {get;set;}
        public String Perms {get;set;}
        public RtmUser User {get;set;}
    }
    
    public class ErrorResponse extends Response
    {
        public ErrorResponse(){}
        
        public ErrorResponse(Integer c, String m)
        {
            Code = c;
            Message = m;
        }
        
        public Integer Code {get;set;}
        public String Message {get;set;}
    }
    
    
    public class ListResponse extends Response
    {
        public ListResponse()
        {
            TaskSeriesList = new List<TaskSeriesResponse>();
        }
        
        public String Id { get; set; }
        public String Name { get; set; }
        
        public List<TaskSeriesResponse> TaskSeriesList {get;set;}
    }
    
    public class TransactionResponse extends Response
    {
        public ListResponse RtmList {get;set;}
    }
    
    public class TaskSeriesResponse extends Response
    {
        public String Id { get; set; }
        public String Name { get; set; }
        public String Modified { get; set; }
        public String Created { get; set; } 
        public TaskResponse Task { get; set; }
    }
    
    public class TaskResponse extends Response
    {
        public String Id { get; set; }
        public String Completed { get; set; }
        public String Priority { get; set; }
        public String Due { get; set; }
        public String Added { get; set; }
        public String Deleted { get; set; }
    }
    
    class ListCollectionResponse extends Response
    {
        public ListCollectionResponse()
        {
            Lists = new List<ListResponse>();
        }
        
        public List<ListResponse> Lists {get;set;}
    }
    
    class TimeLineResponse extends Response
    {
        public String TimeLine {get;set;}
    }
    
    public class RtmDataForUpdate
    {
        public String ListId { get; set; }
        public String TaskSeriesId { get; set; }
        public String TaskId { get; set; }
        
        public Boolean ShouldComplete { get; set; }
        public Date DueDate { get; set; }
        public String Priority { get; set;}
        public String Subject { get; set; }
        
        public String Serialize()
        {
        	String result = '';
        	
        	result += 'ListId=' + ListId + ';';
        	result += 'TaskSeriesId=' + TaskSeriesId + ';';
        	result += 'TaskId=' + TaskId + ';';
        	result += 'ShouldComplete=' + ShouldComplete + ';';
        	
        	if(DueDate != null)
        	{
        		result += 'DueDate=' + DueDate.format() + ';';
        	}
        	
        	result += 'Priority=' + Priority + ';';
        	result += 'Subject=' + Subject + ';';
        	
        	return result;
        }
        
        public void Deserialize(String serializedString)
        {
        	String[] objectFields = null;
        	
        	try
        	{
        		objectFields = serializedString.split(';');
        	}
        	catch(System.Exception e)
        	{
        		throw new IncorrectSerializedStringException('RtmCommon.RtmDataForUpdate');
        	}
        	
        	for(String objectField : objectFields)
        	{
        		String[] objectNameValue = null;
        		
        		try
        		{
        			objectNameValue = objectField.split('=');
        		}
        		catch(System.Exception e)
        		{
        			throw new IncorrectSerializedStringException('RtmCommon.RtmDataForUpdate');
        		}
        		
        		if(objectNameValue[0].equals('ListId'))
        		{
        			if(objectNameValue[1] != null && objectNameValue[1].length() > 0)
        			{
        				this.ListId = objectNameValue[1];
        			}
        		}
        		
        		if(objectNameValue[0].equals('TaskSeriesId'))
        		{
        			if(objectNameValue[1] != null && objectNameValue[1].length() > 0)
        			{
        				this.TaskSeriesId = objectNameValue[1];
        			}
        		}
        		
        		if(objectNameValue[0].equals('TaskId'))
        		{
        			if(objectNameValue[1] != null && objectNameValue[1].length() > 0)
        			{
        				this.TaskId = objectNameValue[1];
        			}
        		}
        		
        		if(objectNameValue[0].equals('ShouldComplete'))
        		{
        			if(objectNameValue[1] != null && objectNameValue[1].length() > 0)
        			{
        				if(objectNameValue[1].equals('true'))
        				{
        					this.ShouldComplete = true;
        				}
        				
        				if(objectNameValue[1].equals('false'))
        				{
        					this.ShouldComplete = false;
        				}
        			}
        		}
        		
        		if(objectNameValue[0].equals('DueDate'))
        		{
        			if(objectNameValue[1] != null && objectNameValue[1].length() > 0)
        			{
        				this.DueDate = Date.parse(objectNameValue[1]);
        			}        			
        		}
        		
        		if(objectNameValue[0].equals('Priority'))
        		{
        			if(objectNameValue[1] != null && objectNameValue[1].length() > 0)
        			{
        				this.Priority = objectNameValue[1];
        			}        			
        		}
        		
        		if(objectNameValue[0].equals('Subject'))
        		{
        			if(objectNameValue[1] != null && objectNameValue[1].length() > 0)
        			{
        				this.Subject = objectNameValue[1];
        			}        			
        		}        		        		
        	}
        }
    }
        
    public class UnresponsibleException extends Exception{}
    
    public class TimeLineRequiredException extends Exception{}
    
    public class RemoteSiteConfigurationException extends Exception{}
    
    public class RtmErrorResponseException extends Exception 
    {
    	public ErrorResponse Response { get; set; }
    	
    	public RtmErrorResponseException(ErrorResponse response)
    	{
    		Response = response;
    	}
    }
    
    public class IncorrectSerializedStringException extends Exception
    {
    	public String ClassName
    	{
    		get
    		{
    			return this.getMessage();
    		}
    	} 
    }
}