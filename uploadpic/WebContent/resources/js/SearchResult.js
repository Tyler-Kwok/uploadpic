var SearchResult = {
	display : function(jsonData) {
		Ext.onReady(function() {
			var popupWindow = function(adId) {
				console.log('win popup id: ' + adId);
				var window = Ext.create('Ext.window.Window', {
				    hight : 200,
				    width : 200,
				    title : 'Contact Us',
				    modal : true,
				    items : [ {
				        xtype : 'form',
				        url : 'submitMessage',
				        items : [ {
				            xtype : 'container',
				            name : 'messageContainer',
				            hidden : true
				        }, {
				            xtype : 'textarea',
				            hidden : true,
				            name : 'adId',
				            value : adId
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
			};

			var panel = Ext.create('Ext.panel.Panel', {
			    renderTo : Ext.getBody(),
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
				    height : 150,
				    items : [ {
				        width : '20%',
				        height : '100%',
				        xtpye : 'container',
				        html : 'box20%',
				        border : false,
				        items : [ {
				            xtype : 'button',
				            text : 'Contact Us',
				            adId : jsonData[i].id,
				            handler : function(t) {
					            console.log(t.adId);
					            popupWindow(t.adId);
				            }
				        } ]
				    }, {
				        width : '80%',
				        height : '100%',
				        xtpye : 'container',
				        html : 'box80%',
				        border : false
				    } ]
				}));
			}
			;
			panel.doLayout();
		});
	}
};