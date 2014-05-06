require 'spec_helper'

describe SiteWorkersController do
	describe "test reg" do
		params = {:xml=>{:FromUserName=>"from",:ToUserName=>"to"}}
	    it "register" do
	        params[:xml][:MsgType] = "event"
	        params[:xml][:EventKey] = "reg"
	        post :wx_create,params
	        response.body.should == I18n.t("register")

	        params = {:xml=>{:FromUserName=>"from",:ToUserName=>"to"}}
	        params[:xml][:MsgType] = "text"
	        params[:xml][:Content] = "13816368831"
	        post :wx_create,params
	        response.body.should == I18n.t("need_confirmed")
	    end

	    it "worker can worker upload" do
	    	worker = SiteWorker.create(:wid=>"from")
	    	params = {:xml=>{:FromUserName=>"from",:ToUserName=>"to"}}
	        params[:xml][:MsgType] = "event"
	        params[:xml][:Content] = "report"
	        post :wx_create,params
	        response.body.should == I18n.t("tip_upload_pix")

	        params = {:xml=>{:FromUserName=>"from",:ToUserName=>"to"}}
	        params[:xml][:MsgType] = "image"
	        params[:xml][:MediaId] = "1234"
	        post :wx_create,params
	        p response.body

	        # response.body.should == I18n.t("tip_upload_bill") 
	    end

	    xit "a full session" do
	    	worker = SiteWorker.create(:wid=>"12345",:name=>'test user')
	    	order = ServiceOrder.create()
	        params[:xml][:MsgType] = "text"
	        params[:xml][:Content] = "st"
	        params[:xml][:FromUserName] = worker.wid
	        post :wx_create,params
	        p response.body
	        response.body.match(/^upload your pix/)
	        worker = SiteWorker.find worker.id
	        params[:xml][:MsgType] = "image"
	        params[:xml][:MediaId] = "1234"
	        post :wx_create,params
	        p response.body

	        worker = SiteWorker.find worker.id
	        p worker.site_session
			params[:xml][:MsgType] = "text"
	        params[:xml][:Content] = "#{order.id}"
	        post :wx_create,params
	        p response.body
	    end	    
    end

end