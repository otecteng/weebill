require 'spec_helper'

describe SiteWorkersController do
	describe "test reg" do
		params = {:xml=>{:FromUserName=>"from",:ToUserName=>"to"}}
	    xit "register" do
	        params[:xml][:MsgType] = "text"
	        params[:xml][:Content] = "reg"
	        post :wx_create,params
	        response.body.should == "ok registered!"

	    end

	    xit "random input should check worker" do
	        params[:xml][:MsgType] = "text"
	        params[:xml][:Content] = "text"
	        post :wx_create,params
	    end

	    it "a full session" do
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