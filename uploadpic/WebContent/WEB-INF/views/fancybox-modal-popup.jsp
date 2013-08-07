<!doctype html>
<html lang="en">
<head>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>jQuery Modal Contact Demo</title>

<script type="text/javascript"
	src="<c:url value="/resources/extjs-4.2.1/ext-all.js" /> "></script>
<link rel="stylesheet"
	href="<c:url value="/resources/extjs-4.2.1/resources/css/ext-all-gray.css" />"
	type="text/css"></link>
<script type="text/javascript">
	Ext.onReady(function() {
	    //Ext.MessageBox.alert('asdf','asdf');
	    var sendButton = Ext.ComponentQuery.query('button[name="send"]');
	    Ext.create('Ext.panel.Panel', {
	        renderTo : Ext.getBody(),
	        title : 'Contact Us',
	        layout : {
	            type : 'vbox',
	            align : 'center'
	        },
	        items : [ {
	            xtype : 'button',
	            text : 'Contact Us',
	            handler : function() {
		            var window = Ext.create('Ext.window.Window', {
		                hight : 200,
		                width : 200,
		                title : 'Contact Us',
		                modal : true,
		                layout : {
		                    type : 'vbox',
		                    align : 'center'
		                },
		                title : 'Contact Us',
		                items : [ {
		                    xtype : 'form',
		                    url : 'submitMessage',
		                    items : [ {
		                        name : 'message',
		                        xtype : 'textarea',
		                        emptyText : 'enter message',
		                        height : 100,
		                        allowBlank : false,
		                        margin : '5 5 5 5',
		                    }, {
		                        name : 'email',
		                        xtype : 'textfield',
		                        label : 'email',
		                        emptyText : 'enter your email',
		                        allowBlank : false,
		                        margin : '5 5 5 5',
		                    }, {
		                        xtype : 'container',
		                        name : 'messageContainer',
		                        hidden : true
		                    }, {
		                        xtype : 'button',
		                        text : 'Send Email',
		                        handler : function() {
			                        Ext.ComponentQuery.query('form')[0].submit({
				                        success : function(form, action) {
					                        var messageContainer = Ext.ComponentQuery.query('*[name="messageContainer"]')[0];
					                        messageContainer.removeAll();
					                        messageContainer.add({
					                            xtype : 'container',
					                            border : 0,
					                            html : '<div><ul>' + action.result.msg + '</ul></div>'
					                        });
					                        messageContainer.show();
					                        setTimeout(function() {
					                        	messageContainer.hide();
					                        }, 1000);
				                        },
				                        fail : function(form, action) {
					                        var messageContainer = Ext.ComponentQuery.query('*[name="messageContainer"]')[0];
					                        messageContainer.removeAll();
					                        messageContainer.add({
					                            xtype : 'container',
					                            border : 0,
					                            html : '<div><ul>' + action.result.msg + '</ul></div>'
					                        });
					                        messageContainer.show();
					                        setTimeout(function() {
					                        	messageContainer.hide();
					                        }, 1000);
				                        },
			                        });
		                        }
		                    } ]
		                } ]
		            });
		            window.show();
	            }
	        } ]
	    })
    });
</script>
</head>

<body>
</body>
</html>