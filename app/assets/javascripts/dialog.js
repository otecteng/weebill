;(function($){

	$.fn.dialog = function(options){
		
		console.log(options);
		var default_settings={
			shadow:{
				color:"gray",
				opacity:0.4
			},
			panel:{
				left:"40%",
				top:"30%",
				title:"新窗口"
			},
			buttons:[]
		};

		var settings= $.extend(true,default_settings,options);
		console.log(settings);
		_this=$(this).addClass("panel-body");
		var shadow=$("<div></div>");
		var panel=$("<div></div>").addClass("panel panel-info");
		var buttons_panel=$("<div></div>").append($("<hr>").css({margin:"10px 0 5px 0"}));
		var title_panel=$("<div></div>").addClass("panel-heading");

		var self_close_button=$("<span></span>").addClass("glyphicon glyphicon-remove").css({float:"right",padding:"4px",cursor:"pointer"}).click(function(){panel.hide();shadow.hide();
		});
		var title=$("<p>"+settings.panel.title+"</p>").addClass("panel-title").css("display","inline-block");

		title_panel.append(title).append(self_close_button);
		var button;
		for (var i=0;i<settings.buttons.length;i++){
			button=settings.buttons[i];
			$("<input />").attr({type:"button",value:button.text}).addClass(button.class?button.class:"").css({float:"right","margin-right":"5px"}).click(settings.buttons[i].onclick).appendTo(buttons_panel);
		}

		shadow.hide().css({"position":"absolute","background-color":settings.shadow.color,"top":"0","left":"0","width":"100%","height":"100%","opacity":settings.shadow.opacity,"z-index":"99"}).appendTo("body");

		panel.hide().css({"position":"fixed","top":settings.panel.top,"left":settings.panel.left,"z-index":"100"}).append(title_panel).append(_this).append(buttons_panel).appendTo("body");

		$.fn.close=function(){
			panel.hide();
			shadow.hide();
		}

		$.fn.open=function(){
			panel.show();
			shadow.show();
		}

		return _this;
			
	}


})(jQuery)