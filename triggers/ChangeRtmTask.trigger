trigger ChangeRtmTask on Task (after insert, after update) {

    User currentUser = [SELECT IsRTMTaskBind__c FROM User WHERE Id =:UserInfo.getUserId()];
    
    if(currentUser.IsRTMTaskBind__c)
    {
        if(System.Trigger.isInsert && !RTMController.IsRtmSyncUpdate)
        {
            System.Debug('-------- Is Insert Trigger ---------');

            Set<Id> insertedTasks = new Set<Id>();
        
            for(Task t : Trigger.new)
            {
                insertedTasks.add(t.Id);
            }
    
            RtmController.AsyncInsertRtmTask(insertedTasks);
        }
        
        if(System.Trigger.isUpdate && !RTMController.IsRtmSyncUpdate)
        {
			Set<Id> updatedTasks = new Set<Id>();
            
            System.Debug('-------- Is Update Trigger ---------');
            for(Task t : Trigger.new)
            {
                if(t.RTMActivityId__c != null && t.RTMActivityId__c.Length() > 0)
                {
                	Boolean shouldUpdate = false;
					for(Task tOld : Trigger.old)
                    {
                        if(tOld.Id == t.Id)
                        {
                        	if((tOld.Status == null && t.Status != null) || !tOld.Status.equals(t.Status))
                        	{
                        		shouldUpdate = true;
                        	}
                        	
                        	if((tOld.Subject == null && t.Subject != null) || !tOld.Subject.equals(t.Subject))
                        	{
                        		shouldUpdate = true;
                        	}
                        	
                        	if(
                        		(tOld.ActivityDate == null && t.ActivityDate != null) || 
                        		(tOld.ActivityDate != null && t.ActivityDate != null && tOld.ActivityDate.daysBetween(t.ActivityDate) != 0)
                        	)
                        	{
                        		shouldUpdate = true;
                        	}

                        	if(!tOld.Priority.equals(t.Priority))
                        	{
                        		shouldUpdate = true;
                        	}
                        }                   
                    }
                    
                    if(shouldUpdate)
                    {                    	
                		updatedTasks.add(t.Id);
                    }
                }
            }
            
            RtmController.AsyncUpdateRtmTask(updatedTasks);
        }
     }
}