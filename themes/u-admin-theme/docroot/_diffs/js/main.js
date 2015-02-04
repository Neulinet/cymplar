AUI().ready(
	'liferay-hudcrumbs', 'liferay-navigation-interaction', 'liferay-dockbar', 'liferay-sign-in-modal', 'aui-toggler', 'aui-node', 'cookie',
	'event', 'aui-tabview', 'aui-datepicker', 'node-event-simulate','aui-datepicker', 'liferay-calendar-list',

	function(A) {
		var Lang = A.Lang;
		var Util = Liferay.Util;
		var instance = Liferay.Dockbar;
		var navigation = A.one('#navigation');
		
		var siteBreadcrumbs = A.one('#breadcrumbs');
		if (siteBreadcrumbs) {
			siteBreadcrumbs.plug(A.Hudcrumbs);
		}

		var signIn = A.one('li.sign-in a');
		if (signIn && signIn.getData('redirect') !== 'true') {
			signIn.plug(Liferay.SignInModal);
		}
		//Popup My Account
		var myAccount = A.one('#userInfo.link-to-my-account');
		if (myAccount) {
			myAccount.delegate(
				'click',
				function(event) {
					event.preventDefault();
					var currentTarget = event.currentTarget;
					var controlPanelCategory = Lang.trim(currentTarget.attr('data-controlPanelCategory'));
					var uri = currentTarget.attr('href');
					var title = currentTarget.attr('title');
					if (controlPanelCategory) {
						uri = Liferay.Util.addParams('controlPanelCategory=' + controlPanelCategory, uri) || uri;
					}
				  instance.dialog = Liferay.Util.Window.getWindow(
						{
							dialog: {
								align: Util.Window.ALIGN_CENTER,
								width: 600
							},
							title: title,
							uri: uri
						}
					);
				},
				'a.use-dialog'
			);
		} 

		var dropdownUser = A.one('.dropdown-user');
		if(dropdownUser){
			userMenuToggle(A);
		}	

		var accordion = A.one('#contactForm');

		var accordionWrap = A.all('.accordionContact:not(:first-child) .accordionWrap').hide();		
		if(accordion){			
			accordion.delegate('click', function(event){	
				//A.all('.accordionWrap:not(:hidden)').hide();			
				event.currentTarget.toggleClass("active");
				event.currentTarget.ancestor().one('.accordionWrap').toggle();
			}, '.dropdown .dropdown-toggle');				
		}

		var dropdownFunction = A.one('#navigation');
		if(dropdownFunction){			
			dropdownFunction.delegate('click', function(event){				   
				event.preventDefault();	
				event.currentTarget.ancestor().one('.child-menu').toggle();
			}, '.dropdown .dropdown-toggle');				
		}		
	

		// Tab Plugin
		var tab = A.one('#dashboard-tabs');
		if(tab){
			tabs(A, '#dashboard-tabs');			
		}
		var tabAdds = A.one('#dashboard-tabs-add');
		if(tabAdds){
			tabs(A, '#dashboard-tabs-add');
		}
		var tabData = A.one('#tabs');
		if(tabData){
			tabs(A, '#tabs');
		}
		var uadminCalendar = A.one('#mycalendar');
		if(uadminCalendar) {
			calendar(A);
		}		

		var dashboardTable = A.all('#dashboard-table');
		if(dashboardTable){
			editableTable(A);	
		}
	}		
);

// Dropdown user menu
function userMenuToggle(A) {
	new A.Toggler(
		{ 
			container: '.dropdown-user',
			content: '.user-menu',
			expanded: false,
			header: '#toggle'
		}
	);
}

// For display main navigation submenu 
function dropdownTest(A, myList) {
	new A.Toggler(
		{ 
			container: '.dropdown',
			content: '.dropdown-menu',
			expanded: false,
			header: myList
		}
	);
}

// Tabs
function tabs(A, node) {
	var tabs = new A.TabView(
	  {
		srcNode: node
	  }
	).render();   

	tabs.on('click', function(event) {
		var activeTab = A.one(tabs.getActiveTab());
		var fireTabNumber = activeTab.attr("data-fire-tab");
		var fireTabBox = activeTab.attr("data-tab-box");
 		A.Cookie.set('selectedTab_'+node, activeTab.attr("data-index"), { path: "/" });
 		var liSel = A.all("#" + fireTabBox + " li").item(fireTabNumber);
 		if(!liSel.hasClass('active'))
 			liSel.simulate("click");
	}, ".tabs");

	if(A.Cookie.exists('selectedTab_'+node)){
		tabs.selectChild(A.Cookie.get('selectedTab_'+node));
	}

	return tabs;
}

// Calendar
function calendar(A) {
	var calendar = new A.Calendar(
		{
			contentBox: "#mycalendar",
			height:'auto',
			width:'100%',
			showPrevMonth: true,
			showNextMonth: true		
		}
	).render();

	A.one('[class*="calendarnav-prevmonth"]').addClass('fa fa-angle-left');
	A.one('[class*="calendarnav-nextmonth"]').addClass('fa fa-angle-right');		
}

// Dashboard editable table
function editableTable(A) {
	A.all('#dashboard-table').each(function(child) { 
		child.all('.apply').hide(); 
		child.all('input[type="text"]').set('disabled', true);
								
		child.all('tr').each(function(){
			this.delegate('click',function(event){
				event.preventDefault();	
				var input = event.currentTarget.ancestor("tr").all('input[type="text"]'); 
				var apply = event.currentTarget.ancestor("tr").all('.apply');
				var edit = event.currentTarget.ancestor('tr').all('.edit'); 

				if (apply.hide()) {
					input.set('disabled', false);
					apply.show();
				}

			}, '.edit');
				this.delegate('click',function(event){
				event.preventDefault();	
				var input = event.currentTarget.ancestor("tr").all('input[type="text"]'); 
				var apply = event.currentTarget.ancestor("tr").all('.apply');
				var edit = event.currentTarget.ancestor('tr').all('.edit'); 

				if (apply.show()) {
					input.set('disabled', true);
					apply.hide();
				}
				
			}, '.apply');
		});		
		child.one('.delete').on('click', function(){
			var parent = child.all(':checkbox:checked').get('parentNode');
			var removeRow = parent.get('parentNode');			
			removeRow.remove();								
		});	
		child.one('.select-all').on('click', function(event){	
			if (event.target.attr('checked')) {
				child.all(':checkbox').set('checked', true);	
			} else {
				child.all(':checkbox').set('checked', false);	
			}							
		});		          
	});	
}   

