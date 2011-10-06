public without sharing class TestRtmResponses {
	
	public static String GetTestRtmData(String methodName)
	{
		String result = '';
		if(methodName.equals('rtm.lists.getList'))
        {
        	result = GetRtmLists();
        }
        if(methodName.equals('rtm.tasks.getList'))
        {
        	result = GetRtmTasks();
        }
        if(methodName.equals('rtm.timelines.create'))
        {
        	result = GetRtmTimeLine();
        }
        if(methodName.equals('rtm.lists.add'))
        {
        	result = GetRtmCreateList();
        }
        if(methodName.equals('rtm.tasks.add'))
        {
        	result = GetRtmAddTask();
        }
        if(methodName.equals('rtm.tasks.setDueDate'))
        {
        	result = GetRtmSetDueDate();
        }
        if(methodName.equals('rtm.tasks.setPriority'))
        {
        	result = GetRtmSetPriority();
        }
        if(methodName.equals('rtm.tasks.setName'))
        {
        	result = GetRtmSetName();
        }
        
        if(methodName.equals('rtm.tasks.complete'))
        {
        	result = GetRtmSetComplete();
        }
        if(methodName.equals('rtm.tasks.uncomplete'))
        {
        	result = GetRtmSetUncomplete();
        }
        if(methodName.equals('rtm.auth.checkToken'))
        {
        	result = GetRtmCheckRTMAuthToken();
        }
        if(methodName.equals('rtm.auth.getFrob'))
        {
        	result = GetRtmGetRtmFrob();
        }
        if(methodName.equals('rtm.auth.getToken'))
        {
        	result = GetRtmGetRTMAuthToken();
        }
        
        return result;
	}
	
	private static String GetRtmLists()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<lists>
				<list id="100653" name="Inbox" deleted="0" locked="1" archived="0" position="-1" smart="0" />
				<list id="387549" name="High Priority" deleted="0" locked="0" archived="0" position="0" smart="1">
					<filter>(priority:1)</filter>
				</list>
				<list id="387546" name="New List" deleted="0" locked="0" archived="0" position="0" smart="0" />
				<list id="100654" name="Personal" deleted="0" locked="0" archived="0" position="0" smart="0" />
				<list id="100655" name="Study" deleted="0" locked="0" archived="0" position="0" smart="0" />
				<list id="100656" name="Work" deleted="0" locked="0" archived="0" position="0" smart="0" />
				<list id="100657" name="Sent" deleted="0" locked="1" archived="0" position="1" smart="0" />
			</lists>
		</rsp>			
		*/
		
		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		writer.writeStartElement(null, 'lists', null);
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '100653');
		writer.writeAttribute(null, null, 'name', 'Inbox');
		writer.writeEndElement();
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '387549');
		writer.writeAttribute(null, null, 'name', 'High Priority');
		writer.writeEndElement();
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '387546');
		writer.writeAttribute(null, null, 'name', 'New List');
		writer.writeEndElement();
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '100654');
		writer.writeAttribute(null, null, 'name', 'Personal');
		writer.writeEndElement();
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '100655');
		writer.writeAttribute(null, null, 'name', 'Study');
		writer.writeEndElement();

		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '100656');
		writer.writeAttribute(null, null, 'name', 'Work');
		writer.writeEndElement();
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '100657');
		writer.writeAttribute(null, null, 'name', 'Sent');
		writer.writeEndElement();
		
		writer.writeEndElement();
		writer.writeEndElement();
		writer.writeEndDocument();

		String result = writer.getXmlString(); 
		writer.close();

		return result;
	}
	
	private static String GetRtmTasks()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
			<rsp stat="ok">
				<tasks>
					<list id="9405702"/>
					<list id="9405701">
						<taskseries id="44697893" created="2009-07-13T07:53:54Z" modified="2009-07-13T07:54:34Z" name="sync pivotal tracker stories to toggl" source="js" url="" location_id="">
							<tags/><participants/><notes/>
							<task id="63766922" due="" has_due_time="0" added="2009-07-13T07:53:54Z" completed="" deleted="" priority="N" postponed="0" estimate=""/>
						</taskseries>
					</list>
					<list id="9405700"/>
					<list id="10503627"/>
					<list id="10503706">
						<taskseries id="51574857" created="2009-10-07T09:34:26Z" modified="2009-10-07T09:34:26Z" name="1" source="api" url="" location_id="">
							<tags/><participants/><notes/>
							<task id="73742256" due="" has_due_time="0" added="2009-10-07T09:34:26Z" completed="" deleted="" priority="N" postponed="0" estimate=""/>
						</taskseries>
					</list>
					<list id="9405699">
						<taskseries id="44692844" created="2009-07-13T06:26:40Z" modified="2009-07-13T06:26:40Z" name="Try out Remember The Milk" source="js" url="" location_id="">
							<tags/><participants/><notes/>
							<task id="63758436" due="2009-07-13T06:26:00Z" has_due_time="1" added="2009-07-13T06:26:40Z" completed="" deleted="" priority="1" postponed="0" estimate=""/>
						</taskseries>
					</list>
					<list id="10970004"/>
					<list id="9405703"/>
					<list id="9405698">
						<taskseries id="54933554" created="2009-11-13T10:04:41Z" modified="2009-11-13T10:04:43Z" name="test_rtm_task_11" source="api" url="" location_id="">
							<tags/><participants/><notes/>
							<task id="78626944" due="2009-11-23T22:00:00Z" has_due_time="0" added="2009-11-13T10:04:41Z" completed="" deleted="" priority="2" postponed="0" estimate=""/>
						</taskseries>
						<taskseries id="54933980" created="2009-11-13T10:12:03Z" modified="2009-11-13T10:12:05Z" name="test_rtm_22" source="api" url="" location_id="">
							<tags/><participants/><notes/>
							<task id="78627378" due="2009-11-21T22:00:00Z" has_due_time="0" added="2009-11-13T10:12:03Z" completed="2009-11-13T10:04:41Z" deleted="" priority="2" postponed="0" estimate=""/>
						</taskseries>
						<taskseries id="54898562" created="2009-11-13T00:00:27Z" modified="2009-11-13T00:04:29Z" name="remember_to_test_rtm_tasks!" source="api" url="" location_id="">
							<tags/><participants/>
							<notes>
								<note id="7751018" created="2009-11-13T00:04:29Z" modified="2009-11-13T00:04:29Z" title="">this is another test note</note>
								<note id="7751017" created="2009-11-13T00:04:22Z" modified="2009-11-13T00:04:22Z" title="">this is a test note</note>
							</notes>
							<task id="78568424" due="2009-11-11T22:00:00Z" has_due_time="0" added="2009-11-13T00:00:27Z" completed="" deleted="" priority="2" postponed="0" estimate=""/>
						</taskseries>
					</list>
				</tasks>
			</rsp>
		*/
		
		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		writer.writeStartElement(null, 'tasks', null);
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405702');
		writer.writeEndElement();//list
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405701');
	
		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '44697893');
		writer.writeAttribute(null, null, 'created', '2009-07-13T07:53:54Z');
		writer.writeAttribute(null, null, 'modified', '2009-07-13T07:54:34Z');
		writer.writeAttribute(null, null, 'name', 'sync pivotal tracker stories to toggl');
		writer.writeAttribute(null, null, 'source', 'js');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '63766922');
		writer.writeAttribute(null, null, 'due', '');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-07-13T07:53:54Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', 'N');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeEndElement();//list
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405700');
		writer.writeEndElement();//list
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '10503627');
		writer.writeEndElement();//list
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '10503706');
		
		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '51574857');
		writer.writeAttribute(null, null, 'created', '2009-10-07T09:34:26Z');
		writer.writeAttribute(null, null, 'modified', '2009-10-07T09:34:26Z');
		writer.writeAttribute(null, null, 'name', '1');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes

		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '73742256');
		writer.writeAttribute(null, null, 'due', '');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-10-07T09:34:26Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', 'N');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
				
		writer.writeEndElement();//list

		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405699');
		
		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '44692844');
		writer.writeAttribute(null, null, 'created', '2009-07-13T06:26:40Z');
		writer.writeAttribute(null, null, 'modified', '2009-07-13T06:26:40Z');
		writer.writeAttribute(null, null, 'name', 'Try out Remember The Milk');
		writer.writeAttribute(null, null, 'source', 'js');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '63758436');
		writer.writeAttribute(null, null, 'due', '2009-07-13T06:26:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '1');
		writer.writeAttribute(null, null, 'added', '2009-07-13T06:26:40Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', '1');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeEndElement();//list
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '10970004');
		writer.writeEndElement();//list
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405703');
		writer.writeEndElement();//list
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405698');

		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '54933554');
		writer.writeAttribute(null, null, 'created', '2009-11-13T10:04:41Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-13T10:04:43Z');
		writer.writeAttribute(null, null, 'name', 'test_rtm_task_11');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '78626944');
		writer.writeAttribute(null, null, 'due', '2009-11-23T22:00:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-13T10:04:41Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', '2');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '54933980');
		writer.writeAttribute(null, null, 'created', '2009-11-13T10:12:03Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-13T10:12:05Z');
		writer.writeAttribute(null, null, 'name', 'test_rtm_22');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '78627378');
		writer.writeAttribute(null, null, 'due', '2009-11-21T22:00:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-13T10:12:03Z');
		writer.writeAttribute(null, null, 'completed', '2009-11-13T10:04:41Z');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', '2');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '54898562');
		writer.writeAttribute(null, null, 'created', '2009-11-13T00:00:27Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-13T00:04:29Z');
		writer.writeAttribute(null, null, 'name', 'remember_to_test_rtm_tasks!');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeStartElement(null, 'note', null);
		writer.writeAttribute(null, null, 'id', '7751018');
		writer.writeAttribute(null, null, 'created', '2009-11-13T00:04:29Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-13T00:04:29Z');
		writer.writeAttribute(null, null, 'title', '');
		writer.writeCharacters('this is another test note');
		writer.writeEndElement();//note
		writer.writeStartElement(null, 'note', null);
		writer.writeAttribute(null, null, 'id', '7751017');
		writer.writeAttribute(null, null, 'created', '2009-11-13T00:04:22Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-13T00:04:22Z');
		writer.writeAttribute(null, null, 'title', '');
		writer.writeCharacters('this is a test note');
		writer.writeEndElement();//note
		writer.writeEndElement();//notes
	
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '78568424');
		writer.writeAttribute(null, null, 'due', '2009-11-11T22:00:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-13T00:00:27Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', '2');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
				
		writer.writeEndElement();//list
		
		writer.writeEndElement();//tasks
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- Tasks Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmTimeLine()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<timeline>129953056</timeline>
		</rsp>
		*/
		
		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'timeline', null);
		writer.writeCharacters('129953056');
		writer.writeEndElement();//timeline
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- TimeLine Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmCreateList()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<transaction id="1293270611" undoable="0"/>
			<list id="11057156" name="SF_List" deleted="0" locked="0" archived="0" position="0" smart="0" sort_order="0"/>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'transaction', null);
		writer.writeAttribute(null, null, 'id', '1293270611');
		writer.writeAttribute(null, null, 'undoable', '0');
		writer.writeEndElement();//transaction
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '11057156');
		writer.writeAttribute(null, null, 'name', 'SF_List');
		writer.writeAttribute(null, null, 'deleted', '0');
		writer.writeAttribute(null, null, 'locked', '0');
		writer.writeAttribute(null, null, 'archived', '0');
		writer.writeAttribute(null, null, 'position', '0');
		writer.writeAttribute(null, null, 'smart', '0');
		writer.writeAttribute(null, null, 'sort_order', '0');
		writer.writeEndElement();//list
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- AddRtmList Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmAddTask()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<transaction id="1296853633" undoable="0"/>
			<list id="9405698">
				<taskseries id="55282876" created="2009-11-17T12:25:30Z" modified="2009-11-17T12:25:30Z" name="TestAddSFTask" source="api" url="" location_id="">
					<tags/><participants/><notes/>
					<task id="79149141" due="" has_due_time="0" added="2009-11-17T12:25:30Z" completed="" deleted="" priority="N" postponed="0" estimate=""/>
				</taskseries>
			</list>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'transaction', null);
		writer.writeAttribute(null, null, 'id', '1296853633');
		writer.writeAttribute(null, null, 'undoable', '0');
		writer.writeEndElement();//transaction
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405698');

		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '55282876');
		writer.writeAttribute(null, null, 'created', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'name', 'TestAddSFTask');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes

		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '79149141');
		writer.writeAttribute(null, null, 'due', '');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', 'N');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
				
		writer.writeEndElement();//list
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- AddRtmTask Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmSetDueDate()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<transaction id="1296853716" undoable="1"/>
			<list id="9405698">
				<taskseries id="55282876" created="2009-11-17T12:25:30Z" modified="2009-11-17T12:25:31Z" name="TestAddSFTask" source="api" url="" location_id="">
					<tags/><participants/><notes/>
					<task id="79149141" due="2009-11-26T22:00:00Z" has_due_time="0" added="2009-11-17T12:25:30Z" completed="" deleted="" priority="N" postponed="0" estimate=""/>
				</taskseries>
			</list>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'transaction', null);
		writer.writeAttribute(null, null, 'id', '1296853716');
		writer.writeAttribute(null, null, 'undoable', '1');
		writer.writeEndElement();//transaction
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405698');

		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '55282876');
		writer.writeAttribute(null, null, 'created', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'name', 'TestAddSFTask');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '79149141');
		writer.writeAttribute(null, null, 'due', '2009-11-26T22:00:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', 'N');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeEndElement();//list
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- SetDueDate Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmSetPriority()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<transaction id="1296853762" undoable="1"/>
			<list id="9405698">
				<taskseries id="55282876" created="2009-11-17T12:25:30Z" modified="2009-11-17T12:25:32Z" name="TestAddSFTask" source="api" url="" location_id="">
					<tags/><participants/><notes/>
					<task id="79149141" due="2009-11-26T22:00:00Z" has_due_time="0" added="2009-11-17T12:25:30Z" completed="" deleted="" priority="2" postponed="0" estimate=""/>
				</taskseries>
			</list>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'transaction', null);
		writer.writeAttribute(null, null, 'id', '1296853762');
		writer.writeAttribute(null, null, 'undoable', '1');
		writer.writeEndElement();//transaction
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405698');

		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '55282876');
		writer.writeAttribute(null, null, 'created', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-17T12:25:32Z');
		writer.writeAttribute(null, null, 'name', 'TestAddSFTask');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '79149141');
		writer.writeAttribute(null, null, 'due', '2009-11-26T22:00:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', '2');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeEndElement();//list
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- SetPriority Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmSetName()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<transaction id="1296853762" undoable="1"/>
			<list id="9405698">
				<taskseries id="55282876" created="2009-11-17T12:25:30Z" modified="2009-11-17T12:25:32Z" name="TestAddSFTask" source="api" url="" location_id="">
					<tags/><participants/><notes/>
					<task id="79149141" due="2009-11-26T22:00:00Z" has_due_time="0" added="2009-11-17T12:25:30Z" completed="" deleted="" priority="2" postponed="0" estimate=""/>
				</taskseries>
			</list>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'transaction', null);
		writer.writeAttribute(null, null, 'id', '1296853762');
		writer.writeAttribute(null, null, 'undoable', '1');
		writer.writeEndElement();//transaction
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405698');

		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '55282876');
		writer.writeAttribute(null, null, 'created', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-17T12:25:32Z');
		writer.writeAttribute(null, null, 'name', 'TestAddSFTask');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '79149141');
		writer.writeAttribute(null, null, 'due', '2009-11-26T22:00:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', '2');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeEndElement();//list
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- SetName Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmSetComplete()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<transaction id="1296853762" undoable="1"/>
			<list id="9405698">
				<taskseries id="55282876" created="2009-11-17T12:25:30Z" modified="2009-11-17T12:25:32Z" name="TestAddSFTask" source="api" url="" location_id="">
					<tags/><participants/><notes/>
					<task id="79149141" due="2009-11-26T22:00:00Z" has_due_time="0" added="2009-11-17T12:25:30Z" completed="2009-11-18T20:18:28Z" deleted="" priority="2" postponed="0" estimate=""/>
				</taskseries>
			</list>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'transaction', null);
		writer.writeAttribute(null, null, 'id', '1296853762');
		writer.writeAttribute(null, null, 'undoable', '1');
		writer.writeEndElement();//transaction
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405698');

		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '55282876');
		writer.writeAttribute(null, null, 'created', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-17T12:25:32Z');
		writer.writeAttribute(null, null, 'name', 'TestAddSFTask');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '79149141');
		writer.writeAttribute(null, null, 'due', '2009-11-26T22:00:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', '2');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeEndElement();//list
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- SetComplete Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmSetUncomplete()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<transaction id="1296853762" undoable="1"/>
			<list id="9405698">
				<taskseries id="55282876" created="2009-11-17T12:25:30Z" modified="2009-11-17T12:25:32Z" name="TestAddSFTask" source="api" url="" location_id="">
					<tags/><participants/><notes/>
					<task id="79149141" due="2009-11-26T22:00:00Z" has_due_time="0" added="2009-11-17T12:25:30Z" completed="2009-11-18T20:18:28Z" deleted="" priority="2" postponed="0" estimate=""/>
				</taskseries>
			</list>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'transaction', null);
		writer.writeAttribute(null, null, 'id', '1296853762');
		writer.writeAttribute(null, null, 'undoable', '1');
		writer.writeEndElement();//transaction
		
		writer.writeStartElement(null, 'list', null);
		writer.writeAttribute(null, null, 'id', '9405698');

		writer.writeStartElement(null, 'taskseries', null);
		writer.writeAttribute(null, null, 'id', '55282876');
		writer.writeAttribute(null, null, 'created', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'modified', '2009-11-17T12:25:32Z');
		writer.writeAttribute(null, null, 'name', 'TestAddSFTask');
		writer.writeAttribute(null, null, 'source', 'api');
		writer.writeAttribute(null, null, 'url', '');
		writer.writeAttribute(null, null, 'location_id', '');
		
		writer.writeStartElement(null, 'tags', null);
		writer.writeEndElement();//tags
		
		writer.writeStartElement(null, 'participants', null);
		writer.writeEndElement();//participants
		
		writer.writeStartElement(null, 'notes', null);
		writer.writeEndElement();//notes
		
		writer.writeStartElement(null, 'task', null);
		writer.writeAttribute(null, null, 'id', '79149141');
		writer.writeAttribute(null, null, 'due', '2009-11-26T22:00:00Z');
		writer.writeAttribute(null, null, 'has_due_time', '0');
		writer.writeAttribute(null, null, 'added', '2009-11-17T12:25:30Z');
		writer.writeAttribute(null, null, 'completed', '');
		writer.writeAttribute(null, null, 'deleted', '');
		writer.writeAttribute(null, null, 'priority', '2');
		writer.writeAttribute(null, null, 'postponed', '0');
		writer.writeAttribute(null, null, 'estimate', '');
		writer.writeEndElement();//task
				
		writer.writeEndElement(); //taskseries
		
		writer.writeEndElement();//list
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- SetUncomplete Xml: ' + result); 
		writer.close();

		return result;
	}	
	
	private static String GetRtmCheckRTMAuthToken()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<auth>
				<token>141daf3b5a7019772494e6289771c1e11a2ead61</token>
				<perms>delete</perms>
				<user id="1538815" username="alex.merkulov" fullname="Alex Merkulov"/>
			</auth>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'auth', null);
		
		writer.writeStartElement(null, 'token', null);
		writer.writeCharacters('141daf3b5a7019772494e6289771c1e11a2ead61');
		writer.writeEndElement();//token
		
		writer.writeStartElement(null, 'perms', null);
		writer.writeCharacters('delete');
		writer.writeEndElement();//perms
		
		writer.writeStartElement(null, 'user', null);
		writer.writeAttribute(null, null, 'id', '');
		writer.writeAttribute(null, null, 'username', 'alex.merkulov');
		writer.writeAttribute(null, null, 'fullname', 'Alex Merkulov');
		writer.writeEndElement();//user
				
		writer.writeEndElement();//auth
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- CheckRTMAuthToken Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmGetRTMFrob()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<frob>0a56717c3561e53584f292bb7081a533c197270c</frob>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'frob', null);
		writer.writeCharacters('0a56717c3561e53584f292bb7081a533c197270c');
		writer.writeEndElement();//frob
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- GetRTMFrob Xml: ' + result); 
		writer.close();

		return result;
	}
	
	private static String GetRtmGetRTMAuthToken()
	{
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<rsp stat="ok">
			<auth>
				<token>141daf3b5a7019772494e6289771c1e11a2ead61</token>
				<perms>delete</perms>
				<user id="1538815" username="alex.merkulov" fullname="Alex Merkulov"/>
			</auth>
		</rsp>
		*/

		XmlStreamWriter writer = new XmlStreamWriter();
		
		writer.writeStartDocument('UTF-8', '1.0');
		writer.writeStartElement(null, 'rsp', null);
		writer.writeAttribute(null, null, 'stat', 'ok');
		
		writer.writeStartElement(null, 'auth', null);
		
		writer.writeStartElement(null, 'token', null);
		writer.writeCharacters('141daf3b5a7019772494e6289771c1e11a2ead61');
		writer.writeEndElement();//token
		
		writer.writeStartElement(null, 'perms', null);
		writer.writeCharacters('delete');
		writer.writeEndElement();//perms
		
		writer.writeStartElement(null, 'user', null);
		writer.writeAttribute(null, null, 'id', '');
		writer.writeAttribute(null, null, 'username', 'alex.merkulov');
		writer.writeAttribute(null, null, 'fullname', 'Alex Merkulov');
		writer.writeEndElement();//user
				
		writer.writeEndElement();//auth
		
		writer.writeEndElement();//rsp
		writer.writeEndDocument();

		String result = writer.getXmlString();
		System.Debug('----- GetRTMAuthToken Xml: ' + result); 
		writer.close();

		return result;
	}	
}