var SearchResult = {
	display : function(jsonData) {
		Ext.onReady(function() {
			var popupWindow = function(data) {
				console.log('win popup id: ' + data);
				var window = Ext.create('Ext.window.Window', {
				    hight : 400,
				    width : 400,
				    title : 'Contact Us',
				    modal : true,
				    items : [ {
				        xtype : 'form',
				        url : 'submitMessage',
				        width : '100%',
				        items : [ {
				            xtype : 'container',
				            name : 'messageContainer',
				            hidden : true
				        }, {
				            xtype : 'displayfield',
				            fieldLabel : 'Ad Name',
				            value : data.name
				        }, {
				            xtype : 'displayfield',
				            fieldLabel : 'Email',
				            value : data.email
				        }, {
				            xtype : 'displayfield',
				            fieldLabel : 'Phone',
				            value : data.phone
				        }, {
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
						                    html : '<div><b>' + action.result.msg + '</b></div>'
						                });
						                messageContainer.show();
						                setTimeout(function() {
							                messageContainer.hide();
						                }, 2000);
					                },
					                fail : function(form, action) {
						                var messageContainer = Ext.ComponentQuery.query('*[name="messageContainer"]')[0];
						                messageContainer.removeAll();
						                messageContainer.add({
						                    xtype : 'container',
						                    border : 0,
						                    html : '<div><b>' + action.result.msg + '/<b></div>'
						                });
						                messageContainer.show();
						                setTimeout(function() {
							                messageContainer.hide();
						                }, 2000);
					                },
					            });
				            }
				        } ]
				    } ]
				});
				window.show();
			};

			var panel = Ext.create('Ext.panel.Panel', {
			    renderTo : Ext.getBody(),
			    width : '100%',
			    title : 'Search Result',
			    layout : {
				    type : 'vbox'
			    }
			});

			for ( var i = 0; i < jsonData.length; i++) {
				panel.add(Ext.create('Ext.container.Container', {
				    layout : {
					    type : 'hbox'
				    },
				    width : '100%',
				    height : 150,
				    items : [ {
				        width : '20%',
				        height : '100%',
				        xtpye : 'container',
				        border : true,
				        items : [ {
				            xtype : 'container',
				            layout : {
				                type : 'vbox',
				                align : 'center'
				            },
				            items : [ {
				                xtype : 'displayfield',
				                value : jsonData[i].name,
				                margins : '5 5 5 5'
				            }, {
				                xtype : 'button',
				                text : 'Reply',
				                adId : jsonData[i].id,
				                data : jsonData[i],
				                margins : '5 5 5 5',
				                handler : function(t) {
					                console.log(t.data);
					                popupWindow(t.data);
				                }
				            } ]
				        } ]
				    }, {
				        align : 'center',
				        width : '80%',
				        height : '100%',
				        xtpye : 'container',
				        html : jsonData[i].content,
				        border : true
				    } ]
				}));
			}
			;
			panel.doLayout();
		});
	}
};