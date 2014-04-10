;(function($){

	$.fn.dialog = function(options){
		
		_this=$(this);

		var default_settings={
			shadow:{
				color:"gray",
				opacity:0.4
			},
			panel:{
				left:"40%",
				top:"30%",
				title:"新窗口",
			},
			buttons:[]
		};

		var settings= $.extend(default_settings,options);

		var shadow=$("<div></div>");
		var panel=$("<div></div>");
		var buttons_panel=$("<div></div>");
		var title_panel=$("<div></div>");

		var self_close_button=$("<p>&times;</p>").css({display:"inline-block",float:"right"});
		var title=$("<p>"+settings.panel.title+"</p>").css("display","inline-block");

		title_panel.append(title).append(self_close_button);
		
		for (button in settings.buttons){
			$("<input />").attr({type:"button",value:button.text}).css({}).click(button.onclick.call(panel)).appendTo(buttons_panel);
		}

		shadow.hide().css({"position":"absolute","background-color":settings.shadow.color,"top":"0","left":"0","width":"100%","height":"100%","opacity":settings.shadow.opacity,"z-index":"99"}).appendTo("body");

		panel.hide().css({"position":"fixed","top":settings.panel.top,"left":settings.panel.left,"z-index":"100"}).append(title_panel).append(_this).append(buttons_panel).appendTo("body");

		panel.close=function(){
			panel.hide();
			shadow.hide();
		}

		panel.open=function(){
			panel.show();
			shadow.show();
		}

		return panel;
			
	}


})(jQuery)