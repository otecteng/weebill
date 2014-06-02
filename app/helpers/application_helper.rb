# encoding: utf-8
module ApplicationHelper
	@@controller_dic = {
		"sites"=>"网点",
		"site_workers"=>"网点员工",
		"sms_templates"=>"短信模板",
		"service_orders"=>"安装任务",
		"tb_trades"=>"订单",
		"devise/registrations"=>"用户资料",
		"users"=>"用户资料",
		"brands"=>"车型",
	}
	@@action_dic = {
		"index"=>"列表",
		"new"=>"新建",
		"edit"=>"编辑",
		"import"=>"导入",
		"error"=>"失败订单"
	}	
	def breadcrumb
		ret = "<div id='breadcrumb'>\
			<a href='/'' title='返回主页' class='tip-bottom'><i class='glyphicon glyphicon-home'></i>主页</a>\
			"
		if params[:controller] != "users" then
			ret = ret + "<a href='/#{params[:controller]}' class='current'>#{@@controller_dic[params[:controller]]}</a>\
			<a href='#' class='current'>#{@@action_dic[params[:action]]}</a>"
		end
		ret = (ret + "</div>").html_safe
	end
end
