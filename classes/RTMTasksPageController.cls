public with sharing class RTMTasksPageController
{
    public SObject CurrentObject { get;set; }
    
    public String InfoMessage { get;set; }
    
    public String CurrentVersion { get;set; }
    
    public Boolean IsRTMSync {get;set;}
    
    public RTMTasksPageController(ApexPages.StandardController stdController)
    {
    	CurrentVersion = TestRtmContext.PackageVersion;
        System.Debug('=== RTMTasksPageController ===');
        User currentUser = [SELECT IsRTMTaskBind__c FROM User WHERE Id =:UserInfo.getUserId()];
        
        if(currentUser.IsRTMTaskBind__c)
        {
            System.Debug('====== RTM Task Bind is true ======');
            IsRTMSync = true;        
        }
        else
        {
            System.Debug('====== RTM Task Bind is false ======');
            IsRTMSync = false;
        }
        
        Id parentId = ApexPages.currentPage().getParameters().get('parentid');
    }
    
    public RTMTasksPageController()
    {
    	CurrentVersion = TestRtmContext.PackageVersion;
    	
        System.Debug('=== RTMTasksPageController ===');
        User currentUser = [SELECT IsRTMTaskBind__c FROM User WHERE Id =:UserInfo.getUserId()];
        
        if(currentUser.IsRTMTaskBind__c)
        {
            System.Debug('====== RTM Task Bind is true ======');
            IsRTMSync = true;
        }
        else
        {
            System.Debug('====== RTM Task Bind is false ======');
            IsRTMSync = false;
        }
        
        Id parentId = ApexPages.currentPage().getParameters().get('parentid');
    }
}